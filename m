Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3AGS2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:28:43 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:53326 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3AGS2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:28:39 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v5 09/18] perf/x86: export PEBS load latency threshold register to sysfs
Date: Mon,  7 Jan 2013 19:27:48 +0100
Message-Id: <1357583277-4553-10-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357583277-4553-1-git-send-email-eranian@google.com>
References: <1357583277-4553-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the PEBS Load Latency threshold register layout
and encoding visible to user level tools.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 1d2a7ca..8eced4c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1755,6 +1755,8 @@ static void intel_pmu_flush_branch_stack(void)
 
 PMU_FORMAT_ATTR(offcore_rsp, "config1:0-63");
 
+PMU_FORMAT_ATTR(ldlat, "config1:0-15");
+
 static struct attribute *intel_arch3_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
@@ -1765,6 +1767,7 @@ static struct attribute *intel_arch3_formats_attr[] = {
 	&format_attr_cmask.attr,
 
 	&format_attr_offcore_rsp.attr, /* XXX do NHM/WSM + SNB breakout */
+	&format_attr_ldlat.attr, /* PEBS load latency */
 	NULL,
 };
 
-- 
1.7.9.5

