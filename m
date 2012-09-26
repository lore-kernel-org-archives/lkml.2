Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2IZNVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:21:08 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:7641 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756391Ab2IZNVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:21:03 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dId6f1izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MAYL2U-02-D9U-02
X-M-MSG: 
Date: Wed, 26 Sep 2012 15:20:50 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Florian Dazinger <florian@dazinger.net>, <linux-kernel@vger.kernel.org>,
        iommu <iommu@lists.linux-foundation.org>
Subject: Re: 3.6-rc7 boot crash + bisection
Message-ID: <20120926132050.GB10549@amd.com>
References: <20120924210348.5f50677b@brain.lan>
 <1348597970.28860.114.camel@bling.home>
 <20120925205420.0a07dea2@brain.lan>
 <1348602226.28860.132.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1348602226.28860.132.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 01:43:46PM -0600, Alex Williamson wrote:
> Joerg, any thoughts on a quirk for this?  Unfortunately we can't just
> skip IOMMU groups when an alias is broken because it puts the other
> IOMMU groups at risk that might not actually be isolated from this
> device.  It looks like we parse the alias info before PCI is probed, so
> maybe we'd need to call the quirk from iommu_init_device itself.

I fear that the BIOS does everything right and device 08:04.0 is indeed
using 08:00.0 as request-id. There are a couple of devices where this
happens, usually when the vendor just took the old 32bit PCI chip, added
a transparent PCIe-to-PCI bridge to the device and sell it a PCIe.

So the assumption that every request-id has a corresponding pci_dev
structure does not hold. I also had made that assumption in the
AMD IOMMU driver but had to add code which removes that assumption. We
should look for a way to remove that assumption from the group-code too.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

