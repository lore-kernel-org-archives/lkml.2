Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab0IZJiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:38:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab0IZJiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:38:46 -0400
From: Avi Kivity <avi@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: [PATCH trace-cmd] plugin_kvm: remove stray line from kvm_emulate_insn_handler()
Date: Sun, 26 Sep 2010 11:38:42 +0200
Message-Id: <1285493922-29797-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'guest_rip' is not part of kvm_emulate_insn.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 plugin_kvm.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/plugin_kvm.c b/plugin_kvm.c
index 00cac5a..cdd52c7 100644
--- a/plugin_kvm.c
+++ b/plugin_kvm.c
@@ -199,8 +199,6 @@ static int kvm_emulate_insn_handler(struct trace_seq *s, struct record *record,
 	trace_seq_printf(s, "%llx:%llx: %s%s", csbase, rip, disasm,
 			 failed ? " FAIL" : "");
 
-	pevent_print_num_field(s, " rip %0xlx", event, "guest_rip", record, 1);
-
 	return 0;
 }
 
-- 
1.7.2.3

