Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab2HAPrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:47:04 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:46545
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226Ab2HAPrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:47:01 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q71FkesX031280
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Rob Landley <rob@landley.net>
Cc: Milton Miller <miltonm@bga.com>, Borislav Petkov <bp@alien8.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] netconsole.txt: "nc" needs "-p" to specify the listening port
In-Reply-To: <501937F7.2070600@landley.net> (Rob Landley's message of "Wed, 01
	Aug 2012 09:06:47 -0500")
References: <gilii4nnxb.fsf@mx10.gouders.net> <kernel-nc-hints@mdm.bga.com>
	<501937F7.2070600@landley.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Wed, 01 Aug 2012 17:46:38 +0200
Message-ID: <gi3946lin5.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Wed, 01 Aug 2012 17:46:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:

> On 07/29/2012 03:40 AM, Milton Miller wrote:
>> [adding Rob as Doc maintanier]
>> 
>> On Sat, 28 Jul 2012 about 11:08:16 -0000, Dirk Gouders wrote:
>>> Borislav Petkov <bp@alien8.de> writes:
>>>
>>>> On Fri, Jul 27, 2012 at 11:24:53AM +0200, Dirk Gouders wrote:
>>>>> Cong Wang <xiyou.wangcong@gmail.com> writes:
>>>>>
>>>>>> On Fri, Jul 27, 2012 at 2:35 PM, Dirk Gouders
>>>>>> <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
>>>>>>> Hi Jesse,
>>>>>>>
>>>>>>> I would like to ask you to check if the documentation of "nc" in
>>>>>>> netconsole.txt is still correct.  I tried two different netcat packages
>>>>>>> and both require "-p" to specify the listening port.  I am wondering if
>>>>>>> that changed after the use of "nc" has been documented.
>>>>>>
>>>>>> On Fedora 16, `nc -u -l <port number>` works fine.
>>>>>
>>>>> Thanks for checking that.
>>>>>
>>>>> If the information I found is correct, Fedora uses OpenBSD's nc
>>>>> codebase.  The two netcat packages I tested on a Gentoo system differ in
>>>>> requiring the -p switch for the port specification.
>>>>
>>>> So say exactly that in the doc: that the *BSD's version of nc doesn't
>>>> need the port number specified with '-p' and you're covered.
>>> OK, I tried that in the attached patch.
>>> I'm not sure if every exeption needs to/should be documented, though.
>>>
>>> >From 3cdeac3e814471053129145c5fa8391acb365fd8 Mon Sep 17 00:00:00 2001
>>> From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
>>> Date: Sat, 28 Jul 2012 12:32:49 +0200
>>> Subject: [PATCH] netconsole.txt: non-BSD versions of nc(1) require '-p'
>>>  switch
>>>
>>> Gentoo for example uses non-BSD versions of nc(1) which require
>>> the '-p' switch to specify the listening port.
>>>
>>> ---
>>> Documentation/networking/netconsole.txt |    3 ++-
>>>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> Did this ever resolve to a specific recommended patch? The one at the
> start of the thread:
>
>  http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/01995.html
>
> Apparently isn't it...?

Sorry for the delay.
I tested the situation on a few distributions and am still thinking
about a proper way to write it in a way without netconsole.txt becoming
a kind of "netcat.txt".

I would be glad about comments to what I currently have -- also, because
I am not a native English speaker:

------------------------------------------------------------------------
The remote host can run syslogd or netcat to receive the kernel
messages.  On distributions using a BSD-based netcat version
(e.g. Fedora, openSUSE and Ubuntu) the listening port must be
specified without the -p switch:

'nc -u -l -p <port>' / 'nc -u -l <port>' or
'netcat -u -l -p <port>' / 'netcat -u -l <port>'
------------------------------------------------------------------------

At the end, I also attach what I have noted during the tests with the
different distributions.

Dirk

------------------------------------------------------------------------
Problem on systems where the gnu-netcat package provides a symbolic
link /usr/bin/nc -> /usr/bin/netcat:

gnu-netcat requires -p to specify the local port but does not complain
if invoked as `nc -l -u <port>'; you need to use -v to see that it
does not do what you might expect:

# nc -l -u 4444 -v
Warning: Inverse name lookup failed for `0.0.17.92'
------------------------------------------------------------------------

Distro		Package						needs -p
		Command invocation
========================================================================
Arch		gnu-netcat					yes
(Website	nc | netcat
 documentation)
		openbsd-netcat					no
		nc.openbsd
------------------------------------------------------------------------
Debian-6.0.5	netcat-openbsd					no 
		nc | netcat | nc.openbsd		   
		                                   
		netcat / netcat-traditional (preinstalled)	yes
		nc | netcat
		                                   
		netcat6						yes
		nc | netcat | nc6
------------------------------------------------------------------------
Fedora-17	nc (preinstalled)				no
		nc

		nc6
		nc6						yes
------------------------------------------------------------------------
Gentoo		gnu-netcat					yes
		netcat

		netcat						yes
		nc

		netcat6						yes
		nc | nc6
------------------------------------------------------------------------
OpenSUSE-12.1	netcat-openbsd					no
		nc | netcat
------------------------------------------------------------------------
Ubuntu-12.04	netcat-openbsd (preinstalled)			no 
Desktop		nc | netcat | nc.openbsd
		                                   
		netcat / netcat-traditional			yes
		nc | netcat		   
		                                   
		netcat6						yes
		nc | netcat | nc6
------------------------------------------------------------------------

