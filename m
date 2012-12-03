Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab2LCUDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:03:12 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:4323
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554Ab2LCUDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:03:09 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(z551biz98dIzz1de0h1202h1d1ah1d2ahzzz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
Message-ID: <50BD056F.7070701@freescale.com>
Date: Mon, 3 Dec 2012 14:02:55 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Firefox/16.0 SeaMonkey/2.13.1
MIME-Version: 1.0
To: Varun Sethi <Varun.Sethi@freescale.com>
CC: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>
Subject: Re: [PATCH 4/4 v6] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
References: <1354360921-20850-1-git-send-email-Varun.Sethi@freescale.com>
In-Reply-To: <1354360921-20850-1-git-send-email-Varun.Sethi@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Varun Sethi wrote:

> +	out_be32(&pamu_regs->ppbah, ((u64)ppaact_phys) >> 32);
> +	out_be32(&pamu_regs->ppbal, ppaact_phys);
> +	ppaact_phys = ppaact_phys + PAACT_SIZE;
> +	out_be32(&pamu_regs->pplah, ((u64)ppaact_phys) >> 32);
> +	out_be32(&pamu_regs->pplal, ppaact_phys);

Instead of  ((u64)ppaact_phys) >> 32, use upper_32_bits() and lower_32_bits().

> +#define PAACE_NUMBER_ENTRIES    0xFF

This is going to break with large LIODNs.  Instead of hard-coding the size
of the PPAACT, you need to scan the device tree for the largest LIODN, and
make the array dynamically sized.

-- 
Timur Tabi
Linux kernel developer at Freescale

