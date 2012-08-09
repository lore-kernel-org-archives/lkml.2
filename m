Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab2HILsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:48:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49563 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab2HILsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:48:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: How to get the irq flags from the dts file
Date: Thu, 9 Aug 2012 11:48:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Wei Ni <wni@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        frankyl@broadcom.com, brcm80211-dev-list@broadcom.com,
        devicetree-discuss@lists.ozlabs.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
References: <1344509006.2295.148.camel@tegra-chromium-2>
In-Reply-To: <1344509006.2295.148.camel@tegra-chromium-2>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208091148.42748.arnd@arndb.de>
X-Provags-ID: V02:K0:S/vP8ZTyp5pJMB4Ylwah2PdkEW87I4UJDpvkXHmKlBj
 tEVXwvgNpaqaD7k7EK8LQIG/bVfooaMggUbXuKBkZMv/hBX9zs
 nisvzx/lTuSRUXgvavJim5Atdw2VvFUkHrECPcjPDEnrGJeZa1
 LPDyPnuMstjnHEFunf2vXdD43T9+5D7rBv0y0Raw7Xe3553zrJ
 UvsNvHsjbgXG3Fa/G67dBBrdfbNjWAtB5hOMjttV9DSxtgVsrs
 9P5iSckjy39agj4h2gP8/LFoUMvP7WKm+Q4rcLrIXEVoM9ddHs
 0tjcEW51wNbB6HLrWlvCuAckQk9FuxeVrTJVYXBye6eLUqDwKY
 WrjcRe9JJ8nOcunwwkWc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2012, Wei Ni wrote:
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

The driver should not need to know about thie flag. It gets read
by irq_create_of_mapping when calling teh xlate function and
gets set using irq_set_irq_type from there too.

	Arnd
