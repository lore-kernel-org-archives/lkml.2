Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab0EJXGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:06:19 -0400
Received: from ozlabs.org ([203.10.76.45]:36622 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933032Ab0EJXAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:00:15 -0400
Date: Tue, 11 May 2010 08:59:59 +1000
From: Anton Blanchard <anton@samba.org>
To: akpm@linux-foundation.org, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] panic: Call console_verbose in panic
Message-ID: <20100510225959.GC12203@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Most distros turn the console verbosity down and that means a backtrace after
a panic never makes it to the console. I assume we haven't seen this because
a panic is often preceeded by an oops which will have called console_verbose.
There are however a lot of places we call panic directly, and they are
broken.

Use console_verbose like we do in the oops path to ensure a directly called
panic will print a backtrace.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6/kernel/panic.c
===================================================================
--- linux-2.6.orig/kernel/panic.c	2010-05-09 09:13:06.000000000 +1000
+++ linux-2.6/kernel/panic.c	2010-05-09 09:14:13.000000000 +1000
@@ -87,6 +87,7 @@ NORET_TYPE void panic(const char * fmt, 
 	 */
 	preempt_disable();
 
+	console_verbose();
 	bust_spinlocks(1);
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
