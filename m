Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2BIWXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:23:19 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61044 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab2BIWXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:23:16 -0500
MIME-Version: 1.0
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: [PATCH v6 15/18] perf: add ABI reference sizes
Date: Thu,  9 Feb 2012 23:21:05 +0100
Message-Id: <1328826068-11713-16-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1328826068-11713-1-git-send-email-eranian@google.com>
References: <1328826068-11713-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds reference sizes for revision 1
and 2 of the perf_event ABI, i.e., the size of
the perf_event_attr struct.

With Rev1: config2 was added = +8 bytes
With Rev2: branch_sample_type was added = +8 bytes

Adds the definition for Rev1, Rev2.

This is useful for tools trying to decode the revision
numbers based on the size of the struct.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 366e2b4..a1f983b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -192,6 +192,8 @@ enum perf_event_read_format {
 };
 
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
+#define PERF_ATTR_SIZE_VER1	72	/* add: config2 */
+#define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
-- 
1.7.4.1

