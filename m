Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2GYPjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:39:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab2GYPjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:39:15 -0400
Date: Wed, 25 Jul 2012 11:39:08 -0400
From: Dave Jones <davej@redhat.com>
To: rostedt@goodmis.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Remove unnecessary WARN_ONCE's from tracing_buffers_splice_read
Message-ID: <20120725153908.GA25203@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, rostedt@goodmis.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARN shouldn't be used as a means of communicating failure to a userspace programmer.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ed7b5d1..a745317 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4136,13 +4136,11 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		return -ENOMEM;
 
 	if (*ppos & (PAGE_SIZE - 1)) {
-		WARN_ONCE(1, "Ftrace: previous read must page-align\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (len & (PAGE_SIZE - 1)) {
-		WARN_ONCE(1, "Ftrace: splice_read should page-align\n");
 		if (len < PAGE_SIZE) {
 			ret = -EINVAL;
 			goto out;
