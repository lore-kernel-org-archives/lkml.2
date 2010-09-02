Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0IBKWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:22:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab0IBKWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:22:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] Drop a couple of unnecessary asm/include.h inclusions
To: gerg@snapgear.com
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 02 Sep 2010 11:21:53 +0100
Message-ID: <20100902102153.19806.82031.stgit@warthog.procyon.org.uk>
In-Reply-To: <19747.1283422807@redhat.com>
References: <19747.1283422807@redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop inclusions of asm/include.h from linux/hardirq.h and linux/list.h as
they're no longer required and prevent the M68K arch's IRQ flag handling macros
from being made into inlined functions due to circular dependencies.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/hardirq.h |    1 -
 include/linux/list.h    |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index d5b3876..7dfdc06 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -8,7 +8,6 @@
 #include <linux/lockdep.h>
 #include <linux/ftrace_irq.h>
 #include <asm/hardirq.h>
-#include <asm/system.h>
 
 /*
  * We put the hardirq and softirq counter into the preemption
diff --git a/include/linux/list.h b/include/linux/list.h
index d167b5d..88a0006 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -5,7 +5,6 @@
 #include <linux/stddef.h>
 #include <linux/poison.h>
 #include <linux/prefetch.h>
-#include <asm/system.h>
 
 /*
  * Simple doubly linked list implementation.

