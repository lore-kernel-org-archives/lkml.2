Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab0G0WrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:47:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51960 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab0G0WrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BLQF1X6GGgmD5VqkrvpcBNOQ6GrRtSunZZ6IOMNbcdscvbqE8RoX2jVlnyE1PzB7iX
         RjOX5iliihx6Jn1EgKbPKYM39hCD/lCfBpD5oDWiRVUxd3Sqyfjn8PdB6PSX2b+beeAf
         B0Z5ob+N36L2yYla6ZpP3O08ok8ld2miokYTc=
Date: Wed, 28 Jul 2010 00:44:08 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] tracing: wake up tasks reading trace_pipe on write to
 trace_marker
Message-ID: <20100727224408.GB4142@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we rely on other code periodically waking up trace reader.
If there aren't any other data than markers, reader will never be woken up.
Fix it.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 086d363..02e04c8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1520,6 +1520,7 @@ int trace_array_vprintk(struct trace_array *tr,
 	if (!filter_check_discard(call, entry, buffer, event)) {
 		ring_buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, irq_flags, 6, pc);
+		trace_wake_up();
 	}
 
  out_unlock:
-- 
1.7.1.1

