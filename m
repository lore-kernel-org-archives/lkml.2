Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2A3G1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 01:27:36 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:23607
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752584Ab2A3G1f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 01:27:35 -0500
X-SpamScore: -13
X-BigFish: VS-13(zzbb2dI9371I542M1432N98dKzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joerg.roedel@amd.com>,
        Wood Scott-B07421 <B07421@freescale.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Thread-Topic: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Thread-Index: AQHM1rbj1rZDtR84OEuq1/Qi58+pfJYT5niggAHq2gCACZWbAIAAAZsAgAADCwCAAAJ5gIAFCoQg
Date: Mon, 30 Jan 2012 06:27:30 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D041E81@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
 <1326983405-319-3-git-send-email-joerg.roedel@amd.com>
 <C5ECD7A89D1DC44195F34B25E172658D038749@039-SN2MPN1-011.039d.mgd.msft.net>
 <20120120160344.GG2205@amd.com> <4F219A9C.8000400@freescale.com>
 <20120126183116.GI19255@amd.com> <4F219E82.106@freescale.com>
 <20120126185101.GJ19255@amd.com>
In-Reply-To: <20120126185101.GJ19255@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.134.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joerg Roedel [mailto:joerg.roedel@amd.com]
> Sent: Friday, January 27, 2012 12:21 AM
> To: Wood Scott-B07421
> Cc: Sethi Varun-B16395; iommu@lists.linux-foundation.org; Ohad Ben-Cohen;
> Tony Lindgren; Hiroshi DOYU; linux-kernel@vger.kernel.org; Laurent
> Pinchart; Wood Scott-B07421; David Brown; David Woodhouse
> Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY
> attribute
> 
> On Thu, Jan 26, 2012 at 12:42:10PM -0600, Scott Wood wrote:
> > On 01/26/2012 12:31 PM, Joerg Roedel wrote:
> > > The force_aperture flag indicated whether DMA is only allowed
> > > between aperture_start and apertuer_end or if DMA is allowed outside
> > > of this range too (unmapped in this case).
> > >
> > > The AMD GART for example would set this flag to false because it
> > > does not enforce DMA to be in the aperture-range.
> >
> > Why is this not an AMD GART specific attribute?  Is there any feature
> > reporting mechanism by which a user would know if that flag is
> supported?
> 
> Because this is a flag that makes sense for all IOMMU. Every IOMMU either
> allows DMA outside its aperture or it doesn't.
> 
> Another reason why it must be in the generic struct is the intended
> generic dma-ops layer on-top. This code can decide on this flag wheter a
> address needs to be remapped at all.


Can you please explain how would IOMMU remapping be used, based on the force_aperture flag.

-Varun 


