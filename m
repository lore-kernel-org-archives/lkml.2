Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1AUJnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:43:14 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47741 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab1AUJnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:43:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=nwq8tdd3lKWQQdSIc/6BD6M4uUtO1rGuPsGxmOPhmfy9H3r0tXgtHh8QEzHREOF+OC
         MPykXjSqxRLQAl/6qt1BwOl4Ek/dTdlkvwIEDnsdByOVSo+ioypA+LN3rFmCgRXUEEPA
         aepLGqrIs/jpKk+i1C+1WAP93Vz46+mywT01c=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Chas Williams <chas@cmf.nrl.navy.mil>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] atm: idt77105: fix fetch_stats() result
Date: Fri, 21 Jan 2011 12:43:07 +0300
Message-Id: <1295602987-11688-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() used PRIV(dev)->stats instead of local stats variable.
Zero stats were returned to user in case of (zero != 0), also memcpy()
was pointless.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 drivers/atm/idt77105.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/idt77105.c b/drivers/atm/idt77105.c
index bca9cb8..487a547 100644
--- a/drivers/atm/idt77105.c
+++ b/drivers/atm/idt77105.c
@@ -151,7 +151,7 @@ static int fetch_stats(struct atm_dev *dev,struct idt77105_stats __user *arg,int
 	spin_unlock_irqrestore(&idt77105_priv_lock, flags);
 	if (arg == NULL)
 		return 0;
-	return copy_to_user(arg, &PRIV(dev)->stats,
+	return copy_to_user(arg, &stats,
 		    sizeof(struct idt77105_stats)) ? -EFAULT : 0;
 }
 
-- 
1.7.0.4

