Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab0ERGrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:47:08 -0400
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:48651 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754579Ab0ERGrF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:47:05 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 May 2010 02:47:05 EDT
X-Spam-Flag: NO
X-Spam-Score: -1.36
Message-ID: <20100518093815.78433bua1qziahmo@hayate.sektori.org>
Date: Tue, 18 May 2010 09:38:15 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "=?utf-8?b?Um9nw6lyaW8=?= Brito" <rbrito@ime.usp.br>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Select WIRELESS_EXT for the rndis_wlan driver to
	compile
References: <20100518031436.GA6006@ime.usp.br>
In-Reply-To: <20100518031436.GA6006@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for reporting. Correct way to fix this is to replace  
wireless_send_event() with cfg80211_disconnect(). I'll post patch soon.

-Jussi

Quoting "Rogério Brito" <rbrito@ime.usp.br>:

> The rndis_wlan.ko module needs the function wireless_send_event, which
> is not included if the option WIRELESS_EXT is not selected by the
> driver.  Otherwise, the user gets compilation problems like:
>
> ,----
> | (...)
> | Kernel: arch/x86/boot/bzImage is ready  (#3)
> |   Building modules, stage 2.
> |   MODPOST 427 modules
> | ERROR: "wireless_send_event" [drivers/net/wireless/rndis_wlan.ko]  
> undefined!
> | make[1]: *** [__modpost] Error 1
> | make: *** [modules] Error 2
> `----
> ---
>
> I don't know if this is a proper fix, but I would love to know a better
> solution to the problem.
>
>  drivers/net/wireless/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index 5889436..0d5fff4 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -186,6 +186,7 @@ config USB_NET_RNDIS_WLAN
>  	tristate "Wireless RNDIS USB support"
>  	depends on USB && EXPERIMENTAL
>  	depends on CFG80211
> +	select WIRELESS_EXT
>  	select USB_USBNET
>  	select USB_NET_CDCETHER
>  	select USB_NET_RNDIS_HOST
> --
> 1.7.1
>
>
>


