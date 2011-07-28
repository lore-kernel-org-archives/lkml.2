Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1G1L2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 07:28:52 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57115 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab1G1L2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 07:28:48 -0400
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, eyal@mips.com, zenon@mips.com,
        dengcheng.zhu@gmail.com
Subject: [PATCH 2/2] kernel/resource: enrich the comment for insert_resource_conflict()
Date: Thu, 28 Jul 2011 19:28:32 +0800
Message-Id: <1311852512-7340-3-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1311852512-7340-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1311852512-7340-1-git-send-email-dengcheng.zhu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It helps people better understand how this function works.

Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 kernel/resource.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 3ff4017..5406ecf 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -617,7 +617,9 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
  * happens. If a conflict happens, and the conflicting resources
  * entirely fit within the range of the new resource, then the new
  * resource is inserted and the conflicting resources become children of
- * the new resource.
+ * the new resource. Also, if the new resource entirely fits within the range
+ * of a conflicting resource without overlapping the latter's children, then
+ * the new resource is inserted too and becomes a child of the conflicting one.
  */
 struct resource *insert_resource_conflict(struct resource *parent, struct resource *new)
 {
-- 
1.7.1

