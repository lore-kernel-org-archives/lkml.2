Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2JAPuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:50:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50815 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2JAPuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:50:00 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] max17042: missing assignment
To: ramakrishna.pallala@intel.com, linux-kernel@vger.kernel.org
Date: Mon, 01 Oct 2012 17:09:58 +0100
Message-ID: <20121001160954.7827.1084.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The second error check is unreachable because the lock function
isn't assigned to ret

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/power/max17042_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 74abc6c..73b432d 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -572,7 +572,7 @@ static int max17042_init_chip(struct max17042_chip *chip)
 			__func__);
 		return -EIO;
 	}
-	max17042_verify_model_lock(chip);
+	ret = max17042_verify_model_lock(chip);
 	if (ret) {
 		dev_err(&chip->client->dev, "%s lock verify failed\n",
 			__func__);

