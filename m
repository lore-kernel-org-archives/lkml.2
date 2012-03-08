Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2CHJ2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 04:28:45 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:9425 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab2CHJ2m convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 8 Mar 2012 04:28:42 -0500
Message-Id: <4F588A0802000078000770FF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 08 Mar 2012 09:29:28 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <acme@ghostprotocols.net>,
        <paulus@samba.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: adjust make rules
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rules to generate pre-processed files (just like are available for
the normal kernel build), and adjust the rule to create assembly files
from C ones to produce its output in the output directory rather than
in the source tree.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 tools/perf/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- 3.3-rc6/tools/perf/Makefile
+++ 3.3-rc6-perf-make-rules/tools/perf/Makefile
@@ -706,10 +706,14 @@ $(OUTPUT)perf.o perf.spec \
 
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.i: %.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
 $(OUTPUT)%.s: %.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
+	$(QUIET_CC)$(CC) -o $@ -S $(ALL_CFLAGS) $<
 $(OUTPUT)%.o: %.S
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.s: %.S
+	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
 
 $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \



