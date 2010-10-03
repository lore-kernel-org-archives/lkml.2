Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0JCNGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 09:06:20 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:7791 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab0JCNGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 09:06:19 -0400
Message-ID: <4CA87FC6.40208@bfs.de>
Date: Sun, 03 Oct 2010 15:06:14 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: greg@kroah.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH v3 14/20] Staging: rtl8192u: ieee80211: Makefile: cleaned
 up Makefile cflag lines
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com> <1286037489-28439-14-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1286037489-28439-14-git-send-email-tdent48227@gmail.com>
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
>  drivers/staging/rtl8192u/ieee80211/Makefile |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/ieee80211/Makefile b/drivers/staging/rtl8192u/ieee80211/Makefile
> index 71ca5d9..45704f8 100644
> --- a/drivers/staging/rtl8192u/ieee80211/Makefile
> +++ b/drivers/staging/rtl8192u/ieee80211/Makefile
> @@ -5,22 +5,22 @@ MODDESTDIR := /lib/modules/$(KVER)/kernel/drivers/net/wireless/$(NIC_SELECT)
>  
>  CC = gcc

does this mean we can compile with gcc only ? where are the icc users ?

>  ifneq ($(shell uname -r|cut -d. -f1,2), 2.4)

I can guess what the author intended but this will only check *on*
what system i am compiling, not what linux version i try *to conpile*.
see: KERNEL_VERSION macro



> -EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/wireless
> -EXTRA_CFLAGS += -O2

no optimisation, please

> -EXTRA_CFLAGS += -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
> +ccflags-y := -I$(TOPDIR)/drivers/net/wireless
> +ccflags-y += -O2
> +ccflags-y += -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
>  
>  #it will fail to compile in suse linux enterprise 10 sp2. This flag is to solve this problem.
>  ifeq ($(shell uname -r | cut -d. -f1,2,3,4), 2.6.16.60-0)
> -EXTRA_CFLAGS += -DOPENSUSE_SLED
> +ccflags-y := -DOPENSUSE_SLED
>  endif

this should be something like .....

# if LINUX_VERSION_CODE = KERNEL_VERSION(2,6,16)
#define OPENSUSE_SLED
#endif

>  ifeq ($(NIC_SELECT),RTL8192U)
> -#EXTRA_CFLAGS += -DUSB_TX_DRIVER_AGGREGATION_ENABLE
> -#EXTRA_CFLAGS += -DUSB_RX_AGGREGATION_SUPPORT
> +#ccflags-y := -DUSB_TX_DRIVER_AGGREGATION_ENABLE
> +#ccflags-y := -DUSB_RX_AGGREGATION_SUPPORT
>  endif
> -#EXTRA_CFLAGS += -DJOHN_NOCPY
> +#ccflags-y := -DJOHN_NOCPY
>  #flags to enable or disble 80211D feature
> -EXTRA_CFLAGS += -DENABLE_DOT11D
> +ccflags-y += -DENABLE_DOT11D
>  ieee80211-rsl-objs := ieee80211_rx.o \
>  		      ieee80211_softmac.o \
>  		      ieee80211_tx.o \


just my 2 cents,
 wh
