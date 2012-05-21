Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2EUPqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:46:12 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:38207 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2EUPqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:46:09 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 2/2] sched: enable FAIR_SLEEPERS for s390
Date: Mon, 21 May 2012 17:45:37 +0200
Message-Id: <1337615137-55111-3-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com>
References: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com>
x-cbid: 12052115-0342-0000-0000-000001C2497E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For s390 the performance benefit that comes with the ability to disable
fair sleepers is more important than the saved branch on the hot path
of the scheduler. Therefore enable CONFIG_SCHED_FAIR_SLEEPERS.

Reported-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 9015060..d5746d8 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -122,6 +122,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select SCHED_FAIR_SLEEPERS
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
-- 
1.7.10.2

