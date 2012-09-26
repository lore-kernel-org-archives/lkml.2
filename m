Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab2IZPKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 11:10:55 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:27701
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756565Ab2IZPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 11:10:53 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zz98dI179dNzz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MAYQ5Y-01-864-02
X-M-MSG: 
Date: Wed, 26 Sep 2012 17:10:44 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Florian Dazinger <florian@dazinger.net>, <linux-kernel@vger.kernel.org>,
        iommu <iommu@lists.linux-foundation.org>
Subject: Re: 3.6-rc7 boot crash + bisection
Message-ID: <20120926151044.GE10549@amd.com>
References: <20120924210348.5f50677b@brain.lan>
 <1348597970.28860.114.camel@bling.home>
 <20120925205420.0a07dea2@brain.lan>
 <1348602226.28860.132.camel@bling.home>
 <20120926132050.GB10549@amd.com>
 <1348670159.28860.183.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1348670159.28860.183.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 08:35:59AM -0600, Alex Williamson wrote:
> Hmm, that throws a kink in iommu groups.  So perhaps we need to make an
> alias interface to iommu groups.  Seems like this could just be an extra
> parameter to iommu_group_get and iommu_group_add_device (empty in the
> typical case).  Then we have the problem of what's the type for an
> alias?  For AMI-Vi, it's a u16, but we need to be more generic than
> that.  Maybe iommu groups should just treat it as a void* so iommus can
> use a pointer to some structure or a fixed value like a u16 bus:slot.
> Thoughts?

Good question. The iommu-groups are part of the IOMMU-API, with an
interface to the IOMMU drivers and one to the users of IOMMU-API. So the
alias handling itself should be a function of the interface to the IOMMU
driver. In general the interface should not be bus specific.

So a void pointer seems the only logical choice then. But I would not
limit its scope to alias handling. How about making it a bus-private
pointer where IOMMU driver store bus-specific information. That way we
make sure that there is one struct per bus-type for this pointer, and
not one structure per IOMMU driver.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

