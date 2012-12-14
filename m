Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab2LNWvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:51:31 -0500
Received: from smtp.outflux.net ([198.145.64.163]:35453 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396Ab2LNWva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:51:30 -0500
Date: Fri, 14 Dec 2012 14:51:25 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] firmware: make sure paths remain relative
Message-ID: <20121214225125.GA30826@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices have configurable firmware locations. If these configuration
mechanisms are exposed to unprivileged userspace, it may be possible to
load firmware from an unexpected location. To minimize the risk of this,
make sure the string "../" does not appear in the firmware name. This
means that neither the users of request_firmware, nor the uevent handler
have to do this filtering themselves.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/base/firmware_class.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d814603..9c4fb1c 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -814,6 +814,9 @@ _request_firmware_prepare(const struct firmware **firmware_p, const char *name,
 	if (!firmware_p)
 		return ERR_PTR(-EINVAL);
 
+	if (strstr(name, "../"))
+		return ERR_PTR(-EINVAL);
+
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
