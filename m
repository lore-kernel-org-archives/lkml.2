Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0GFP2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 11:28:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39819 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab0GFP2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 11:28:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=YRRzgwH/2m04BfrPojXaxBIms5ZKFZ0JYP6zehqbKYaXXh3AC9ppLOCOHzAhtJP4rz
         aXastUPqK43fK9FGfbqRJtWRHo0HQxMR1MKqiEwhFJwVOjwEwHgTUN+4+lX3uhOwKJ9+
         ZID3pnVFelaChADd72wf676hP4IP94IotWaz0=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] enclosure: fix lost return
Date: Tue,  6 Jul 2010 19:28:07 +0400
Message-Id: <1278430088-9761-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useless statement must be return with argument.

This patch silences a compiler warning:
drivers/misc/enclosure.c: In function ‘enclosure_component_register’:
drivers/misc/enclosure.c:289: warning: ignoring return value of ‘ERR_PTR’, declared with attribute warn_unused_result

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/misc/enclosure.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 48c84a5..9ae7bef 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -286,7 +286,7 @@ enclosure_component_register(struct enclosure_device *edev,
 
 	err = device_register(cdev);
 	if (err)
-		ERR_PTR(err);
+		return ERR_PTR(err);
 
 	return ecomp;
 }
-- 
1.7.0.4

