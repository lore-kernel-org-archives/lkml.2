Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2G2I4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 04:56:38 -0400
Received: from mail4.comsite.net ([205.238.176.238]:40277 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2G2I4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 04:56:36 -0400
X-Greylist: delayed 988 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jul 2012 04:56:36 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [RFC] netconsole.txt: "nc" needs "-p" to specify the listening port
Content-Transfer-Encoding: 7bit
Subject: [RFC] netconsole.txt: "nc" needs "-p" to specify the listening port
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Message-Id: <kernel-nc-hints@mdm.bga.com>
In-Reply-To: <gilii4nnxb.fsf@mx10.gouders.net>
References: <gilii4nnxb.fsf@mx10.gouders.net>
Cc: Borislav Petkov <bp@alien8.de>, Cong Wang <xiyou.wangcong@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>
X-To-Not-Matched: true
Date: Sun, 29 Jul 2012 03:40:04 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Rob as Doc maintanier]

On Sat, 28 Jul 2012 about 11:08:16 -0000, Dirk Gouders wrote:
> Borislav Petkov <bp@alien8.de> writes:
> 
> > On Fri, Jul 27, 2012 at 11:24:53AM +0200, Dirk Gouders wrote:
> >> Cong Wang <xiyou.wangcong@gmail.com> writes:
> >> 
> >> > On Fri, Jul 27, 2012 at 2:35 PM, Dirk Gouders
> >> > <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
> >> >> Hi Jesse,
> >> >>
> >> >> I would like to ask you to check if the documentation of "nc" in
> >> >> netconsole.txt is still correct.  I tried two different netcat packages
> >> >> and both require "-p" to specify the listening port.  I am wondering if
> >> >> that changed after the use of "nc" has been documented.
> >> >
> >> > On Fedora 16, `nc -u -l <port number>` works fine.
> >> 
> >> Thanks for checking that.
> >> 
> >> If the information I found is correct, Fedora uses OpenBSD's nc
> >> codebase.  The two netcat packages I tested on a Gentoo system differ in
> >> requiring the -p switch for the port specification.
> >
> > So say exactly that in the doc: that the *BSD's version of nc doesn't
> > need the port number specified with '-p' and you're covered.
> OK, I tried that in the attached patch.
> I'm not sure if every exeption needs to/should be documented, though.
> 
> >From 3cdeac3e814471053129145c5fa8391acb365fd8 Mon Sep 17 00:00:00 2001
> From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
> Date: Sat, 28 Jul 2012 12:32:49 +0200
> Subject: [PATCH] netconsole.txt: non-BSD versions of nc(1) require '-p'
>  switch
> 
> Gentoo for example uses non-BSD versions of nc(1) which require
> the '-p' switch to specify the listening port.
> 
> ---
> Documentation/networking/netconsole.txt |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/networking/netconsole.txt b/Documentation/networking/netconsole.txt
> index 8d02207..9a362f8 100644
> --- a/Documentation/networking/netconsole.txt
> +++ b/Documentation/networking/netconsole.txt
> @@ -52,7 +52,8 @@ initialized and attempts to bring up the supplied dev at the supplied
>  address.
>  
>  The remote host can run either 'netcat -u -l -p <port>',

So the above line shows usage with -p

> -'nc -l -u <port>' or syslogd.
> +'nc -l -u <port>' (BSD version of nc(1) e.g. Fedora),

now you add a comment about BSD and say Fedora which is not obviously
BSD (this is Documentation; reading the git history for clarification
is not approprate).

> +'nc -l -u -p <port>' or syslogd.

And now you add the original -p which you probably skipped over
since it was on the previous line?


>  
>  Dynamic reconfiguration:
>  ========================

milton
