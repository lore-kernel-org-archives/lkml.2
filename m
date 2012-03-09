Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab2CINac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:30:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58768 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab2CINab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:30:31 -0500
Date: Fri, 9 Mar 2012 05:30:04 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-cb5d76999029ae7a517cb07dfa732c1b5a934fc2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1328826068-11713-16-git-send-email-eranian@google.com>
References: <1328826068-11713-16-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf: Add ABI reference sizes
Git-Commit-ID: cb5d76999029ae7a517cb07dfa732c1b5a934fc2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:30:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb5d76999029ae7a517cb07dfa732c1b5a934fc2
Gitweb:     http://git.kernel.org/tip/cb5d76999029ae7a517cb07dfa732c1b5a934fc2
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 9 Feb 2012 23:21:05 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Mar 2012 08:26:05 +0100

perf: Add ABI reference sizes

This patch adds reference sizes for revision 1
and 2 of the perf_event ABI, i.e., the size of
the perf_event_attr struct.

With Rev1: config2 was added = +8 bytes
With Rev2: branch_sample_type was added = +8 bytes

Adds the definition for Rev1, Rev2.

This is useful for tools trying to decode the revision
numbers based on the size of the struct.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: robert.richter@amd.com
Cc: ming.m.lin@intel.com
Cc: andi@firstfloor.org
Cc: asharma@fb.com
Cc: ravitillo@lbl.gov
Cc: vweaver1@eecs.utk.edu
Cc: khandual@linux.vnet.ibm.com
Cc: dsahern@gmail.com
Link: http://lkml.kernel.org/r/1328826068-11713-16-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index fbbf5e5..bd9f55a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -192,6 +192,8 @@ enum perf_event_read_format {
 };
 
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
+#define PERF_ATTR_SIZE_VER1	72	/* add: config2 */
+#define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
