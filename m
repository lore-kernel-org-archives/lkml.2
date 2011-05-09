Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1EIOtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:49:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:57236 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1EIOtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 10:49:00 -0400
Subject: Re: [PATCH] pci, dmar: flush IOTLB before exit domain
From: David Woodhouse <dwmw2@infradead.org>
To: Yinghai Lu <yinghai.lu@oracle.com>, Kalle Valo <kvalo@adurom.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 09 May 2011 15:48:49 +0100
In-Reply-To: <4DC34B21.9040203@oracle.com>
References: <4DC34B21.9040203@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1304952530.30435.16.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-05 at 18:13 -0700, Yinghai Lu wrote:
> @@ -3252,6 +3252,9 @@ static int device_notifier(struct notifi
>                 return 0;
>  
>         if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through) {
> +               /* before we remove dev with domain, flush IOTLB */
> +               flush_unmaps();
> +
>                 domain_remove_one_dev_info(domain, pdev);
>  
>                 if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) && 

That calls flush_unmaps() without the async_umap_flush_lock held,
doesn't it? A few days ago I asked someone else to test this candidate
patch for a similar issue:

http://david.woodhou.se/flush-unmaps-on-unbind.patch

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

