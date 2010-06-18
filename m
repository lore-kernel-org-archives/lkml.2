Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761015Ab0FRLjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 07:39:15 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:1753 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758137Ab0FRLjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 07:39:13 -0400
Message-ID: <000401cb0eda$df624590$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Wang, Yong Y" <yong.y.wang@intel.com>
Cc: "Wang, Qi" <qi.wang@intel.com>, "Clark, Joel" <joel.clark@intel.com>,
       "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <4C0CE88C.9050708@dsn.okisemi.com> <4C161BE7.4080805@dsn.okisemi.com> <4C198BD2.8060801@dsn.okisemi.com> <FC2FB65B4D919844ADE4BE3C2BB739AD2077C837@shsmsx501.ccr.corp.intel.com>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Fri, 18 Jun 2010 20:39:09 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yong Y

>> +config PCH_IEEE1588
>> + tristate "PCH IEEE1588"
>> + depends on PCI
>> + help
>> +   If you say yes to this option, support will be included for the
>> +   PCH IEEE1588 Host controller.
>> +

>Is this really supposed to be part of this patch?

> +obj-$(CONFIG_PCH_IEEE1588) += pch_ieee1588/
> +

Yes, the above is true.
Our driver under 'drivers/char' has patch order restriction.
Firstly, ieee1588 must be patched.
After the above, Phub is able to be patched.

Thus, our Phub patch includes ieee1588 code.

> Ohtak-san, I remember you said PCH_CAN_PCLK_50MHZ was in the patch
> because you used to have a hw bug. If that hw bug has been fixed, this config
> option shall also be removed. Otherwise, you have to build multiple kernel
> binaries for different hardware configurations as Alan pointed out.
Sorry, I gave wrong information to you.
Our CAN HW spec is that works only 50MHz.(Not HW bug)
According to our CAN hw spec, we will delete  'PCH_CAN_PCLK_50MHZ'.

Thanks,
Ohtake

----- Original Message ----- 
From: "Wang, Yong Y" <yong.y.wang@intel.com>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>; "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>; "Clark, Joel"
<joel.clark@intel.com>; "Wang, Qi" <qi.wang@intel.com>
Sent: Friday, June 18, 2010 5:08 PM
Subject: RE: [PATCH] Topcliff PHUB: Generate PacketHub driver


> +config PCH_IEEE1588
> + tristate "PCH IEEE1588"
> + depends on PCI
> + help
> +   If you say yes to this option, support will be included for the
> +   PCH IEEE1588 Host controller.
> +

Is this really supposed to be part of this patch?

> +config PCH_PHUB
> + tristate "PCH PHUB"
> + depends on PCI
> + help
> +   If you say yes to this option, support will be included for the
> +   PCH Packet Hub Host controller.
> +   This driver is for PCH Packet hub driver for Topcliff.
> +   This driver is integrated as built-in.
> +   This driver can access GbE MAC address.
> +   This driver can access HW register.
> +   You can also be integrated as module.
> +
> +config PCH_CAN_PCLK_50MHZ
> + bool "CAN PCLK 50MHz"
> + depends on PCH_PHUB
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
> @@ -111,6 +111,10 @@ obj-$(CONFIG_PS3_FLASH) += ps3flash.o
>  obj-$(CONFIG_JS_RTC) += js-rtc.o
>  js-rtc-y = rtc.o
>
> +obj-$(CONFIG_PCH_IEEE1588) += pch_ieee1588/
> +

Ditto


