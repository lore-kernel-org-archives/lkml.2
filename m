Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab2HIMKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:10:04 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1827 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab2HIMKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:10:02 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <5023A88F.8040402@broadcom.com>
Date: Thu, 9 Aug 2012 14:09:51 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-Version: 1.0
To: "Wei Ni" <wni@nvidia.com>
cc: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        frankyl@broadcom.com, devicetree-discuss@lists.ozlabs.org,
        brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: How to get the irq flags from the dts file
References: <1344509006.2295.148.camel@tegra-chromium-2>
In-Reply-To: <1344509006.2295.148.camel@tegra-chromium-2>
X-Enigmail-Version: 1.5a1pre
X-WSS-ID: 7C3D77C13NK13567476-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 12:43 PM, Wei Ni wrote:
> Hi, all
> I'm working on tegra wlan upstream issue.
> The tegra board use the Broadcom 4329 as wlan device, and the driver is
> the brcmfmac. 
> 
> This wlan driver support out-band-interrupt (OOB), I want to add DT
> support to use this OOB.
> I can add following lines in the dts file to create platform device and
> pass the interrupt resource to the driver.
> 
> wlan {
>         compatible = "broadcome, brcmf_sdio_pd";

I don't know the DT syntax, but I assume broadcome should be broadcom,
right? ;-)

>         interrupt-parten = <&gpio>;
>         interrupts = <144, 0x04>; /* IRQF_TRIGGER_HIGH */
> };
> 
> In the wlan driver, it will use platform_get_resource() to get the
> res->irq, res->flags, the irq number is right, but the flags will be
> IORESOURCE_IRQ, not the 0x04 (IRQF_TRIGGER_HIGH).
> The wlan driver wish this flags include the IRQF_TRGGER_* information,
> and it will use this flags to configure other hw settings. If it is
> wrong, the wlan can't work.
> 
> I checked drivers/of/irq.c, in function of_irq_to_resource(), it will
> set r->flags = IORESOURCE_IRQ directly, not read the flags from the dtb
> file. And I didn't find any of_xx api to get this flags.
> 
> How can I get this flags, does anyone has suggestion?

I did a quick search in the kernel and there are a number of platform
drivers that seem to expect the IRQF_TRIGGER_* info by using (res->flags
& IRQF_TRIGGER_MASK) and to determine IRQF_SHARED as well.

Gr. AvS

