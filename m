Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1LSV3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 16:29:24 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48973 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1LSV3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 16:29:21 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 9/9] gma500: SDVO DDC bus guessing isn't working so hardcode
 it instead
To: airlied@linux.ie, linux-kernel@vger.kernel.org
Date: Mon, 19 Dec 2011 21:41:45 +0000
Message-ID: <20111219214144.32042.9938.stgit@bob.linux.org.uk>
In-Reply-To: <20111219213950.32042.20984.stgit@bob.linux.org.uk>
References: <20111219213950.32042.20984.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

We currently don't have support for parsing SDVO mappings from BIOS so we're
guessing the bus switch parameter. This isn't working so hardcode it to a
configuration known to work on most poulsbo hardware.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/gpu/drm/gma500/psb_intel_sdvo.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/drivers/gpu/drm/gma500/psb_intel_sdvo.c b/drivers/gpu/drm/gma500/psb_intel_sdvo.c
index 20d5366..4882b29 100644
--- a/drivers/gpu/drm/gma500/psb_intel_sdvo.c
+++ b/drivers/gpu/drm/gma500/psb_intel_sdvo.c
@@ -1876,6 +1876,13 @@ static const struct drm_encoder_funcs psb_intel_sdvo_enc_funcs = {
 static void
 psb_intel_sdvo_guess_ddc_bus(struct psb_intel_sdvo *sdvo)
 {
+	/* FIXME: At the moment, ddc_bus = 2 is the only thing that works.
+	 * We need to figure out if this is true for all available poulsbo
+	 * hardware, or if we need to fiddle with the guessing code above.
+	 * The problem might go away if we can parse sdvo mappings from bios */
+	sdvo->ddc_bus = 2;
+
+#if 0
 	uint16_t mask = 0;
 	unsigned int num_bits;
 
@@ -1907,6 +1914,7 @@ psb_intel_sdvo_guess_ddc_bus(struct psb_intel_sdvo *sdvo)
 
 	/* Corresponds to SDVO_CONTROL_BUS_DDCx */
 	sdvo->ddc_bus = 1 << num_bits;
+#endif
 }
 
 /**

