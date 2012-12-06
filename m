Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423010Ab2LFKMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:12:54 -0500
Received: from gmmr7.centrum.cz ([46.255.225.249]:36837 "EHLO gmmr7.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422686Ab2LFKMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:12:52 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Thu, 06 Dec 2012 11:12:49 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20121130144427.51A09169@pobox.sk>, <20121130144431.GI29317@dhcp22.suse.cz>, <20121130160811.6BB25BDD@pobox.sk>, <20121130153942.GL29317@dhcp22.suse.cz>, <20121130165937.F9564EBE@pobox.sk>, <20121130161923.GN29317@dhcp22.suse.cz>, <20121203151601.GA17093@dhcp22.suse.cz>, <20121205023644.18C3006B@pobox.sk>, <20121205141722.GA9714@dhcp22.suse.cz>, <20121206012924.FE077FD7@pobox.sk> <20121206095423.GB10931@dhcp22.suse.cz>
In-Reply-To: <20121206095423.GB10931@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121206111249.58F013EA@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Dohh. The very same stack mem_cgroup_newpage_charge called from the page
>fault. The heavy inlining is not particularly helping here... So there
>must be some other THP charge leaking out.
>[/me is diving into the code again]
>
>* do_huge_pmd_anonymous_page falls back to handle_pte_fault
>* do_huge_pmd_wp_page_fallback falls back to simple pages so it doesn't
>  charge the huge page
>* do_huge_pmd_wp_page splits the huge page and retries with fallback to
>  handle_pte_fault
>* collapse_huge_page is not called in the page fault path
>* do_wp_page, do_anonymous_page and __do_fault  operate on a single page
>  so the memcg charging cannot return ENOMEM
>
>There are no other callers AFAICS so I am getting clueless. Maybe more
>debugging will tell us something (the inlining has been reduced for thp
>paths which can reduce performance in thp page fault heavy workloads but
>this will give us better traces - I hope).


Should i apply all patches togather? (fix for this bug, more log messages, backported fix from 3.5 and this new one)


>Anyway do you see the same problem if transparent huge pages are
>disabled?
>echo never > /sys/kernel/mm/transparent_hugepage/enabled)


# cat /sys/kernel/mm/transparent_hugepage/enabled
cat: /sys/kernel/mm/transparent_hugepage/enabled: No such file or directory
