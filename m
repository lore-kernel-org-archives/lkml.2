Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935019Ab2C3Wxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:53:35 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934962Ab2C3VGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:03 -0400
Message-Id: <201203302105.q2UL57XA006301@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:59:11 -0400
Subject: [PATCH] arch/tile: implement panic_smp_self_stop()
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:07.0491 (UTC) FILETIME=[C9232F30:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the later-panicking tiles to wait in a lower power state
until they get interrupted with an smp_send_stop().

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/smp.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index f86887a..5b46a12 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -132,6 +132,12 @@ void smp_send_stop(void)
 	send_IPI_allbutself(MSG_TAG_STOP_CPU);
 }
 
+/* On panic, just wait; we may get an smp_send_stop() later on. */
+void panic_smp_self_stop(void)
+{
+	while (1)
+		asm("nap; nop");
+}
 
 /*
  * Dispatch code called from hv_message_intr() for HV_MSG_TILE hv messages.
-- 
1.6.5.2

