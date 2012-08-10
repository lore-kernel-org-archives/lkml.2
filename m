Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab2HJJPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 05:15:13 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3335 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2HJJPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 05:15:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 10 Aug 2012 02:09:48 -0700
Subject: Re: How to get the irq flags from the dts file
From: Wei Ni <wni@nvidia.com>
To: Arend van Spriel <arend@broadcom.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "frankyl@broadcom.com" <frankyl@broadcom.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <5023A88F.8040402@broadcom.com>
References: <1344509006.2295.148.camel@tegra-chromium-2>
	 <5023A88F.8040402@broadcom.com>
Date: Fri, 10 Aug 2012 17:14:58 +0800
Message-ID: <1344590098.21467.4.camel@tegra-chromium-2>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 20:09 +0800, Arend van Spriel wrote:
> On 08/09/2012 12:43 PM, Wei Ni wrote:
> > Hi, all
> > I'm working on tegra wlan upstream issue.
> > The tegra board use the Broadcom 4329 as wlan device, and the driver is
> > the brcmfmac. 
> > 
> > This wlan driver support out-band-interrupt (OOB), I want to add DT
> > support to use this OOB.
> > I can add following lines in the dts file to create platform device and
> > pass the interrupt resource to the driver.
> > 
> > wlan {
> >         compatible = "broadcome, brcmf_sdio_pd";
> 
> I don't know the DT syntax, but I assume broadcome should be broadcom,
> right? ;-)

Sorry, it's my typo, it should be broadcom.

> 
> >         interrupt-parten = <&gpio>;
> >         interrupts = <144, 0x04>; /* IRQF_TRIGGER_HIGH */
> > };
> > 
> > In the wlan driver, it will use platform_get_resource() to get the
> > res->irq, res->flags, the irq number is right, but the flags will be
> > IORESOURCE_IRQ, not the 0x04 (IRQF_TRIGGER_HIGH).
> > The wlan driver wish this flags include the IRQF_TRGGER_* information,
> > and it will use this flags to configure other hw settings. If it is
> > wrong, the wlan can't work.
> > 
> > I checked drivers/of/irq.c, in function of_irq_to_resource(), it will
> > set r->flags = IORESOURCE_IRQ directly, not read the flags from the dtb
> > file. And I didn't find any of_xx api to get this flags.
> > 
> > How can I get this flags, does anyone has suggestion?
> 
> I did a quick search in the kernel and there are a number of platform
> drivers that seem to expect the IRQF_TRIGGER_* info by using (res->flags
> & IRQF_TRIGGER_MASK) and to determine IRQF_SHARED as well.
> 
> Gr. AvS
> 


