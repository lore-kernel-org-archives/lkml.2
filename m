Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab0J3UYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 16:24:45 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:45778 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab0J3UYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 16:24:44 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Oct 2010 16:24:43 EDT
Subject: [PATCH] drivers/media/IR/ir-keytable.c: fix binary search
To: torvalds@linux-foundation.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, dmitry.torokhov@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, mchehab@infradead.org
Date: Sat, 30 Oct 2010 22:17:44 +0200
Message-ID: <20101030201744.2964.20624.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The input-large-scancode patches changed the binary search in
drivers/media/IR/ir-keytable.c to use unsigned integers, but
signed integers are actually necessary for the algorithm to work.

Signed-off-by: David Härdeman <david@hardeman.nu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/media/IR/ir-keytable.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 9186b45..647d52b 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -325,9 +325,9 @@ static int ir_setkeytable(struct ir_input_dev *ir_dev,
 static unsigned int ir_lookup_by_scancode(const struct ir_scancode_table *rc_tab,
 					  unsigned int scancode)
 {
-	unsigned int start = 0;
-	unsigned int end = rc_tab->len - 1;
-	unsigned int mid;
+	int start = 0;
+	int end = rc_tab->len - 1;
+	int mid;
 
 	while (start <= end) {
 		mid = (start + end) / 2;

