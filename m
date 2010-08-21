Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab0HUHY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 03:24:59 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:55885 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0HUHY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 03:24:56 -0400
Date: Sat, 21 Aug 2010 09:24:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tiago Maluta <tiago.maluta@gmail.com>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] fix compilation error with CROSS_COMPILE
Message-ID: <20100821072454.GA25054@merkur.ravnborg.org>
References: <20100821062133.GA809@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821062133.GA809@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 02:21:33PM +0800, Wu Fengguang wrote:
>         $ make CROSS_COMPILE=x86_64-linux-gnu-
>         ...
>         cc1: error: unrecognized command line option "-m64"
>         cc1: error: unrecognized command line option "-mno-red-zone"
>         cc1: error: unrecognized command line option "-mcmodel=kernel"
>         cc1: error: unrecognized command line option "-maccumulate-outgoing-args"
> 
> Cc: Tiago Maluta <tiago.maluta@gmail.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
> 
> Andrew: the compile error only occurs in the -mm tree
> The bug is introduced by patch "Linux has an recent option to define
> CROSS_COMPILE in menuconfig.".
> 
> diff --git a/Makefile b/Makefile
> index d646d69..af8864e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>  export KBUILD_BUILDHOST := $(SUBARCH)
>  ARCH		?= $(SUBARCH)
>  CROSS_COMPILE	?=
> -CROSS_COMPILE	:= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
> +CROSS_COMPILE	?= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)

I cannot see how this would solve your problem.
Any variable assigned using := or ?= can be overrided by  variable
assigned on the command line like this:

   make VAR=values

Please note that there is a big difference between the above and this:

    VAR=value make

In the latter case you pass in VAR using the enviroment and it
is just like any other environment variable as seen from make.

On top of that the upstream kernel does not have the first
assignmnet to CROSS_COMPILE - so you need to update
your sources (or Andrews --mm is not recent enough.

Please try again with upstream kernel and let us know what you
conclude.

	Sam
