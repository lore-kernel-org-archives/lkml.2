Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab1CWLfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:35:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab1CWLfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:35:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix linux/smp.h to include linux/init.h
To: torvalds@osdl.org, akpm@linux-foundation.org, amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 23 Mar 2011 11:35:02 +0000
Message-ID: <20110323113502.30322.26599.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/smp.h now needs to include linux/init.h lest it give the following error:

  CC      arch/mn10300/kernel/asm-offsets.s
In file included from /data/mn10300/linux-2.6-mn10300/arch/mn10300/include/asm/irqflags.h:17,
                 from include/linux/irqflags.h:15,
                 from include/linux/spinlock.h:53,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:57,
                 from arch/mn10300/kernel/asm-offsets.c:7:
include/linux/smp.h:117: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'setup_nr_cpu_ids'
include/linux/smp.h:118: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'smp_init'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/smp.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/include/linux/smp.h b/include/linux/smp.h
index 48159dd..74fba34 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -8,6 +8,7 @@
 
 #include <linux/errno.h>
 #include <linux/types.h>
+#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/cpumask.h>
 

