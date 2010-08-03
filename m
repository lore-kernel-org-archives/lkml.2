Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab0HCJXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:23:39 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:36337
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754996Ab0HCJXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:23:36 -0400
X-SpamScore: -25
X-BigFish: VS-25(zz1dbaL1432N98dNzz1202hzz15d4Rz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6KKLS-02-HS1-02
X-M-MSG: 
Date: Tue, 3 Aug 2010 11:23:25 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Zach Pfeffer <zpfeffer@codeaurora.org>
CC: "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100803092325.GD18307@amd.com>
References: <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
 <201007291026.55928.arnd@arndb.de>
 <20100729084018.GM26098@amd.com>
 <20100729174621W.fujita.tomonori@lab.ntt.co.jp>
 <20100729090607.GN26098@amd.com>
 <d493494df33aaf65e526181b1dbafce3.squirrel@www.codeaurora.org>
 <20100802075802.GN24084@amd.com>
 <20100802202935.GA26214@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100802202935.GA26214@codeaurora.org>
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

On Mon, Aug 02, 2010 at 04:29:38PM -0400, Zach Pfeffer wrote:
> On Mon, Aug 02, 2010 at 09:58:02AM +0200, Roedel, Joerg wrote:

> > In the means of the IOMMU-API the domain is the abstraction of an
> > address space (in other words a page table). The IOMMU(s) which this domain
> > is later assigned to are determined by the iommu_attach_device calls.
> > I think the right way to go here is to create the concept of a
> > device-context in the IOMMU-API and add functions like
> > 
> > 	iommu_attach_context(struct iommu_domain *domain,
> > 			     struct iommu_context *ctxt);
> > 	iommu_detach_context(struct iommu_context *ctxt);
> > 
> > This would work if you can determine in your iommu-driver which iommu
> > you need to program for which device. What do you think?
> > 
> 
> Joerg, I'd like to make sure I understand this. A domain is an address
> space separate from the actual page-tables that may be part of an
> iommu_context, correct? After I iommu_attach_context the ctxt will
> reflect the address space of the domain, correct?

A domain is defined by a single page-table which can be modified using
the iommu_map/iommu_unmap function calls. I am not completly sure what
you mean by an iommu_context. Can you describe what it means in your
context?

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

