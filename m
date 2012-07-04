Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab2GDOkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:40:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49885 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab2GDOkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:40:16 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] lm8333: Fix check ordering
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com
Date: Wed, 04 Jul 2012 15:57:00 +0100
Message-ID: <20120704145653.7910.26502.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Fix harmless reference off end of array

Reported-by: <dcb314@hotmail.com>
Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?43861
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/input/keyboard/lm8333.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/lm8333.c b/drivers/input/keyboard/lm8333.c
index ca168a6..081fd9e 100644
--- a/drivers/input/keyboard/lm8333.c
+++ b/drivers/input/keyboard/lm8333.c
@@ -91,7 +91,7 @@ static void lm8333_key_handler(struct lm8333 *lm8333)
 		return;
 	}
 
-	for (i = 0; keys[i] && i < LM8333_FIFO_TRANSFER_SIZE; i++) {
+	for (i = 0; i < LM8333_FIFO_TRANSFER_SIZE && keys[i]; i++) {
 		pressed = keys[i] & 0x80;
 		code = keys[i] & 0x7f;
 

