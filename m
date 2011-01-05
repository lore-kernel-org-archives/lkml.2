Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab1AERZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:25:59 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:43981 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1AERZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:25:58 -0500
Date: Wed, 5 Jan 2011 12:24:24 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mel@csn.ul.ie,
        stable@kernel.org, akpm@linux-foundation.org
Message-ID: <1765861398.142320.1294248264472.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1294247329-11682-1-git-send-email-emunson@mgebm.net>
Subject: Re: [PATCH] Fix handling of parse errors in sysctl
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a minor issue.

----- Original Message -----
> This patch is a candidate for stable.
> 
> ==== CUT HERE ====
> 
> When parsing changes to the huge page pool sizes made from userspace
> via the sysctl interface, bogus input values are being covered up
Those are for sysfs code path. sysctl path should be handled by Michal's
patch touched hugetlb_sysctl_handler_common and hugetlb_overcommit_handler.
> by nr_hugepages_store_common and nr_overcommit_hugepages_store
> returning 0 when strict_strtoul returns an error. This patch changes
> the return value for these functions to -EINVAL when strict_strtoul
> returns an error.
> 
> Reported-by: CAI Qian <caiqian@redhat.com>
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> ---
> mm/hugetlb.c | 4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8585524..5cb71a9 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1440,7 +1440,7 @@ static ssize_t nr_hugepages_store_common(bool
> obey_mempolicy,
> 
> err = strict_strtoul(buf, 10, &count);
> if (err)
> - return 0;
> + return -EINVAL;
> 
> h = kobj_to_hstate(kobj, &nid);
> if (nid == NUMA_NO_NODE) {
> @@ -1519,7 +1519,7 @@ static ssize_t
> nr_overcommit_hugepages_store(struct kobject *kobj,
> 
> err = strict_strtoul(buf, 10, &input);
> if (err)
> - return 0;
> + return -EINVAL;
> 
> spin_lock(&hugetlb_lock);
> h->nr_overcommit_huge_pages = input;
> --
> 1.7.1
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org. For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
