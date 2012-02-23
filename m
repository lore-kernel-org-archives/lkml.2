Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2BWOoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:44:32 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39157 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab2BWOob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:44:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.68.193.136 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120223135328.12988.87152.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
	<20120223135328.12988.87152.stgit@zurg>
Date: Thu, 23 Feb 2012 22:44:30 +0800
Message-ID: <CAJd=RBB8b_zpESue8_=A=oL1E6P8HDCyVYEPASH=1vq20nXLxA@mail.gmail.com>
Subject: Re: [PATCH v3 21/21] mm: zone lru vectors interleaving
From: Hillf Danton <dhillf@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 9:53 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> @@ -4312,7 +4312,7 @@ void init_zone_lruvec(struct zone *zone, struct lruvec *lruvec)
>  static void __paginginit free_area_init_core(struct pglist_data *pgdat,
>                unsigned long *zones_size, unsigned long *zholes_size)
>  {
> -       enum zone_type j;
> +       enum zone_type j, lruvec_id;

Like other cases in the patch,

          int lruvec_id;

looks clearer

>        int nid = pgdat->node_id;
>        unsigned long zone_start_pfn = pgdat->node_start_pfn;
>        int ret;
> @@ -4374,7 +4374,8 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
>                zone->zone_pgdat = pgdat;
>
>                zone_pcp_init(zone);
> -               init_zone_lruvec(zone, &zone->lruvec);
> +               for_each_lruvec_id(lruvec_id)
> +                       init_zone_lruvec(zone, &zone->lruvec[lruvec_id]);
>                zap_zone_vm_stats(zone);
>                zone->flags = 0;
>                if (!size)
