Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab0JZBMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:12:20 -0400
Received: from bunsen.bytemark.co.uk ([80.68.81.6]:41030 "EHLO
	bunsen.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab0JZBMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:12:17 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 24/30] staging/vme_user: remove unnecessary call to vme_slave_set
Date: Mon, 25 Oct 2010 21:11:10 -0400
Message-Id: <1288055476-19438-25-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

The resource is about to be freed and therefore it is pointless to
set any of its parameters.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/devices/vme_user.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 95c22ff..a1cb85b 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -851,7 +851,6 @@ static int __devexit vme_user_remove(struct device *dev, int cur_bus, int cur_sl
 		kfree(image[i].kern_buf);
 
 	for (i = SLAVE_MINOR; i < (SLAVE_MAX + 1); i++) {
-		vme_slave_set(image[i].resource, 0, 0, 0, 0, VME_A32, 0);
 		buf_unalloc(i);
 		vme_slave_free(image[i].resource);
 	}
-- 
1.7.1

