Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0KRKrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:47:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42115 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab0KRKrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:47:47 -0500
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: eranian@google.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] perf: Document enhanced event encoding for OFFCORE_MSR
Date: Thu, 18 Nov 2010 11:47:32 +0100
Message-Id: <1290077254-12165-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290077254-12165-1-git-send-email-andi@firstfloor.org>
References: <1290077254-12165-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-list.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 399751b..700afd7 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -58,6 +58,13 @@ raw encoding of 0x1A8 can be used:
  perf stat -e r1a8 -a sleep 1
  perf record -e r1a8 ...
 
+Some special events on x86 encode additional data in the normally unused 
+[32;63] bits of the raw value. This is particularly used for 
+the OFFCORE_RESPONSE events on Intel Core i7.  The 16bit 
+mask in the OFFCORE_RESPONSE register is put into bits [32;48].
+For example the OFFCORE_RESPONSE_0.ANY_DATA.ANY_CACHE_DRAM event
+is encoded as r00007f11004301b7.
+
 You should refer to the processor specific documentation for getting these
 details. Some of them are referenced in the SEE ALSO section below.
 
-- 
1.7.1

