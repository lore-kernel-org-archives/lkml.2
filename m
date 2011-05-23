Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab1EWKRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 06:17:04 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:6152 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1EWKRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 06:17:02 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz4015L1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLN8K8-01-TID-02
X-M-MSG: 
Date: Mon, 23 May 2011 12:17:01 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:AMD IOMMU (AMD-VI)" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 3/8] x86: Kill set but not used warning
Message-ID: <20110523101701.GB27867@amd.com>
References: <1305918786-7239-1-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-2-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-3-git-send-email-padovan@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1305918786-7239-3-git-send-email-padovan@profusion.mobi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 03:13:00PM -0400, Gustavo F. Padovan wrote:
> Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>

Please provide a short and meaningful commit-msg.

> ---
>  arch/x86/kernel/amd_iommu.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index 873e7e1..cd8cbeb5 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -1538,13 +1538,11 @@ static void do_detach(struct device *dev)
>  {
>  	struct iommu_dev_data *dev_data;
>  	struct amd_iommu *iommu;
> -	struct pci_dev *pdev;
>  	u16 devid;
>  
>  	devid    = get_device_id(dev);
>  	iommu    = amd_iommu_rlookup_table[devid];
>  	dev_data = get_dev_data(dev);
> -	pdev     = to_pci_dev(dev);
>  
>  	/* decrease reference counters */
>  	dev_data->domain->dev_iommu[iommu->index] -= 1;

This is already gone upstream.

> @@ -1703,10 +1701,9 @@ static struct protection_domain *domain_for_device(struct device *dev)
>  	struct protection_domain *dom;
>  	struct iommu_dev_data *dev_data, *alias_data;
>  	unsigned long flags;
> -	u16 devid, alias;
> +	u16 devid;
>  
>  	devid      = get_device_id(dev);
> -	alias      = amd_iommu_alias_table[devid];
>  	dev_data   = get_dev_data(dev);
>  	alias_data = get_dev_data(dev_data->alias);
>  	if (!alias_data)

This is still there. Can you please rebase this patch against
linus/master and send again?

Thanks,

	Joerg


