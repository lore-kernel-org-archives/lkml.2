Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0FDInM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:43:12 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:45178 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab0FDInK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:43:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=U4dy7GkC30sz/jLzy1nF49cCK5GzF6zulmxwZD0KklBDv0jRmtBvTeOcoabLHPSK7N
         THzUQIk/JpFu7H/FrB1CUo3zdz+EopqUDPCQ3WbkVe/JbcRwK1Vj3IMy2H3zUhDFZDQV
         lOGIqVopeJFqkdIrMVwr0DhbDijLOUzLZCvx0=
Message-ID: <4C08BC8C.4010206@gmail.com>
Date: Fri, 04 Jun 2010 16:42:52 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       rtc-linux <rtc-linux@googlegroups.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtc/m48t59: redundant condition judgement
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is safe to deallocate a NULL pointer.
so 'if (m48t59)' is redundant condition judgement,
so I remove it.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 drivers/rtc/rtc-m48t59.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index be8359f..0b66455 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -506,7 +506,6 @@ out:
 		free_irq(m48t59->irq, &pdev->dev);
 	if (m48t59->ioaddr)
 		iounmap(m48t59->ioaddr);
-	if (m48t59)
 		kfree(m48t59);
 	return ret;
 }
-- 
1.6.3.3
