Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0HQM6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:58:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62552 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab0HQM6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:58:47 -0400
X-Authority-Analysis: v=1.1 cv=FLDyhxrUEZZDQYGWQdnXfbzWjjll+fIPMqQTcKt1R7E= c=1 sm=0 a=krCllBuaAswA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=omOdbC7AAAAA:8 a=h1aNt0RaAAAA:8 a=NpHJAHtTnWJm0ULpiBoA:9 a=3Cwk9GOgnOEo5makNEoA:7 a=KtkFGl_MFISvytzkW7pNA710pkAA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=_RhRFcbxBZMA:10 a=9n0VZpmWo7gA:10 a=y1reIqIzr3CA1Ys9:21 a=h2lltaSz5UkHybMd:21 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [PATCH] kconfig: Fix variable name typo in
 streamline_config.pl.
From: Steven Rostedt <rostedt@goodmis.org>
To: hiromu <hiromu1996@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Toralf Foerster <toralf.foerster@gmx.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
In-Reply-To: <1282042158.7160.9.camel@hiromu-Macbook>
References: <1281845597.11566.5.camel@camp10-laptop>
	 <20100817054318.GC5095@cr0.nay.redhat.com>
	 <1282042158.7160.9.camel@hiromu-Macbook>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 Aug 2010 08:58:45 -0400
Message-ID: <1282049925.3268.1294.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 19:49 +0900, hiromu wrote:
> On Fri, Aug 17, 2010 at 01:43PM +0800, Américo Wang wrote:
> > Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> > 
> > BTW, I think we should add "use strict;" too.
> 
> Then I added "use strict;" to streamline_config.pl, I saw another
> warings.
> 
> > Global symbol "$dir" requires explicit package name at
> scripts/kconfig/streamline_config.pl line 286.
> > Global symbol "$dir" requires explicit package name at
> scripts/kconfig/streamline_config.pl line 287.
> > Global symbol "$dir" requires explicit package name at
> scripts/kconfig/streamline_config.pl line 288.
> 
> Then I added "my $dir;" to line 285.

Thanks! I'll pull this in today.

-- Steve

> 
> Cc: Américo Wang <xiyou.wangcong@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Toralf Foerster <toralf.foerster@gmx.de>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
> 
> Signed-off-by: Hiromu Yakura <hiromu1996@gmail.com>
> ---
>  scripts/kconfig/streamline_config.pl |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/kconfig/streamline_config.pl
> b/scripts/kconfig/streamline_config.pl
> index d74363f..9ca361a 100644
> --- a/scripts/kconfig/streamline_config.pl
> +++ b/scripts/kconfig/streamline_config.pl
> @@ -42,6 +42,8 @@
>  #    mv config_strip .config
>  #    make oldconfig
>  #
> +use strict;
> +
>  my $config = ".config";
>  
>  my $uname = `uname -r`;
> @@ -280,6 +282,7 @@ if (defined($lsmod_file)) {
>  
>      # see what modules are loaded on this system
>      my $lsmod;
> +    my $dir;
>  
>      foreach $dir ( ("/sbin", "/bin", "/usr/sbin", "/usr/bin") ) {
>         if ( -x "$dir/lsmod" ) {


