Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1AFAiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:38:01 -0500
Received: from kroah.org ([198.145.64.141]:36047 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab1AFAba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:30 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:08 2011
Message-Id: <20110106002308.620396093@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [126/152] mfd: Support additional parent IDs for wm831x
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit b93cef556162b0f33399bfe5f307c54f51554e09 upstream.

Some newer device revisions add a second parent ID. Support this in
the device validity checks done at startup.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/wm831x-core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1464,7 +1464,11 @@ static int wm831x_device_init(struct wm8
 		dev_err(wm831x->dev, "Failed to read parent ID: %d\n", ret);
 		goto err;
 	}
-	if (ret != 0x6204) {
+	switch (ret) {
+	case 0x6204:
+	case 0x6246:
+		break;
+	default:
 		dev_err(wm831x->dev, "Device is not a WM831x: ID %x\n", ret);
 		ret = -EINVAL;
 		goto err;


