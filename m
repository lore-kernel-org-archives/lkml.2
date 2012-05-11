Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab2EKL73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:59:29 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4498 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab2EKL71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:59:27 -0400
X-Server-Uuid: 72204117-5C29-4314-8910-60DB108979CB
Message-ID: <4FACFF12.60504@broadcom.com>
Date: Fri, 11 May 2012 13:59:14 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Randy Dunlap" <rdunlap@xenotime.net>
cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Luciano Coelho" <coelho@ti.com>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "Arik Nemtsov" <arik@wizery.com>
Subject: Re: [PATCH -next] wireless: TI wlxxx depends on MAC80211
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
 <4F8C784B.2040402@xenotime.net>
In-Reply-To: <4F8C784B.2040402@xenotime.net>
X-Enigmail-Version: 1.5pre
X-WSS-ID: 63B220B844G2976677-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 09:51 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> wl12xx build fails with many undefined symbol errors when MAC80211
> and CFG80211 are not enabled, so make WLCORE and WL12XX depend
> on MAC80211 (which already depends on CFG80211).
> 
> ---
>  drivers/net/wireless/ti/wl12xx/Kconfig |    1 +
>  drivers/net/wireless/ti/wlcore/Kconfig |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-next-20120416.orig/drivers/net/wireless/ti/wl12xx/Kconfig
> +++ linux-next-20120416/drivers/net/wireless/ti/wl12xx/Kconfig
> @@ -1,5 +1,6 @@
>  config WL12XX
>         tristate "TI wl12xx support"
> +	depends on MAC80211
>         select WLCORE

Similar patch is probably needed for new wl18xx driver.

>         ---help---
>  	  This module adds support for wireless adapters based on TI wl1271,
> --- linux-next-20120416.orig/drivers/net/wireless/ti/wlcore/Kconfig
> +++ linux-next-20120416/drivers/net/wireless/ti/wlcore/Kconfig
> @@ -1,6 +1,6 @@
>  config WLCORE
>  	tristate "TI wlcore support"
> -	depends on WL_TI && GENERIC_HARDIRQS
> +	depends on WL_TI && GENERIC_HARDIRQS && MAC80211
>  	depends on INET
>  	select FW_LOADER
>  	---help---

Gr. AvS

