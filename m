Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab0JKI6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 04:58:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab0JKI6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 04:58:39 -0400
From: Avi Kivity <avi@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: [PATCH] plugin_kvm: fix kvm_exit rip formatting
Date: Mon, 11 Oct 2010 10:58:35 +0200
Message-Id: <1286787515-13722-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

%0xlx is not a valid printf format.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 plugin_kvm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/plugin_kvm.c b/plugin_kvm.c
index cdd52c7..724143d 100644
--- a/plugin_kvm.c
+++ b/plugin_kvm.c
@@ -153,7 +153,7 @@ static int kvm_exit_handler(struct trace_seq *s, struct record *record,
 
 	trace_seq_printf(s, "reason %s", find_vmx_reason(val));
 
-	pevent_print_num_field(s, " rip %0xlx", event, "guest_rip", record, 1);
+	pevent_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1);
 
 	return 0;
 }
-- 
1.7.3.1

