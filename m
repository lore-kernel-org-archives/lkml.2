Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab2BNVcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:32:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52362 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2BNVca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:32:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] PM / Hibernate: print physical addresses consistently with other parts of kernel
Date: Tue, 14 Feb 2012 22:36:20 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <20120214000447.32522.5191.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20120214000447.32522.5191.stgit@bhelgaas.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202142236.20788.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 14, 2012, Bjorn Helgaas wrote:
> Print physical address info in a style consistent with the %pR style used
> elsewhere in the kernel.
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Applied.

Thanks,
Rafael


> ---
>  kernel/power/snapshot.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index 6a768e5..8e2e746 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -711,9 +711,10 @@ static void mark_nosave_pages(struct memory_bitmap *bm)
>  	list_for_each_entry(region, &nosave_regions, list) {
>  		unsigned long pfn;
>  
> -		pr_debug("PM: Marking nosave pages: %016lx - %016lx\n",
> -				region->start_pfn << PAGE_SHIFT,
> -				region->end_pfn << PAGE_SHIFT);
> +		pr_debug("PM: Marking nosave pages: [mem %#010llx-%#010llx]\n",
> +			 (unsigned long long) region->start_pfn << PAGE_SHIFT,
> +			 ((unsigned long long) region->end_pfn << PAGE_SHIFT)
> +				- 1);
>  
>  		for (pfn = region->start_pfn; pfn < region->end_pfn; pfn++)
>  			if (pfn_valid(pfn)) {
> 
> 
> 

