Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633Ab2JYOP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:15:28 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53742 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759717Ab2JYOPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:15:21 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH RESEND] max17042: missing assignment
To: ramakrishna.pallala@intel.com, linux-kernel@vger.kernel.org
Date: Thu, 25 Oct 2012 15:16:55 +0100
Message-ID: <20121025141638.16300.43943.stgit@localhost.localdomain>
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

