Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2HDECN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 00:02:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45263 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab2HDECD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 00:02:03 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 03/15] firmware loader: remove unnecessary wmb()
Date: Sat,  4 Aug 2012 12:01:18 +0800
Message-Id: <1344052890-31935-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
References: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
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
index 1915ad8..0bd09c7 100644
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

