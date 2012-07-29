Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab2G2LxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 07:53:01 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:44748
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642Ab2G2LxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 07:53:00 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q6TBqhCe011353
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Milton Miller <miltonm@bga.com>
Cc: Borislav Petkov <bp@alien8.de>, Cong Wang <xiyou.wangcong@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>
Subject: Re: [RFC] netconsole.txt: "nc" needs "-p" to specify the listening port
In-Reply-To: <kernel-nc-hints@mdm.bga.com> (Milton Miller's message of "Sun,
	29 Jul 2012 03:40:04 -0500")
References: <gilii4nnxb.fsf@mx10.gouders.net> <kernel-nc-hints@mdm.bga.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Sun, 29 Jul 2012 13:52:41 +0200
Message-ID: <gid33eg4xi.fsf_-_@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Sun, 29 Jul 2012 13:52:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milton Miller <miltonm@bga.com> writes:

> [adding Rob as Doc maintanier]
>
> On Sat, 28 Jul 2012 about 11:08:16 -0000, Dirk Gouders wrote:
>> Borislav Petkov <bp@alien8.de> writes:
>> 
>> > On Fri, Jul 27, 2012 at 11:24:53AM +0200, Dirk Gouders wrote:
>> >> Cong Wang <xiyou.wangcong@gmail.com> writes:
>> >> 
>> >> > On Fri, Jul 27, 2012 at 2:35 PM, Dirk Gouders
>> >> > <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
>> >> >> Hi Jesse,
>> >> >>
>> >> >> I would like to ask you to check if the documentation of "nc" in
>> >> >> netconsole.txt is still correct.  I tried two different netcat packages
>> >> >> and both require "-p" to specify the listening port.  I am wondering if
>> >> >> that changed after the use of "nc" has been documented.
>> >> >
>> >> > On Fedora 16, `nc -u -l <port number>` works fine.
>> >> 
>> >> Thanks for checking that.
>> >> 
>> >> If the information I found is correct, Fedora uses OpenBSD's nc
>> >> codebase.  The two netcat packages I tested on a Gentoo system differ in
>> >> requiring the -p switch for the port specification.
>> >
>> > So say exactly that in the doc: that the *BSD's version of nc doesn't
>> > need the port number specified with '-p' and you're covered.
>> OK, I tried that in the attached patch.
>> I'm not sure if every exeption needs to/should be documented, though.
>> 
>> >From 3cdeac3e814471053129145c5fa8391acb365fd8 Mon Sep 17 00:00:00 2001
>> From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
>> Date: Sat, 28 Jul 2012 12:32:49 +0200
>> Subject: [PATCH] netconsole.txt: non-BSD versions of nc(1) require '-p'
>>  switch
>> 
>> Gentoo for example uses non-BSD versions of nc(1) which require
>> the '-p' switch to specify the listening port.
>> 
>> ---
>> Documentation/networking/netconsole.txt |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>> 
>> diff --git a/Documentation/networking/netconsole.txt b/Documentation/networking/netconsole.txt
>> index 8d02207..9a362f8 100644
>> --- a/Documentation/networking/netconsole.txt
>> +++ b/Documentation/networking/netconsole.txt
>> @@ -52,7 +52,8 @@ initialized and attempts to bring up the supplied dev at the supplied
>>  address.
>>  
>>  The remote host can run either 'netcat -u -l -p <port>',
>
> So the above line shows usage with -p
>
>> -'nc -l -u <port>' or syslogd.
>> +'nc -l -u <port>' (BSD version of nc(1) e.g. Fedora),
>
> now you add a comment about BSD and say Fedora which is not obviously
> BSD (this is Documentation; reading the git history for clarification
> is not approprate).

Thanks for your comments.
Perhaps I should have written "(BSD version of nc(1) which is used on
Fedora, for example)"

>> +'nc -l -u -p <port>' or syslogd.
>
> And now you add the original -p which you probably skipped over
> since it was on the previous line?

Well, this has been intentionally.

Probably this is because of the Gentoo system I use as a reference.
It offers three netcat packages, one is "gnu-netcat" which provides
/usr/bin/netcat, the other two are "netcat" and "netcat6", both of which
provide /usr/bin/nc (those packages cannot be installed at the same
time).  All of these netcat implementations require the '-p' switch.

I will check other distributions to see what netcat implementations they
provide; probably Gentoo is an exception in which case it might be
overdone to change the documentation for that special case...

Dirk

>
>>  
>>  Dynamic reconfiguration:
>>  ========================
>
> milton
