Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab1LGQ15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:27:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757151Ab1LGQZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:25:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:22 2011
Message-Id: <20111207161222.498232397@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:36 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Steven Rostedt <rostedt@goodmis.org>
Subject: [094/104] ftrace: Remove force undef config value left for testing
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit c7c6ec8becaf742b223c7b491f4893014be23a07 upstream.

A forced undef of a config value was used for testing and was
accidently left in during the final commit. This causes x86 to
run slower than needed while running function tracing as well
as causes the function graph selftest to fail when DYNMAIC_FTRACE
is not set. This is because the code in MCOUNT expects the ftrace
code to be processed with the config value set that happened to
be forced not set.

The forced config option was left in by:
    commit 6331c28c962561aee59e5a493b7556a4bb585957
    ftrace: Fix dynamic selftest failure on some archs

Link: http://lkml.kernel.org/r/20111102150255.GA6973@debian

Reported-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/ftrace.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -151,7 +151,6 @@ void clear_ftrace_function(void)
 	ftrace_pid_function = ftrace_stub;
 }
 
-#undef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 #ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 /*
  * For those archs that do not test ftrace_trace_stop in their


