Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1BVWYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:24:36 -0500
Received: from kroah.org ([198.145.64.141]:33016 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab1BVWWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:43 2011
Message-Id: <20110222221843.531763222@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Warren <swarren@nvidia.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [65/70] ASoC: WM8903: Fix mic detection enable logic
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 3088e3b4963d26d6f6f54987f595b974ed6d48d8 upstream.

The mic detection HW should be enabled when either mic or short detection
is required, not when only both are required.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8903.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -1479,7 +1479,7 @@ int wm8903_mic_detect(struct snd_soc_cod
 			    WM8903_MICDET_EINT | WM8903_MICSHRT_EINT,
 			    irq_mask);
 
-	if (det && shrt) {
+	if (det || shrt) {
 		/* Enable mic detection, this may not have been set through
 		 * platform data (eg, if the defaults are OK). */
 		snd_soc_update_bits(codec, WM8903_WRITE_SEQUENCER_0,


