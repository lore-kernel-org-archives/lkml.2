Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab2HJJMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 05:12:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3108 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012Ab2HJJMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 05:12:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 10 Aug 2012 02:12:00 -0700
Subject: Re: How to get the irq flags from the dts file
From: Wei Ni <wni@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "frankyl@broadcom.com" <frankyl@broadcom.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
In-Reply-To: <20120809120530.GC8474@sirena.org.uk>
References: <1344509006.2295.148.camel@tegra-chromium-2>
	 <201208091148.42748.arnd@arndb.de>  <20120809120530.GC8474@sirena.org.uk>
Date: Fri, 10 Aug 2012 17:11:56 +0800
Message-ID: <1344589916.21467.1.camel@tegra-chromium-2>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 20:05 +0800, Mark Brown wrote:
> On Thu, Aug 09, 2012 at 11:48:42AM +0000, Arnd Bergmann wrote:
> > On Thursday 09 August 2012, Wei Ni wrote:
> 
> > > The wlan driver wish this flags include the IRQF_TRGGER_* information,
> > > and it will use this flags to configure other hw settings. If it is
> > > wrong, the wlan can't work.
> 
> You can read the configuration with irqd_get_trigger_type() - see the OF
> code in sound/soc/codecs/wm8903.c for an example.

I tried it, it worked fine. thanks for your help.

> 
> > The driver should not need to know about thie flag. It gets read
> > by irq_create_of_mapping when calling teh xlate function and
> > gets set using irq_set_irq_type from there too.
> 
> That only helps the interrupt controller, it doesn't help the interrupt
> source.  A good proportion of embedded devices have a great deal of
> flexibility in how they signal interrupts so they need to know what mode
> to pick.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


