Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab2A0U7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:59:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62378 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab2A0U7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:59:02 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: [PATCH v4 15/18] perf: add ABI reference sizes
Date: Fri, 27 Jan 2012 21:56:15 +0100
Message-Id: <1327697778-18515-16-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1327697778-18515-1-git-send-email-eranian@google.com>
References: <1327697778-18515-1-git-send-email-eranian@google.com>
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
index 6d9d712..91452ed 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -195,6 +195,8 @@ enum perf_event_read_format {
 };
 
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
+#define PERF_ATTR_SIZE_VER1	72	/* add: config2 */
+#define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
-- 
1.7.1

