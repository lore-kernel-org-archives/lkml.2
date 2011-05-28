Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab1E1Ovu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 10:51:50 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:49037 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753518Ab1E1Ovs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 10:51:48 -0400
Date: Sat, 28 May 2011 16:39:31 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Ankita Garg <ankita@in.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org
Subject: Re: [PATCH 10/10] mm: Create memory regions at boot-up
Message-ID: <20110528143931.GB3603@game.jcrosoft.org>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
 <1306499498-14263-11-git-send-email-ankita@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306499498-14263-11-git-send-email-ankita@in.ibm.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 864972605360286627
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:01 Fri 27 May     , Ankita Garg wrote:
> Memory regions are created at boot up time, from the information obtained
> from the firmware. This patchset was developed on ARM platform, on which at
> present u-boot bootloader does not export information about memory units that
> can be independently power managed. For the purpose of demonstration, 2 hard
> coded memory regions are created, of 256MB each on the Panda board with 512MB
> RAM.
> 
> Signed-off-by: Ankita Garg <ankita@in.ibm.com>
> ---
>  include/linux/mmzone.h |    8 +++-----
>  mm/page_alloc.c        |   29 +++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index bc3e3fd..5dbe1e1 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -627,14 +627,12 @@ typedef struct mem_region_list_data {
>   */
>  struct bootmem_data;
>  typedef struct pglist_data {
> -/*	The linkage to node_zones is now removed. The new hierarchy introduced
> - *	is pg_data_t -> mem_region -> zones
> - * 	struct zone node_zones[MAX_NR_ZONES];
> - */
>  	struct zonelist node_zonelists[MAX_ZONELISTS];
>  	int nr_zones;
>  #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
> -	struct page *node_mem_map;
> +	strs pg_data_t -> mem_region -> zones
> + *      struct zone node_zones[MAX_NR_ZONES];
> + */uct page *node_mem_map;
what is time?
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
>  	struct page_cgroup *node_page_cgroup;
>  #endif
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index da8b045..3d994e8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4285,6 +4285,34 @@ static inline int pageblock_default_order(unsigned int order)
>  
>  #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
>  
> +#define REGIONS_SIZE   (512 << 20) >> PAGE_SHIFT
fix a region size why?
> +
> +static void init_node_memory_regions(struct pglist_data *pgdat)
> +{
Best Regards,
J.
