Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab0HDJts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:49:48 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:7619 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757084Ab0HDJtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:49:45 -0400
X-SpamScore: -40
X-BigFish: VS-40(zz1432N98dN936eM1455M9371P10d1Izz1202hzz15d4Rz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6MGM8-02-1KT-02
X-M-MSG: 
Date: Wed, 4 Aug 2010 11:52:37 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
CC: Zach Pfeffer <zpfeffer@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100804095237.GH18307@amd.com>
References: <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
 <201007291026.55928.arnd@arndb.de>
 <20100729084018.GM26098@amd.com>
 <20100729174621W.fujita.tomonori@lab.ntt.co.jp>
 <20100729090607.GN26098@amd.com>
 <4C586348.2050209@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C586348.2050209@codeaurora.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 02:43:20PM -0400, Stepan Moskovchenko wrote:
>   On 8/3/2010 2:23 AM, Roedel, Joerg wrote:
> > A domain is defined by a single page-table which can be modified using
> > the iommu_map/iommu_unmap function calls. I am not completly sure what
> > you mean by an iommu_context. Can you describe what it means in your
> > context?
> 
> Joerg,
> I think with some rework, all my use cases can be handled by your 
> existing iommu API. If the domain is treated basically a page table, 
> there will be some changes, but I think it can be done. I will push a 
> new version of my driver in a few days.
> 
> One thing that may be helpful for the future, however, is maybe 
> something like adding iommu_tlb_flush to the ops. I suppose this would 
> either have to take a device, or the domain would need to keep a list of 
> devices it had been attached to (so that their TLBs can be invalidated). 
> But I suppose on the other hand, iommu_map/unmap may be able to just 
> implicitly invalidate the TLB also, since TLB invalidation often follows 
> map/unmap. What are your thoughts?

Sounds good. I am curious for your patches :-)

For the TLB-flush question, I think it would make sense to add iommu
tlb flushing functions to the IOMMU-API. We currently flush the TLB
implicitly in the map/unmap calls but thats very inefficient. It would
be better to have a seperate function for it in the API. The right
parameter for such a function is a domain. The IOMMU driver knows which
devices are attached to a domain an could easily flush all TLBs.

One alternative I can think of: An iommu_domain_commit() function which
syncs software changes of a domain to the hardware. The map/unmap calls
have to save which parts of the tlb need to be flushed and commit does
flush those parts then (or flush everything).

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

