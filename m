Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911Ab0KVFIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 00:08:44 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45528 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0KVFIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 00:08:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=hpOKP4kAEApkFu+Tt6tiJ2pX+PovG03CIKbHNe9fz8Dj4QKafXgdZSxFB3ICtnD8Tu
         zvUrYXnLkkyStdFnhJrZgFV5jU1oLdW6s4X6cjwl+hrmQ2JorgU5LbXCcO2yaaSz3RVF
         XEODq2K9Z9doae42oGIP9NP0XXYGroft0j/Ow=
Subject: [PATCH] Input: ps2mult - fix wrong kfree in ps2mult_connect error
	path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org
Content-Type: text/plain
Date: Mon, 22 Nov 2010 13:13:39 +0800
Message-Id: <1290402820.6941.8.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/serio/ps2mult.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/ps2mult.c b/drivers/input/serio/ps2mult.c
index 6bce22e..15aa81c 100644
--- a/drivers/input/serio/ps2mult.c
+++ b/drivers/input/serio/ps2mult.c
@@ -207,7 +207,7 @@ static int ps2mult_connect(struct serio *serio, struct serio_driver *drv)
 err_out:
 	while (--i >= 0)
 		kfree(psm->ports[i].serio);
-	kfree(serio);
+	kfree(psm);
 	return error;
 }
 
-- 
1.7.2



