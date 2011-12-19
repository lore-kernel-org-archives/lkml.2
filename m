Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1LSMU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 07:20:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53415 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1LSMUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 07:20:25 -0500
Message-ID: <1324297212.13638.2.camel@phoenix>
Subject: [PATCH RESEND] mfd: Add missed free_irq in da903x_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Eric Miao <eric.y.miao@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Mon, 19 Dec 2011 20:20:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
---
Hi Samuel,
It seems this patch is not merged.
It was posted on https://lkml.org/lkml/2011/10/30/136.
It is strange that you replied this one is applied, but the patch
is not (yet) in linux-next now.

Regards,
Axel
 drivers/mfd/da903x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index 1b79c37..62ce685 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -549,6 +549,7 @@ static int __devexit da903x_remove(struct i2c_client *client)
 	struct da903x_chip *chip = i2c_get_clientdata(client);
 
 	da903x_remove_subdevs(chip);
+	free_irq(client->irq, chip);
 	kfree(chip);
 	return 0;
 }
-- 
1.7.5.4



