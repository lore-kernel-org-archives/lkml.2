Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab0GSNkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 09:40:46 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:2642 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab0GSNko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 09:40:44 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432N98dNzz1202hzz15d4Rz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5T4NK-02-C83-02
X-M-MSG: 
Date: Mon, 19 Jul 2010 15:42:18 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Kulikov Vasiliy <segooon@gmail.com>
CC: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/19] arch/x86/kernel: use for_each_pci_dev()
Message-ID: <20100719134218.GC7454@amd.com>
References: <1278173032-11575-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1278173032-11575-1-git-send-email-segooon@gmail.com>
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

On Sat, Jul 03, 2010 at 12:03:51PM -0400, Kulikov Vasiliy wrote:
> Use for_each_pci_dev() to simplify the code.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  arch/x86/kernel/amd_iommu.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index 0d20286..29dd3b9 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -2609,8 +2609,7 @@ int __init amd_iommu_init_passthrough(void)
>  
>  	pt_domain->mode |= PAGE_MODE_NONE;
>  
> -	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
> -
> +	for_each_pci_dev(dev) {
>  		if (!check_device(&dev->dev))
>  			continue;

Applied, thanks.

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

