Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0JCMrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 08:47:42 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:50351 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab0JCMrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 08:47:41 -0400
Message-ID: <4CA87B69.3060105@bfs.de>
Date: Sun, 03 Oct 2010 14:47:37 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: greg@kroah.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH v3 09/20] Staging: rtl8187se: Makefile: cleaned up Makefile
 cflag lines
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com> <1286037489-28439-9-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1286037489-28439-9-git-send-email-tdent48227@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Tracey Dent schrieb:
> Changed to use the proper ccflags-y option
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/rtl8187se/Makefile |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/Makefile b/drivers/staging/rtl8187se/Makefile
> index e6adf91..adc3849 100644
> --- a/drivers/staging/rtl8187se/Makefile
> +++ b/drivers/staging/rtl8187se/Makefile
> @@ -4,17 +4,17 @@
>  #EXTRA_CFLAGS += -O2
>  #CC            = gcc
>  
> -EXTRA_CFLAGS += -DSW_ANTE
> -EXTRA_CFLAGS += -DTX_TRACK
> -EXTRA_CFLAGS += -DHIGH_POWER
> -EXTRA_CFLAGS += -DSW_DIG
> -EXTRA_CFLAGS += -DRATE_ADAPT
> +ccflags-y := -DSW_ANTE
> +ccflags-y += -DTX_TRACK
> +ccflags-y += -DHIGH_POWER
> +ccflags-y += -DSW_DIG
> +ccflags-y += -DRATE_ADAPT
>  
>  #enable it for legacy power save, disable it for leisure  power save
> -EXTRA_CFLAGS += -DENABLE_LPS
> +ccflags-y += -DENABLE_LPS
>  
>  
> -#EXTRA_CFLAGS += -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
> +#ccflags-y := -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
>  

so every time someone selects "my cpu does not have hard-float
they will try it again, and to make sure that it will cause max
confusion it sets CONFIG_FORCE_HARD_FLOAT to yes.

re,
 wh





>  r8187se-objs :=			\
>  		r8180_core.o		\
