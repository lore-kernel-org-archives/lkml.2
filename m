Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab0FPO4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:56:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35013 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0FPO4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:56:44 -0400
Date: Wed, 16 Jun 2010 16:56:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Pavel V. Panteleev" <pp_84@mail.ru>
Cc: linux-mm@kvak.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
       tj@kernel.org
Subject: Re: [patch] percpu in linux-2.6.35-rc3
Message-ID: <20100616145639.GE17599@basil.fritz.box>
References: <E1OOr6Q-0005Zi-00.pp_84-mail-ru@f57.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OOr6Q-0005Zi-00.pp_84-mail-ru@f57.mail.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 03:48:18PM +0400, Pavel V. Panteleev wrote:
> Hello! My name is Pavel V. Panteleev.
> 
> While working with percpu on linux-2.6.35-rc3 I have found trivial bugs in pcpu_build_alloc_info() function:
> - we should memset group_cnt to 0 by size of group_cnt, not size of group_map;
> - we can delete useless variable group_cnt_max.

Thanks for the patch. Tejun maintains percpu code these days,
putting him into cc.

-Andi

Pavel's patch:

--- percpu_old.c	2010-06-12 06:14:04.000000000 +0400
+++ percpu_new.c	2010-06-16 15:05:16.280214868 +0400
@@ -1086,7 +1086,7 @@
 	static int group_map[NR_CPUS] __initdata;
 	static int group_cnt[NR_CPUS] __initdata;
 	const size_t static_size = __per_cpu_end - __per_cpu_start;
-	int group_cnt_max = 0, nr_groups = 1, nr_units = 0;
+	int nr_groups = 1, nr_units = 0;
 	size_t size_sum, min_unit_size, alloc_size;
 	int upa, max_upa, uninitialized_var(best_upa);	/* units_per_alloc */
 	int last_allocs, group, unit;
@@ -1096,7 +1096,7 @@
 
 	/* this function may be called multiple times */
 	memset(group_map, 0, sizeof(group_map));
-	memset(group_cnt, 0, sizeof(group_map));
+	memset(group_cnt, 0, sizeof(group_cnt));
 
 	/*
 	 * Determine min_unit_size, alloc_size and max_upa such that
@@ -1130,7 +1130,6 @@
 		}
 		group_map[cpu] = group;
 		group_cnt[group]++;
-		group_cnt_max = max(group_cnt_max, group_cnt[group]);
 	}
 
 	/*

-- 
ak@linux.intel.com -- Speaking for myself only.
