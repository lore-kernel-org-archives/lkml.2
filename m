Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964964Ab1LPTyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:54:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964881Ab1LPTww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:52:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:08 2011
Message-Id: <20111216194208.195539802@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Claudio Scordino <claudio@evidence.eu.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [09/45] fs/proc/meminfo.c: fix compilation error
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Scordino <claudio@evidence.eu.com>

commit b53fc7c2974a50913f49e1d800fe904a28c338e3 upstream.

Fix the error message "directives may not be used inside a macro argument"
which appears when the kernel is compiled for the cris architecture.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/meminfo.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -131,12 +131,13 @@ static int meminfo_proc_show(struct seq_
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


