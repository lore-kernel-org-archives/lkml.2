Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab1BXRCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:02:54 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:34527 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab1BXRCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:02:52 -0500
Date: Thu, 24 Feb 2011 12:02:11 -0500 (EST)
From: Petr Holasek <pholasek@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org
Message-ID: <395193561.595052.1298566931517.JavaMail.root@zmail04.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4D6419C0.8080804@redhat.com>
Subject: Re: [PATCH v2] hugetlbfs: correct handling of negative input to
 /proc/sys/vm/nr_hugepages
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Petr Holasek" <pholasek@redhat.com>
> To: linux-kernel@vger.kernel.org
> Cc: "Petr Holasek" <pholasek@redhat.com>, "Andi Kleen" <ak@linux.intel.com>, "Naoya Horiguchi"
> <n-horiguchi@ah.jp.nec.com>, "Mel Gorman" <mel@csn.ul.ie>, "Andrew Morton" <akpm@linux-foundation.org>, "Wu Fengguang"
> <fengguang.wu@intel.com>, linux-mm@kvack.org
> Sent: Tuesday, February 22, 2011 9:17:04 PM
> Subject: [PATCH v2] hugetlbfs: correct handling of negative input to /proc/sys/vm/nr_hugepages
> When user insert negative value into /proc/sys/vm/nr_hugepages it will
> result
> in the setting a random number of HugePages in system (can be easily
> showed
> at /proc/meminfo output). This patch fixes the wrong behavior so that
> the
> negative input will result in nr_hugepages value unchanged.
> 
> v2: same fix was also done in hugetlb_overcommit_handler function
> as suggested by reviewers.
> 
> Signed-off-by: Petr Holasek <pholasek@redhat.com>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
> mm/hugetlb.c | 6 ++----
> 1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index bb0b7c1..06de5aa 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1872,8 +1872,7 @@ static int hugetlb_sysctl_handler_common(bool
> obey_mempolicy,
> unsigned long tmp;
> int ret;
> 
> - if (!write)
> - tmp = h->max_huge_pages;
> + tmp = h->max_huge_pages;
> 
> if (write && h->order >= MAX_ORDER)
> return -EINVAL;
> @@ -1938,8 +1937,7 @@ int hugetlb_overcommit_handler(struct ctl_table
> *table, int write,
> unsigned long tmp;
> int ret;
> 
> - if (!write)
> - tmp = h->nr_overcommit_huge_pages;
> + tmp = h->nr_overcommit_huge_pages;
> 
> if (write && h->order >= MAX_ORDER)
> return -EINVAL;
> --
> 1.7.1
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/

I am really sorry, but tabs were broken up into spaces during posting,
here is the right version:

thanks,
Petr

---
 mm/hugetlb.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bb0b7c1..06de5aa 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1872,8 +1872,7 @@ static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
 	unsigned long tmp;
 	int ret;
 
-	if (!write)
-		tmp = h->max_huge_pages;
+	tmp = h->max_huge_pages;
 
 	if (write && h->order >= MAX_ORDER)
 		return -EINVAL;
@@ -1938,8 +1937,7 @@ int hugetlb_overcommit_handler(struct ctl_table *table, int write,
 	unsigned long tmp;
 	int ret;
 
-	if (!write)
-		tmp = h->nr_overcommit_huge_pages;
+	tmp = h->nr_overcommit_huge_pages;
 
 	if (write && h->order >= MAX_ORDER)
 		return -EINVAL;
-- 
1.7.1
