Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab1FFOrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:47:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab1FFOrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:47:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] MN10300: Add missing _sdata declaration
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 06 Jun 2011 15:47:23 +0100
Message-ID: <20110606144723.19155.28502.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110606144705.19155.22278.stgit@warthog.procyon.org.uk>
References: <20110606144705.19155.22278.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_sdata needs to be declared in the linker script now as of:

	commit a2d063ac216c1618bfc2b4d40b7176adffa63511
	Author: Steven Rostedt <rostedt@goodmis.org>
	Date:   Thu May 19 21:34:58 2011 -0400
	extable, core_kernel_data(): Make sure all archs define _sdata

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steven Rostedt <rostedt@goodmis.org>
---

 arch/mn10300/kernel/vmlinux.lds.S |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index 6f702a6..13c4814 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -44,6 +44,7 @@ SECTIONS
   RO_DATA(PAGE_SIZE)
 
   /* writeable */
+  _sdata = .;     /* Start of rw data section */
   RW_DATA_SECTION(32, PAGE_SIZE, THREAD_SIZE)
   _edata = .;
 

