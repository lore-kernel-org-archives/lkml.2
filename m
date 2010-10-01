Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab0JAJHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 05:07:11 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:49812
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755792Ab0JAJHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:07:09 -0400
X-SpamScore: -21
X-BigFish: VS-21(zz1432N98dNzz1202hzz15d4Rz32i87h2a8h43h64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9LTB7-02-4S7-02
X-M-MSG: 
Date: Fri, 1 Oct 2010 11:07:24 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Ingo Molnar <mingo@elte.hu>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 2/3] x86/amd-iommu: Work around S3 BIOS bug
Message-ID: <20101001090723.GQ9817@amd.com>
References: <1285253089-4570-1-git-send-email-joerg.roedel@amd.com>
 <1285253089-4570-3-git-send-email-joerg.roedel@amd.com>
 <20100930202104.GA20495@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100930202104.GA20495@srcf.ucam.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 04:21:04PM -0400, Matthew Garrett wrote:
> On Thu, Sep 23, 2010 at 04:44:48PM +0200, Joerg Roedel wrote:
> > +static void iommu_apply_quirks(struct amd_iommu *iommu)
> > +{
> > +	if (is_rd890_iommu(iommu->dev)) {
> > +		pci_write_config_dword(iommu->dev, 0xf0, iommu->cache_cfg[0]);
> > +		pci_write_config_dword(iommu->dev, 0xf4, iommu->cache_cfg[1]);
> > +		pci_write_config_dword(iommu->dev, 0xf8, iommu->cache_cfg[2]);
> > +		pci_write_config_dword(iommu->dev, 0xfc, iommu->cache_cfg[3]);
> > +	}
> > +}
> > +
> 
> This doesn't look right. 0xf0-0xff are for indexed register access, so 
> what you're doing here is just restoring the last of each of those 
> registers that the BIOS programmed - and if the BIOS cleared the 
> writable flag afterwards, you're not even doing that.

With a half-fixed BIOS (a BIOS which re-enables the IOMMU on resume)
this was the necessary step to make the IOMMU execute commands again. So
it actually fixed the problem I have seen. I agree that its better to
fully restore the indirect register spaces when we workaround the fully
broken BIOSes. When we have this I remove this code, but until then it
fixes the problem.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

