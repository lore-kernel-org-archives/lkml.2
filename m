Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab1JPJhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 05:37:41 -0400
Received: from re04.intra2net.com ([82.165.46.26]:43466 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1JPJhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 05:37:40 -0400
Message-ID: <4E9AA5E1.90001@intra2net.com>
Date: Sun, 16 Oct 2011 11:37:37 +0200
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: [trace PATCH] Fix unterminated buffer if the length of str exceeds
 MAX_TRACER_SIZE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strncpy() doesn't always zero terminate the string.

Detected by "cppcheck"

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 kernel/trace/trace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e5df02c..9637b1e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -126,7 +126,8 @@ static char *default_bootup_tracer;
 
 static int __init set_cmdline_ftrace(char *str)
 {
-	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
+	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE-1);
+	bootup_tracer_buf[MAX_TRACER_SIZE-1] = '\0';
 	default_bootup_tracer = bootup_tracer_buf;
 	/* We are using ftrace early, expand it */
 	ring_buffer_expanded = 1;
-- 
1.7.6.4

