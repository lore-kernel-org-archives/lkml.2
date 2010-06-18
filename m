Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab0FRIIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 04:08:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:53267 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672Ab0FRIIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 04:08:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,437,1272870000"; 
   d="scan'208";a="631494095"
From: "Wang, Yong Y" <yong.y.wang@intel.com>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
       "Clark, Joel" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>
Date: Fri, 18 Jun 2010 16:08:32 +0800
Subject: RE: [PATCH] Topcliff PHUB: Generate PacketHub driver
Thread-Topic: [PATCH] Topcliff PHUB: Generate PacketHub driver
Thread-Index: AcsNxugTzTSoCiwYS6GJQagGMuBhJwA9bcgw
Message-ID: <FC2FB65B4D919844ADE4BE3C2BB739AD2077C837@shsmsx501.ccr.corp.intel.com>
References: <4C0CE88C.9050708@dsn.okisemi.com>
 <4C161BE7.4080805@dsn.okisemi.com> <4C198BD2.8060801@dsn.okisemi.com>
In-Reply-To: <4C198BD2.8060801@dsn.okisemi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config PCH_IEEE1588
> +	tristate "PCH IEEE1588"
> +	depends on PCI
> +	help
> +	  If you say yes to this option, support will be included for the
> +	  PCH IEEE1588 Host controller.
> +

Is this really supposed to be part of this patch?

> +config PCH_PHUB
> +	tristate "PCH PHUB"
> +	depends on PCI
> +	help
> +	  If you say yes to this option, support will be included for the
> +	  PCH Packet Hub Host controller.
> +	  This driver is for PCH Packet hub driver for Topcliff.
> +	  This driver is integrated as built-in.
> +	  This driver can access GbE MAC address.
> +	  This driver can access HW register.
> +	  You can also be integrated as module.
> +
> +config PCH_CAN_PCLK_50MHZ
> +	bool "CAN PCLK 50MHz"
> +	depends on PCH_PHUB
> +        help
> +          If you say yes to this option, clock is set to 50MHz.(For CAN
> control)
> +

Ohtak-san, I remember you said PCH_CAN_PCLK_50MHZ was in the patch
because you used to have a hw bug. If that hw bug has been fixed, this config
option shall also be removed. Otherwise, you have to build multiple kernel
binaries for different hardware configurations as Alan pointed out.

> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index f957edf..dc092d0 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -111,6 +111,10 @@ obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
>  obj-$(CONFIG_JS_RTC)		+= js-rtc.o
>  js-rtc-y = rtc.o
> 
> +obj-$(CONFIG_PCH_IEEE1588)		+= pch_ieee1588/
> +

Ditto

