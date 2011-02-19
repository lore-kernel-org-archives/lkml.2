Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1BSUFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 15:05:51 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63417 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1BSUFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 15:05:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=AVswIgWdu+7uDg50VGmmqycjysD7dOWPAN9diEoOzyleWGNDijc5YnpcRq9md9OMcH
         CmK3kAZewpTCMa5kVF/EoOhdwgz9EdK3W3+QZs1VOGgYM9jfd+0lx8U+9lyux2PIQHaU
         0EWdjy5s7qEpLdqjUGSJBJESZtCZpuq8PncJA=
From: Dustan Bower <dustan.bower@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dustan Bower <dustan.bower@gmail.com>
Subject: [PATCH] Input: serio: Compile error fix (altera_ps2.c)
Date: Sat, 19 Feb 2011 15:04:19 -0500
Message-Id: <1298145859-10892-1-git-send-email-dustan.bower@gmail.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed compile error, today's linux-next tree:

  CC [M]  drivers/input/serio/altera_ps2.o
drivers/input/serio/altera_ps2.c:182:1: error: expected ‘,’ or ‘;’ before ‘extern’
make[1]: *** [drivers/input/serio/altera_ps2.o] Error 1
make: *** [_module_drivers/input/serio] Error 2

Signed-off-by: Dustan Bower <dustan.bower@gmail.com>
---
 drivers/input/serio/altera_ps2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
index 3fee88b..d363dc4 100644
--- a/drivers/input/serio/altera_ps2.c
+++ b/drivers/input/serio/altera_ps2.c
@@ -178,7 +178,7 @@ static int __devexit altera_ps2_remove(struct platform_device *pdev)
 static const struct of_device_id altera_ps2_match[] = {
 	{ .compatible = "ALTR,ps2-1.0", },
 	{},
-}
+};
 MODULE_DEVICE_TABLE(of, altera_ps2_match);
 #else /* CONFIG_OF */
 #define altera_ps2_match NULL
-- 
1.7.4.1

