Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab0IYKwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 06:52:50 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:24904 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab0IYKws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 06:52:48 -0400
Message-ID: <4C9DD47C.7040403@bfs.de>
Date: Sat, 25 Sep 2010 12:52:44 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: greg@kroah.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 15/22] Staging: rtl8192u: Makefile: cleaned up makefile
 cflag lines
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com> <1285370890-8984-15-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1285370890-8984-15-git-send-email-tdent48227@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Tracey Dent schrieb:
> Changed to use proper ccflags-y option
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/rtl8192u/Makefile |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/Makefile b/drivers/staging/rtl8192u/Makefile
> index 738f4a8..1710921 100644
> --- a/drivers/staging/rtl8192u/Makefile
> +++ b/drivers/staging/rtl8192u/Makefile
> @@ -1,16 +1,16 @@
>  NIC_SELECT = RTL8192U
>  
> -EXTRA_CFLAGS += -std=gnu89
> -EXTRA_CFLAGS += -O2
> +ccflags-y := -std=gnu89
> +ccflags-y := -O2
>  

Is this -O2 a requirement ? I did not look into other makefiles but i would expect
-O2 to be set in the main-makefile. (Imagine someone disables the optimsation only
to find a driver that does behave different).



> -EXTRA_CFLAGS += -DCONFIG_FORCE_HARD_FLOAT=y
> -EXTRA_CFLAGS += -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
> -EXTRA_CFLAGS += -DTHOMAS_BEACON -DTHOMAS_TASKLET -DTHOMAS_SKB -DTHOMAS_TURBO

Is THOMAS_BEACON etc a defined algorithem or so ? If not a bit more desciptive name
would be nice

just my 2 cents,
 re
 wh

> -#EXTRA_CFLAGS += -DUSB_TX_DRIVER_AGGREGATION_ENABLE
> -#EXTRA_CFLAGS += -DUSB_RX_AGGREGATION_SUPPORT
> -EXTRA_CFLAGS += -DUSE_ONE_PIPE
> -EXTRA_CFLAGS += -DENABLE_DOT11D
> -EXTRA_CFLAGS += -Idrivers/staging/rtl8192u/ieee80211
> +ccflags-y := -DCONFIG_FORCE_HARD_FLOAT=y
> +ccflags-y := -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
> +ccflags-y += -DTHOMAS_BEACON -DTHOMAS_TASKLET -DTHOMAS_SKB -DTHOMAS_TURBO
> +#ccflags-y := -DUSB_TX_DRIVER_AGGREGATION_ENABLE
> +#ccflags-y := -DUSB_RX_AGGREGATION_SUPPORT
> +ccflags-y += -DUSE_ONE_PIPE
> +ccflags-y += -DENABLE_DOT11D
> +ccflags-y += -Idrivers/staging/rtl8192u/ieee80211
>  
>  r8192u_usb-objs := r8192U_core.o r8180_93cx6.o r8192U_wx.o		\
>  		  r8190_rtl8256.o r819xU_phy.o r819xU_firmware.o	\
