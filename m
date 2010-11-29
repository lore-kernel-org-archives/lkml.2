Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0K2RZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:25:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869Ab0K2RZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:25:54 -0500
From: Avi Kivity <avi@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: [PATCH trace-cmd] kvm: don't warn on new fields
Date: Mon, 29 Nov 2010 19:25:39 +0200
Message-Id: <1291051539-16791-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kvm plugin understands a few new fields; don't warn if they are missing,
as expected on older kernels.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 plugin_kvm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/plugin_kvm.c b/plugin_kvm.c
index c1cb2e4..8115235 100644
--- a/plugin_kvm.c
+++ b/plugin_kvm.c
@@ -249,15 +249,15 @@ static int kvm_exit_handler(struct trace_seq *s, struct record *record,
 	if (pevent_get_field_val(s, event, "exit_reason", record, &val, 1) < 0)
 		return -1;
 
-	if (pevent_get_field_val(s, event, "isa", record, &isa, 1) < 0)
+	if (pevent_get_field_val(s, event, "isa", record, &isa, 0) < 0)
 		isa = 1;
 
 	trace_seq_printf(s, "reason %s", find_exit_reason(isa, val));
 
 	pevent_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1);
 
-	if (pevent_get_field_val(s, event, "info1", record, &info1, 1) >= 0
-	    && pevent_get_field_val(s, event, "info2", record, &info2, 1) >= 0)
+	if (pevent_get_field_val(s, event, "info1", record, &info1, 0) >= 0
+	    && pevent_get_field_val(s, event, "info2", record, &info2, 0) >= 0)
 		trace_seq_printf(s, " info %llx %llx\n", info1, info2);
 
 	return 0;
-- 
1.7.1

