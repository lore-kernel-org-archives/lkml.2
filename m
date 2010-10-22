Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0JVGoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 02:44:11 -0400
Received: from beaker.bytemark.co.uk ([80.68.81.2]:44448 "EHLO
	beaker.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0JVGoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 02:44:09 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Oct 2010 02:44:09 EDT
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 24/30] staging/vme_user: remove unnecessary call to vme_slave_set
Date: Fri, 22 Oct 2010 02:36:46 -0400
Message-Id: <1287729412-24356-25-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
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

