Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab1DAHcC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 03:32:02 -0400
Received: from relay.parallels.com ([195.214.232.42]:36324 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab1DAHcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 03:32:01 -0400
Subject: [PATCH] proc: add used mem and swap to meminfo
To: <linux-kernel@vger.kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@openvz.org>
Date: Fri, 1 Apr 2011 11:31:56 +0400
Message-ID: <20110401073156.17372.80123.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes meminfo more human-friendly.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/proc/meminfo.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index ed257d1..8f39076 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -55,6 +55,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	seq_printf(m,
 		"MemTotal:       %8lu kB\n"
 		"MemFree:        %8lu kB\n"
+		"MemUsed:        %8lu kB\n"
 		"Buffers:        %8lu kB\n"
 		"Cached:         %8lu kB\n"
 		"SwapCached:     %8lu kB\n"
@@ -77,6 +78,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 #endif
 		"SwapTotal:      %8lu kB\n"
 		"SwapFree:       %8lu kB\n"
+		"SwapUsed:       %8lu kB\n"
 		"Dirty:          %8lu kB\n"
 		"Writeback:      %8lu kB\n"
 		"AnonPages:      %8lu kB\n"
@@ -107,6 +109,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		,
 		K(i.totalram),
 		K(i.freeram),
+		K(i.totalram-i.freeram),
 		K(i.bufferram),
 		K(cached),
 		K(total_swapcache_pages),
@@ -129,6 +132,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 #endif
 		K(i.totalswap),
 		K(i.freeswap),
+		K(i.totalswap-i.freeswap),
 		K(global_page_state(NR_FILE_DIRTY)),
 		K(global_page_state(NR_WRITEBACK)),
 		K(global_page_state(NR_ANON_PAGES)

