Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab2HBUlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 16:41:09 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:47379 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750949Ab2HBUlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 16:41:06 -0400
Date: Thu, 2 Aug 2012 13:41:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: Rob Landley <rob@landley.net>, Milton Miller <miltonm@bga.com>,
        Borislav Petkov <bp@alien8.de>, Cong Wang <xiyou.wangcong@gmail.com>,
        Jan Engelhardt <jengelh@inai.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] netconsole.txt: "nc" needs "-p" to specify the listening
 port
Message-ID: <20120802134155.791cfcce@jbarnes-desktop>
In-Reply-To: <gisjc5hvun.fsf@mx10.gouders.net>
References: <gilii4nnxb.fsf@mx10.gouders.net>
	<kernel-nc-hints@mdm.bga.com>
	<501937F7.2070600@landley.net>
	<gi3946lin5.fsf@mx10.gouders.net>
	<gisjc5hvun.fsf@mx10.gouders.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Aug 2012 22:39:28 +0200
Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:

> Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> writes:
> 
> > Rob Landley <rob@landley.net> writes:
> >
> >> On 07/29/2012 03:40 AM, Milton Miller wrote:
> >>> [adding Rob as Doc maintanier]
> >>> 
> >>> On Sat, 28 Jul 2012 about 11:08:16 -0000, Dirk Gouders wrote:
> >>>> Borislav Petkov <bp@alien8.de> writes:
> >>>>
> >>>>> On Fri, Jul 27, 2012 at 11:24:53AM +0200, Dirk Gouders wrote:
> >>>>>> Cong Wang <xiyou.wangcong@gmail.com> writes:
> >>>>>>
> >>>>>>> On Fri, Jul 27, 2012 at 2:35 PM, Dirk Gouders
> >>>>>>> <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
> >>>>>>>> Hi Jesse,
> >>>>>>>>
> >>>>>>>> I would like to ask you to check if the documentation of "nc" in
> >>>>>>>> netconsole.txt is still correct.  I tried two different netcat packages
> >>>>>>>> and both require "-p" to specify the listening port.  I am wondering if
> >>>>>>>> that changed after the use of "nc" has been documented.
> >>>>>>>
> >>>>>>> On Fedora 16, `nc -u -l <port number>` works fine.
> >>>>>>
> >>>>>> Thanks for checking that.
> >>>>>>
> >>>>>> If the information I found is correct, Fedora uses OpenBSD's nc
> >>>>>> codebase.  The two netcat packages I tested on a Gentoo system differ in
> >>>>>> requiring the -p switch for the port specification.
> >>>>>
> >>>>> So say exactly that in the doc: that the *BSD's version of nc doesn't
> >>>>> need the port number specified with '-p' and you're covered.
> >>>> OK, I tried that in the attached patch.
> >>>> I'm not sure if every exeption needs to/should be documented, though.
> >>>>
> >>>> >From 3cdeac3e814471053129145c5fa8391acb365fd8 Mon Sep 17 00:00:00 2001
> >>>> From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
> >>>> Date: Sat, 28 Jul 2012 12:32:49 +0200
> >>>> Subject: [PATCH] netconsole.txt: non-BSD versions of nc(1) require '-p'
> >>>>  switch
> >>>>
> >>>> Gentoo for example uses non-BSD versions of nc(1) which require
> >>>> the '-p' switch to specify the listening port.
> >>>>
> >>>> ---
> >>>> Documentation/networking/netconsole.txt |    3 ++-
> >>>>  1 files changed, 2 insertions(+), 1 deletions(-)
> >>
> >> Did this ever resolve to a specific recommended patch? The one at the
> >> start of the thread:
> >>
> >>  http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/01995.html
> >>
> >> Apparently isn't it...?
> >
> > Sorry for the delay.
> > I tested the situation on a few distributions and am still thinking
> > about a proper way to write it in a way without netconsole.txt becoming
> > a kind of "netcat.txt".
> >
> > I would be glad about comments to what I currently have -- also, because
> > I am not a native English speaker:
> >
> > ------------------------------------------------------------------------
> > The remote host can run syslogd or netcat to receive the kernel
> > messages.  On distributions using a BSD-based netcat version
> > (e.g. Fedora, openSUSE and Ubuntu) the listening port must be
> > specified without the -p switch:
> >
> > 'nc -u -l -p <port>' / 'nc -u -l <port>' or
> > 'netcat -u -l -p <port>' / 'netcat -u -l <port>'
> > ------------------------------------------------------------------------
> >
> > At the end, I also attach what I have noted during the tests with the
> > different distributions.
> >
> > Dirk
> >
> > ------------------------------------------------------------------------
> > Problem on systems where the gnu-netcat package provides a symbolic
> > link /usr/bin/nc -> /usr/bin/netcat:
> >
> > gnu-netcat requires -p to specify the local port but does not complain
> > if invoked as `nc -l -u <port>'; you need to use -v to see that it
> > does not do what you might expect:
> >
> > # nc -l -u 4444 -v
> > Warning: Inverse name lookup failed for `0.0.17.92'
> > ------------------------------------------------------------------------
> >
> > Distro		Package						needs -p
> > 		Command invocation
> > ========================================================================
> > Arch		gnu-netcat					yes
> > (Website	nc | netcat
> >  documentation)
> > 		openbsd-netcat					no
> > 		nc.openbsd
> > ------------------------------------------------------------------------
> > Debian-6.0.5	netcat-openbsd					no 
> > 		nc | netcat | nc.openbsd		   
> > 		                                   
> > 		netcat / netcat-traditional (preinstalled)	yes
> > 		nc | netcat
> > 		                                   
> > 		netcat6						yes
> > 		nc | netcat | nc6
> > ------------------------------------------------------------------------
> > Fedora-17	nc (preinstalled)				no
> > 		nc
> >
> > 		nc6
> > 		nc6						yes
> > ------------------------------------------------------------------------
> > Gentoo		gnu-netcat					yes
> > 		netcat
> >
> > 		netcat						yes
> > 		nc
> >
> > 		netcat6						yes
> > 		nc | nc6
> > ------------------------------------------------------------------------
> > OpenSUSE-12.1	netcat-openbsd					no
> > 		nc | netcat
> > ------------------------------------------------------------------------
> > Ubuntu-12.04	netcat-openbsd (preinstalled)			no 
> > Desktop		nc | netcat | nc.openbsd
> > 		                                   
> > 		netcat / netcat-traditional			yes
> > 		nc | netcat		   
> > 		                                   
> > 		netcat6						yes
> > 		nc | netcat | nc6
> > ------------------------------------------------------------------------
> 
> Here is a patch that also includes Jan's suggestion for socat(1).
> 
> The problem with the patch is that the netcat part does not cover every
> possible distribution/netcat-package situation but in my opinion it is a
> bearable compromise with respect to keeping the example section compact.
> 
> Dirk
> 
> From d756d2750e4cf07d3c0942dc3c491d57631d4338 Mon Sep 17 00:00:00 2001
> From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
> Date: Thu, 2 Aug 2012 22:20:16 +0200
> Subject: [PATCH] netconsole.txt: revision of examples for the receiver of kernel messages
> 
> There are at least 4 implementations of netcat with the BSD-based
> being the only one that has to be used without the -p switch to
> specify the listening port.
> 
> Jan Engelhardt suggested to add an example for socat(1).
> ---
>  Documentation/networking/netconsole.txt |   19 +++++++++++++++++--
>  1 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/netconsole.txt b/Documentation/networking/netconsole.txt
> index 8d02207..2e9e0ae2 100644
> --- a/Documentation/networking/netconsole.txt
> +++ b/Documentation/networking/netconsole.txt
> @@ -51,8 +51,23 @@ Built-in netconsole starts immediately after the TCP stack is
>  initialized and attempts to bring up the supplied dev at the supplied
>  address.
>  
> -The remote host can run either 'netcat -u -l -p <port>',
> -'nc -l -u <port>' or syslogd.
> +The remote host has several options to receive the kernel messages,
> +for example:
> +
> +1) syslogd
> +
> +2) netcat
> +
> +   On distributions using a BSD-based netcat version (e.g. Fedora,
> +   openSUSE and Ubuntu) the listening port must be specified without
> +   the -p switch:
> +
> +   'nc -u -l -p <port>' / 'nc -u -l <port>' or
> +   'netcat -u -l -p <port>' / 'netcat -u -l <port>'
> +
> +3) socat
> +
> +   'socat udp-recv:<port> -'
>  
>  Dynamic reconfiguration:
>  ========================

Looks good to me, thanks Dirk.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
