Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558Ab1ERShN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:37:13 -0400
Received: from [138.40.68.24] ([138.40.68.24]:52694 "EHLO optosun2.city.ac.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933460Ab1ERShK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:37:10 -0400
X-Greylist: delayed 1039 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 May 2011 14:37:10 EDT
From: "J. Ali Harlow" <ali@optosun7.city.ac.uk>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: devel@linuxdriverproject.org, Manuel Gebele <forensixs@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] comedi vmk80xx: extend rudimentary_check to check both directions
Date: Wed, 18 May 2011 19:18:54 +0100
Message-Id: <1305742736-19434-4-git-send-email-ali@avrc.city.ac.uk>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rudimentary_check() can currently check whether the input or
output direction is currently available (no pending transaction),
but not both at the same time. We need this facility for do_bits().

Signed-off-by: J. Ali Harlow <ali@avrc.city.ac.uk>
---
 drivers/staging/comedi/drivers/vmk80xx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index c86c866..669ebf85 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -568,7 +568,8 @@ static int rudimentary_check(struct vmk80xx_usb *dev, int dir)
 	if (dir & DIR_IN) {
 		if (test_bit(TRANS_IN_BUSY, &dev->flags))
 			return -EBUSY;
-	} else {  /* DIR_OUT */
+	}
+	if (dir & DIR_OUT) {
 		if (test_bit(TRANS_OUT_BUSY, &dev->flags))
 			return -EBUSY;
 	}
-- 
1.7.4.1

