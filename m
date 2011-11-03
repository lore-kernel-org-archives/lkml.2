Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041Ab1KCQ1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:27:17 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52242 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454Ab1KCQ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:27:15 -0400
Message-ID: <4EB2C0DF.9050301@evidence.eu.com>
Date: Thu, 03 Nov 2011 17:27:11 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH] /fs/proc/meminfo.c: fix compilation error
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

	the current mainline kernel gives a "directives may not be used inside a 
macro argument" error message when compiled for the cris architecture.

The error is located in the /fs/proc/meminfo.c file.

The attached patch fixed this error.

Best regards,

	Claudio Scordino



Subject: /fs/proc/meminfo.c: fix compilation error
From: Claudio Scordino <claudio@evidence.eu.com>

Patch to fix the error message "directives may not be used inside a macro
argument" which appears when the kernel is compiled for the cris architecture.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
---
 fs/proc/meminfo.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 5861741..80e4645 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -131,12 +131,13 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		K(i.freeswap),
 		K(global_page_state(NR_FILE_DIRTY)),
 		K(global_page_state(NR_WRITEBACK)),
-		K(global_page_state(NR_ANON_PAGES)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		K(global_page_state(NR_ANON_PAGES)
 		  + global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
-		  HPAGE_PMD_NR
+		  HPAGE_PMD_NR),
+#else
+		K(global_page_state(NR_ANON_PAGES)),
 #endif
-		  ),
 		K(global_page_state(NR_FILE_MAPPED)),
 		K(global_page_state(NR_SHMEM)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE) +
-- 
1.7.1

