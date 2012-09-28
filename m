Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab2I1Pgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:36:42 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:30191
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758473Ab2I1Pgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:36:39 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB2GOV-01-38W-02
X-M-MSG: 
Date: Fri, 28 Sep 2012 17:36:29 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/16] iommu/amd: Add IRTE invalidation routine
Message-ID: <20120928153629.GJ4009@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-8-git-send-email-joerg.roedel@amd.com>
 <20120928142017.GE7483@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120928142017.GE7483@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:20:18AM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 28, 2012 at 02:23:57PM +0200, Joerg Roedel wrote:
> > +static void iommu_flush_irt_all(struct amd_iommu *iommu)
> > +{
> > +	u32 devid;
> > +
> > +	for (devid = 0; devid <= 0xffff; ++devid)
> 
> Should this be #define? Or perhaps based of sizeof?

I'll add a define for that. The 0xffff is a hardware constant, so sizeof
will not work.

> Is there a specific reason that it is u16 in the build_inv_irt but
> here it is u32?

Yes, with u16 the loop-counter will overflow and make it to an endless
loop.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

