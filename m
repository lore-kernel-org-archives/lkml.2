Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760640Ab2DKQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:27:24 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:44122 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab2DKQ1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:27:23 -0400
Message-Id: <201204111627.q3BGRJ5m005114@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 11 Apr 2012 12:21:39 -0400
Subject: [PATCH] irq_work: fix compile failure on tile from missing include
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Paul Gortmaker <paul.gortmaker@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Huang Ying <ying.huang@intel.com>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 11 Apr 2012 16:27:22.0078 (UTC) FILETIME=[F8BBF7E0:01CD17FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building with IRQ_WORK configured results in

kernel/irq_work.c: In function ‘irq_work_run’:
kernel/irq_work.c:110: error: implicit declaration of function ‘irqs_disabled’

The appropriate header just needs to be included.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 kernel/irq_work.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 0c56d44..1588e3b 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -11,6 +11,7 @@
 #include <linux/irq_work.h>
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
+#include <linux/irqflags.h>
 #include <asm/processor.h>
 
 /*
-- 
1.6.5.2

