Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1FKLaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 07:30:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab1FKLaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 07:30:12 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] linux/seqlock.h should #include asm/processor.h for
 cpu_relax()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Sat, 11 Jun 2011 12:29:58 +0100
Message-ID: <20110611112958.7856.64462.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/seqlock.h should #include asm/processor.h as it uses cpu_relax().

Without this patch, I see:

 CC      arch/mn10300/kernel/asm-offsets.s
In file included from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:57,
                 from arch/mn10300/kernel/asm-offsets.c:7:
include/linux/seqlock.h: In function 'read_seqbegin':
include/linux/seqlock.h:91: error: implicit declaration of function 'cpu_relax'

whilst building asb2364_defconfig on MN10300.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/seqlock.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index e981189..c6db9fb 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -28,6 +28,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/preempt.h>
+#include <asm/processor.h>
 
 typedef struct {
 	unsigned sequence;

