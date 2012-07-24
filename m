Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2GXRA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:00:56 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58760 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab2GXRAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:00:54 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH 03/13] driver core: firmware loader: remove unnecessary wmb()
Date: Wed, 25 Jul 2012 01:00:03 +0800
Message-Id: <1343149213-10160-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wmb() inside fw_load_abort is not necessary, since
complete() and wait_on_completion() has implied one pair
of memory barrier.

Also wmb() isn't a correct usage, so just remove it.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 6e96b8c..16239fd 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -112,7 +112,6 @@ static struct firmware_priv *to_firmware_priv(struct device *dev)
 static void fw_load_abort(struct firmware_priv *fw_priv)
 {
 	set_bit(FW_STATUS_ABORT, &fw_priv->status);
-	wmb();
 	complete(&fw_priv->completion);
 }
 
-- 
1.7.9.5

