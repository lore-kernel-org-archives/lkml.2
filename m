Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246Ab0JGJok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 05:44:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60450 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab0JGJoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 05:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=fBCqcdyrlIgHAuum2EDV0bF2wQwvURqU251b/YmLR6NJ2hlRdf/4Mlzygid9ayZB93
         TkSQ0EpUQn5KWZQwxOicse6l003tkQ0GjrziWPzZV2+SY0ZzHoTYuZbpaz29REgBCmIa
         t/Bi12pTHuuRh8k7hT3uSl0gx4uVD3LTPlszM=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Hemant Pedanekar <hemantp@ti.com>, Arnd Hannemann <arnd@arndnet.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Date: Thu,  7 Oct 2010 12:44:22 +0300
Message-Id: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.3.1.2.g7fe2b
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many drivers are broken, and there's no alternative in sight. Such a big
change should stay as a warning for now, and only later should it
actually fail.

The drivers are not doing something correct, we get it, but for now it's
better to allow them to work (they do 99% of the time anyway) rather
than to force everyone to revert this patch in their internal trees
until there's a solution. A slightly broken functionality is better than
no functionality at all.

A warning lets people know that what they are doing is not right, and
they should fix it.

Cc: Han Jonghun <jonghun79.han@gmail.com>
Cc: Hemant Pedanekar <hemantp@ti.com>
Cc: Arnd Hannemann <arnd@arndnet.de>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 arch/arm/mm/ioremap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

For issues related to this:
http://article.gmane.org/gmane.linux.ports.arm.kernel/84454
http://article.gmane.org/gmane.linux.ports.sh.devel/8560
http://www.spinics.net/lists/linux-fbdev/msg01745.html
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/22271

diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index ab50627..ccff7da 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -204,8 +204,7 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 	/*
 	 * Don't allow RAM to be mapped - this causes problems with ARMv6+
 	 */
-	if (WARN_ON(pfn_valid(pfn)))
-		return NULL;
+	WARN_ON(pfn_valid(pfn));
 
 	type = get_mem_type(mtype);
 	if (!type)
-- 
1.7.3.1.2.g7fe2b

