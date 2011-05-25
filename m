Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab1EYV4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:56:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:58395 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab1EYV4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:56:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,269,1304319600"; 
   d="scan'208";a="8798088"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, christophe.guerard@intel.com,
        james_p_freyensee@linux.intel.com, rocher.jeremy@gmail.com
Subject: [PATCH] PTI semantics fix in pti_tty_cleanup.
Date: Wed, 25 May 2011 14:56:43 -0700
Message-Id: <1306360603-7027-1-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This patch fixes a semantics issue in the pti_tty_cleanup()
routine.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 62b7ba4..e5f295a 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -498,7 +498,7 @@ static void pti_tty_cleanup(struct tty_struct *tty)
 	if (pti_tty_data == NULL)
 		return;
 	pti_release_masterchannel(pti_tty_data->mc);
-	kfree(tty->driver_data);
+	kfree(pti_tty_data);
 	tty->driver_data = NULL;
 }
 
-- 
1.7.2.3

