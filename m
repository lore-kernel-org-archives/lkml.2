Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab1DYUip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:38:45 -0400
Received: from 1wt.eu ([62.212.114.60]:34376 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab1DYUZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:05 -0400
Message-Id: <20110425200236.340847952@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Maxim Uvarov <muvarov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamalesh babulal <kamalesh@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 077/173] powerpc/crashdump: Do not fail on NULL pointer dereferencing
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maxim Uvarov <muvarov@gmail.com>

commit 426b6cb478e60352a463a0d1ec75c1c9fab30b13 upstream.

Signed-off-by: Maxim Uvarov <muvarov@gmail.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamalesh babulal <kamalesh@linux.vnet.ibm.com>
cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/crash.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -377,6 +377,9 @@ void default_machine_crash_shutdown(stru
 	for_each_irq(i) {
 		struct irq_desc *desc = irq_desc + i;
 
+		if (!desc || !desc->chip || !desc->chip->eoi)
+			continue;
+
 		if (desc->status & IRQ_INPROGRESS)
 			desc->chip->eoi(i);
 


