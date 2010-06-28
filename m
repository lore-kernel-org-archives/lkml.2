Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0F1G2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 02:28:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57961 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0F1G2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 02:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=QpypLlLMxAfEXgUVQjVc4nVr4TzaME8pzG1hqOBqJHum3IrczKMB1q+BWNmTl2wJAa
         35CrFezHrsRaVzYddXXttCmOOcQYHLuWyCxcdFp7SHWTA7tPk0miLdoSLRCWYAvrz796
         PS5u0OMaowIxcATw6PSQ6wuUbnUfLQWeJdkqU=
Subject: [PATCH] wistron_btns: fix a memory leak in wb_module_init error
	path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Miloslav Trmac <mitr@volny.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Rakib Mullick <rakib.mullick@gmail.com>, TJ <ubuntu@tjworld.net>,
       Julia Lawall <julia@diku.dk>, Samu Onkalo <samu.p.onkalo@nokia.com>,
       linux-input@vger.kernel.org
Content-Type: text/plain
Date: Mon, 28 Jun 2010 14:30:20 +0800
Message-Id: <1277706620.4148.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

select_keymap calls copy_keymap to allocate a memory for keymap.
This patch adds a missing kfree(keymap) in wb_module_init error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/misc/wistron_btns.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/misc/wistron_btns.c b/drivers/input/misc/wistron_btns.c
index 4dac8b7..55ce70e 100644
--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -1371,6 +1371,7 @@ static int __init wb_module_init(void)
 	platform_driver_unregister(&wistron_driver);
  err_unmap_bios:
 	unmap_bios();
+	kfree(keymap);
 
 	return err;
 }
-- 
1.5.4.3



