Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab0IRTTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:19:32 -0400
Received: from kroah.org ([198.145.64.141]:43895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757226Ab0IRTQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:24 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:07 2010
Message-Id: <20100918191306.983784207@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [113/129] agp/intel: Promote warning about failure to setup flush to error.
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit df51e7aa2cf204e3a65657a1d60b96cfda133e9b upstream.

Make sure we always detect when we fail to correctly allocate the Isoch
Flush Page and print an error to warn the user about the likely memory
corruption that will result in invalid rendering or worse.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-gtt.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1061,11 +1061,11 @@ static void intel_i9xx_setup_flush(void)
 		intel_i915_setup_chipset_flush();
 	}
 
-	if (intel_private.ifp_resource.start) {
+	if (intel_private.ifp_resource.start)
 		intel_private.i9xx_flush_page = ioremap_nocache(intel_private.ifp_resource.start, PAGE_SIZE);
-		if (!intel_private.i9xx_flush_page)
-			dev_info(&intel_private.pcidev->dev, "can't ioremap flush page - no chipset flushing");
-	}
+	if (!intel_private.i9xx_flush_page)
+		dev_err(&intel_private.pcidev->dev,
+			"can't ioremap flush page - no chipset flushing\n");
 }
 
 static int intel_i9xx_configure(void)


