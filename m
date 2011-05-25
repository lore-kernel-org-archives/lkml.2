Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab1EYVpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:45:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:63512 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab1EYVpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:45:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,269,1304319600"; 
   d="scan'208";a="1752916"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, christophe.guerard@intel.com,
        james_p_freyensee@linux.intel.com, rocher.jeremy@gmail.com
Subject: [PATCH] ENXIO error case memory leak PTI fix.
Date: Wed, 25 May 2011 14:45:40 -0700
Message-Id: <1306359940-6896-1-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This patch fixes a memory leak that can occur in the error case
ENXIO is returned in the pti_tty_install() routine.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index be48573..e74e7d2 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -476,8 +476,10 @@ static int pti_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 		else
 			pti_tty_data->mc = pti_request_masterchannel(2);
 
-		if (pti_tty_data->mc == NULL)
+		if (pti_tty_data->mc == NULL) {
+			kfree(pti_tty_data);
 			return -ENXIO;
+		}
 		tty->driver_data = pti_tty_data;
 	}
 
-- 
1.7.2.3

