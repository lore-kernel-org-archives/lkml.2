Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab1BYJMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 04:12:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56525 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab1BYJMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 04:12:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OXcmZsH0+7aa+Rug9CmvPwT9oZM2CkBAQpsMvrUfzdwhxFUA9evcxGOr9wlUqGpU5j
         46phc0yCavTGz4TWUhCpSX8+CqJIbApui4N5D6QRkVTZ684y2D4og+TL0KJWehd/mNc8
         2L6iGE7nV6liClTPSXSO6jTVzO1nscgRqm+04=
Date: Fri, 25 Feb 2011 10:11:58 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH x86-mm] x86-64, NUMA: Fix size of numa_distance array
Message-ID: <20110225091158.GD24828@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <20110224193211.GC15498@elte.hu>
 <AANLkTimvJ=BLDjoRDXg_TRSepd9GoDx-w_FonSCZtybi@mail.gmail.com>
 <alpine.DEB.2.00.1102241330270.28798@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102241330270.28798@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1f565a896ee139a70e1a16f74a4ec29707691b0b Mon Sep 17 00:00:00 2001
From: David Rientjes <rientjes@google.com>
Date: Fri, 25 Feb 2011 10:06:39 +0100

numa_distance should be sized like the SLIT, an NxN matrix where N is
the highest node id + 1.  This patch fixes the calculation to avoid
overflowing the array on the subsequent iteration.

-tj: The original patch used last index to calculate size.  Yinghai
     pointed out it should be incremented so it is the number of
     elements instead of the last index to calculate the size of the
     table.  Updated accordingly.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied with cnt++ added as Yinghai pointed out.  Thanks.

 arch/x86/mm/numa_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index cccc01d..7757d22 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -414,7 +414,8 @@ static int __init numa_alloc_distance(void)
 
 	for_each_node_mask(i, nodes_parsed)
 		cnt = i;
-	size = ++cnt * sizeof(numa_distance[0]);
+	cnt++;
+	size = cnt * cnt * sizeof(numa_distance[0]);
 
 	phys = memblock_find_in_range(0, (u64)max_pfn_mapped << PAGE_SHIFT,
 				      size, PAGE_SIZE);
-- 
1.7.1

