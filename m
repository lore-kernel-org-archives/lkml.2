Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761460Ab0HMK00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:26:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761431Ab0HMK0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:26:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Remove an extraneous no_printk()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: monstr@monstr.eu, vapier@gentoo.org, gerg@uclinux.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Fri, 13 Aug 2010 11:25:12 +0100
Message-ID: <20100813102511.25631.84088.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an extraneous no_printk() in mm/nommu.c that got missed when the
function got generalised from several things that used it in commit:

	commit 12fdff3fc2483f906ae6404a6e8dcf2550310b6f
	Author: David Howells <dhowells@redhat.com>
	Date:   Thu Aug 12 16:54:57 2010 +0100
	Subject: Add a dummy printk function for the maintenance of unused printks

Without this, the following error is observed:

mm/nommu.c:41: error: conflicting types for 'no_printk'
include/linux/kernel.h:314: error: previous definition of 'no_printk' was here

Reported-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/nommu.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)


diff --git a/mm/nommu.c b/mm/nommu.c
index a290e6f..96d7e55 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -36,11 +36,6 @@
 #include <asm/mmu_context.h>
 #include "internal.h"
 
-static inline __attribute__((format(printf, 1, 2)))
-void no_printk(const char *fmt, ...)
-{
-}
-
 #if 0
 #define kenter(FMT, ...) \
 	printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)

