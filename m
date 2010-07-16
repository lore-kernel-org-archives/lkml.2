Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935080Ab0GPARU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 20:17:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42457 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934459Ab0GPART (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 20:17:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Jul 2010 09:12:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 4/5] v2 Update sysfs node routines for new sysfs memory
 directories
Message-Id: <20100716091239.69f40e47.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C3F5628.6030809@austin.ibm.com>
References: <4C3F53D1.3090001@austin.ibm.com>
	<4C3F5628.6030809@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010 13:40:40 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Update the node sysfs directory routines that create
> links to the memory sysfs directories under each node.
> This update makes the node code aware that a memory sysfs
> directory can cover multiple memory sections.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Shouldn't "static int link_mem_sections(int nid)" be update ?
It does
 for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
        register..

Thanks,
-Kame


> ---
>  drivers/base/node.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/drivers/base/node.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/node.c	2010-07-15 09:54:06.000000000 -0500
> +++ linux-2.6/drivers/base/node.c	2010-07-15 09:56:16.000000000 -0500
> @@ -346,8 +346,10 @@
>  		return -EFAULT;
>  	if (!node_online(nid))
>  		return 0;
> -	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
> -	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
> +
> +	sect_start_pfn = section_nr_to_pfn(mem_blk->start_phys_index);
> +	sect_end_pfn = section_nr_to_pfn(mem_blk->end_phys_index);
> +	sect_end_pfn += PAGES_PER_SECTION - 1;
>  	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
>  		int page_nid;
>  
> @@ -383,8 +385,10 @@
>  	if (!unlinked_nodes)
>  		return -ENOMEM;
>  	nodes_clear(*unlinked_nodes);
> -	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
> -	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
> +
> +	sect_start_pfn = section_nr_to_pfn(mem_blk->start_phys_index);
> +	sect_end_pfn = section_nr_to_pfn(mem_blk->end_phys_index);
> +	sect_end_pfn += PAGES_PER_SECTION - 1;
>  	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
>  		int nid;
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

