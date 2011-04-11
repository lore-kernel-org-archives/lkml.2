Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab1DKOJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:09:36 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:31627
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751609Ab1DKOJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:09:34 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zz1432N98dK148cMzz1202hzz15d4Rz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJHR9Y-01-0CG-02
X-M-MSG: 
Date: Mon, 11 Apr 2011 16:08:21 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86/amd-iommu: Add support for invalidate_all
 command
Message-ID: <20110411140821.GJ23633@amd.com>
References: <1302514324-14717-1-git-send-email-joerg.roedel@amd.com>
 <1302514324-14717-3-git-send-email-joerg.roedel@amd.com>
 <20110411135708.GB28056@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110411135708.GB28056@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 09:57:08AM -0400, Henrique de Moraes Holschuh wrote:
> On Mon, 11 Apr 2011, Joerg Roedel wrote:
> > This patch adds support for the invalidate_all command
> > present in new versions of the AMD IOMMU.
> 
> ...
> 
> >  #define CMD_COMPL_WAIT          0x01
> >  #define CMD_INV_DEV_ENTRY       0x02
> >  #define CMD_INV_IOMMU_PAGES     0x03
> > +#define CMD_INV_ALL		0x08
> 
> ...
> 
> > @@ -463,6 +463,12 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
> >  		cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
> >  }
> >  
> > +static void build_inv_all(struct iommu_cmd *cmd)
> > +{
> > +	memset(cmd, 0, sizeof(*cmd));
> > +	CMD_SET_TYPE(cmd, CMD_INV_DEV_ENTRY);
> 
> Huh?

Copy&Paste error :( Thanks for pointing it out.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

