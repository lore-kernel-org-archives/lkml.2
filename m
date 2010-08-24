Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0HXEYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:24:47 -0400
Received: from kroah.org ([198.145.64.141]:56442 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab0HXEYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:24:44 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>, Pekka Enberg <penberg@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/3] firmware_class: fix typo in error path
Date: Mon, 23 Aug 2010 21:24:38 -0700
Message-Id: <1282623879-17092-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100824040503.GB16749@kroah.com>
References: <20100824040503.GB16749@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In the error path, _request_firmware sets
firmware_p to NULL rather than *firmware_p,
which leads to passing a freed firmware
struct to drivers when the firmware file
cannot be found. Fix this.

Broken by commit f8a4bd3456b988fc73b2c.

Reported-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c8a44f5..40af43e 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -568,7 +568,7 @@ static int _request_firmware(const struct firmware **firmware_p,
 out:
 	if (retval) {
 		release_firmware(firmware);
-		firmware_p = NULL;
+		*firmware_p = NULL;
 	}
 
 	return retval;
-- 
1.7.2

