Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871Ab0JVTSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:18:31 -0400
Received: from kroah.org ([198.145.64.141]:34032 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759250Ab0JVS4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:12 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:30 2010
Message-Id: <20101022185229.934681067@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [029/103] tracing/x86: Dont use mcount in pvclock.c
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremy Fitzhardinge <jeremy@goop.org>

commit 9ecd4e1689208afe9b059a5ce1333acb2f42c4d2 upstream.

When using a paravirt clock, pvclock.c can be used by sched_clock(),
which in turn is used by the tracing mechanism for timestamps,
which leads to infinite recursion.

Disable mcount/tracing for pvclock.o.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
LKML-Reference: <4C9A9A3F.4040201@goop.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -11,6 +11,7 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
+CFLAGS_REMOVE_pvclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif


