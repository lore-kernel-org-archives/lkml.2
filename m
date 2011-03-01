Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab1CAQZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:25:01 -0500
Received: from smtp.nokia.com ([147.243.1.47]:57906 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452Ab1CAQZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:25:00 -0500
From: Aaro Koskinen <aaro.koskinen@nokia.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Aaro Koskinen <aaro.koskinen@nokia.com>, stable@kernel.org
Subject: [PATCH] procfs: fix /proc/<pid>/maps heap check
Date: Tue,  1 Mar 2011 18:26:53 +0200
Message-Id: <1298996813-8625-1-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current check looks wrong and prints "[heap]" only if the mapping
matches exactly the heap. However, the heap may be merged with some
other mappings, and there may be also be multiple mappings.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: stable@kernel.org
---
 fs/proc/task_mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 60b9148..f269ee6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -249,8 +249,8 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 		const char *name = arch_vma_name(vma);
 		if (!name) {
 			if (mm) {
-				if (vma->vm_start <= mm->start_brk &&
-						vma->vm_end >= mm->brk) {
+				if (vma->vm_start <= mm->brk &&
+						vma->vm_end >= mm->start_brk) {
 					name = "[heap]";
 				} else if (vma->vm_start <= mm->start_stack &&
 					   vma->vm_end >= mm->start_stack) {
-- 
1.5.6.5

