Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152Ab0KPKEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:04:10 -0500
Received: from dgate20.ts.fujitsu.com ([80.70.172.51]:41166 "EHLO
	dgate20.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab0KPKEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:04:07 -0500
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=VtBl3YZ5TbUpLI/329MFxxIc01nclvRHVFvZx8hA2bexdfuTBa5FQkES
   IGW7okxdjwmBRbPvQjGxwU+tiZJw3pFKWo/Gcmn0ae/rah0sYhnkcW4Se
   p315IrwPpfyu1q9op9trNfUwPabrjFfd4Rk2FTAqPevB38J/U8kKBLrq2
   Yz1JOmKufBeKC376QNqPzi1/xNj143zct62Z4/qjieR0G9sa6tGMpFA0U
   NpN9z5oHe31etoskx2ktP1o1jaUYm;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.59,205,1288566000"; 
   d="scan'208";a="51465168"
X-IronPort-AV: E=Sophos;i="4.59,205,1288566000"; 
   d="scan'208";a="103064115"
Message-ID: <4CE2570E.50609@ts.fujitsu.com>
Date: Tue, 16 Nov 2010 11:03:58 +0100
From: Martin Wilck <martin.wilck@ts.fujitsu.com>
Organization: Fujitsu Technology Solutions
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de-AT; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: "djwong@us.ibm.com" <djwong@us.ibm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [REGRESSSION 2.6.37-rc2][PATCH] pci: Fix mmap address check in
 pci_mmap_fits
References: <20101116072247.GQ14383@tux1.beaverton.ibm.com> <20101116075814.GR14383@tux1.beaverton.ibm.com>
In-Reply-To: <20101116075814.GR14383@tux1.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

> I think what we want here is for pci_start to be 0 when mmap_api ==
> PCI_MMAP_PROCFS.  The following patch makes that change, after which the Matrox
> and Mach64 X drivers work again.

Of course. I made a stupid mistake when I introduced the enum :-( Thanks 
for spotting and fixing it so quickly.

Jesse, please apply Darrick's fix.

Martin

> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 95712a3..63d5042 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -715,7 +715,7 @@ int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma,
>   	nr = (vma->vm_end - vma->vm_start)>>  PAGE_SHIFT;
>   	start = vma->vm_pgoff;
>   	size = ((pci_resource_len(pdev, resno) - 1)>>  PAGE_SHIFT) + 1;
> -	pci_start = (mmap_api == PCI_MMAP_SYSFS) ?
> +	pci_start = (mmap_api == PCI_MMAP_PROCFS) ?
>   			pci_resource_start(pdev, resno)>>  PAGE_SHIFT : 0;
>   	if (start>= pci_start&&  start<  pci_start + size&&
>   			start + nr<= pci_start + size)

-- 
Dr. Martin Wilck
PRIMERGY System Software Engineer
x86 Server Engineering

FUJITSU
Fujitsu Technology Solutions GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn, Germany
Phone:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			martin.wilck@ts.fujitsu.com
Internet:		http://ts.fujitsu.com
Company Details:	http://ts.fujitsu.com/imprint
