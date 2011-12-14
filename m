Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab1LNN2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 08:28:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61309 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab1LNN2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:28:10 -0500
Message-ID: <4EE8A461.2080406@gmail.com>
Date: Wed, 14 Dec 2011 21:28:01 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/mempolicy.c: use enum value MPOL_REBIND_ONCE instead of
 0 in mpol_rebind_policy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have enum definition in mempolicy.h: MPOL_REBIND_ONCE.
It should replace the magic number 0 for step comparison in
function mpol_rebind_policy.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 mm/mempolicy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 9c51f9f..ecdaa8d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -390,7 +390,7 @@ static void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask,
 {
 	if (!pol)
 		return;
-	if (!mpol_store_user_nodemask(pol) && step == 0 &&
+	if (!mpol_store_user_nodemask(pol) && step == MPOL_REBIND_ONCE &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
 		return;
 
-- 
1.7.1


