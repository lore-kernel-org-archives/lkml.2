Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0EKPlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:41:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35258 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab0EKPlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:from:subject:to:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=kQsrmwEwgcNf/jZlLfV4XJjW/iIt327Luq/2/wmzyTH2ROBhJRf9OSAVtIbH3xTcgp
         iW5oceR57iZUeR9L1ZZi4QBHchxgCA9ETRMTN/owEiRQXAYQ4AgUf6ldVtBpRmEBNpaM
         7TqDalUA/s2QdBjq95SgBjtWBiOaIJFvCB2qw=
From: Maxim Uvarov <muvarov@gmail.com>
Subject: [PATCH] [POWEPC] crashdump: do not fail on null pointer dereferencing
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       uvarov@dev.rtsoft.ru
Date: Tue, 11 May 2010 19:41:08 +0400
Message-ID: <20100511154108.11546.12066.stgit@muvarov>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Best regards,
Maxim Uvarov.

From: Maxim Uvarov <muvarov@gmail.com>

Signed-off-by: Maxim Uvarov <muvarov@gmail.com>
---

 arch/powerpc/kernel/crash.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 6f4613d..341d8af 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -375,6 +375,9 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 	for_each_irq(i) {
 		struct irq_desc *desc = irq_to_desc(i);
 
+		if (!desc || !desc->chip || !desc->chip->eoi)
+			continue;
+
 		if (desc->status & IRQ_INPROGRESS)
 			desc->chip->eoi(i);
 



