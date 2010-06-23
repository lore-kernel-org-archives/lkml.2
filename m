Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0FWPWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:22:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:48592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab0FWPWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:22:05 -0400
Date: Wed, 23 Jun 2010 15:21:40 GMT
From: tip-bot for Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       wuzhangjin@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       wuzhangjin@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1277118549-622-1-git-send-email-wuzhangjin@gmail.com>
References: <1277118549-622-1-git-send-email-wuzhangjin@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Fix undeclared ENOSYS in include/linux/tracepoint.h
Message-ID: <tip-b70e4f0529c089b00d0a6da13106db4de1ada4c7@git.kernel.org>
Git-Commit-ID: b70e4f0529c089b00d0a6da13106db4de1ada4c7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Jun 2010 15:21:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b70e4f0529c089b00d0a6da13106db4de1ada4c7
Gitweb:     http://git.kernel.org/tip/b70e4f0529c089b00d0a6da13106db4de1ada4c7
Author:     Wu Zhangjin <wuzhangjin@gmail.com>
AuthorDate: Mon, 21 Jun 2010 19:09:09 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 21 Jun 2010 12:23:36 -0400

tracing: Fix undeclared ENOSYS in include/linux/tracepoint.h

The header file include/linux/tracepoint.h may be included without
include/linux/errno.h and then the compiler will fail on building for
undelcared ENOSYS. This patch fixes this problem via including <linux/errno.h>
to include/linux/tracepoint.h.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
LKML-Reference: <1277118549-622-1-git-send-email-wuzhangjin@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 9a59d1f..103d1b6 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -14,6 +14,7 @@
  * See the file COPYING for more details.
  */
 
+#include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/rcupdate.h>
 
