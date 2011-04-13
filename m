Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab1DMJ55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 05:57:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48632 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751964Ab1DMJ54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:57:56 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 3/5] gma500: backlight warning
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 13 Apr 2011 10:36:19 +0100
Message-ID: <20110413093555.28527.30662.stgit@localhost.localdomain>
In-Reply-To: <20110413093519.28527.36552.stgit@localhost.localdomain>
References: <20110413093519.28527.36552.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current bl code checks for backlight types and warns if they are not
properly set. Set ours to avoid the warning spew

(This one alone is probably 2.6.39 candidate)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_bl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/gma500/psb_bl.c b/drivers/staging/gma500/psb_bl.c
index 57b9a5e..5dffc71 100644
--- a/drivers/staging/gma500/psb_bl.c
+++ b/drivers/staging/gma500/psb_bl.c
@@ -194,6 +194,7 @@ int psb_backlight_init(struct drm_device *dev)
 	struct backlight_properties props;
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = 100;
+	props.type = BACKLIGHT_PLATFORM;
 
 	psb_backlight_device = backlight_device_register("psb-bl", NULL,
 						(void *)dev, &psb_ops, &props);

