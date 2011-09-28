Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab1I1XSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:18:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893Ab1I1Wmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:42:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:36 2011
Message-Id: <20110928220136.291403643@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Timur Tabi <timur@freescale.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [104/244] ASoC: MPC5200: replace of_device with platform_device
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Timur Tabi <timur@freescale.com>

commit 3bdf28feafc52864bd7f17b39deec64833a89d19 upstream.

'struct of_device' no longer exists, and its functionality has been merged
into platform_device.  Update the MPC5200 audio DMA driver (mpc5200_dma)
accordingly.  This fixes a build break.

Signed-off-by: Timur Tabi <timur@freescale.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/fsl/mpc5200_dma.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/fsl/mpc5200_dma.c
+++ b/sound/soc/fsl/mpc5200_dma.c
@@ -368,7 +368,7 @@ static struct snd_soc_platform_driver mp
 	.pcm_free	= &psc_dma_free,
 };
 
-static int mpc5200_hpcd_probe(struct of_device *op)
+static int mpc5200_hpcd_probe(struct platform_device *op)
 {
 	phys_addr_t fifo;
 	struct psc_dma *psc_dma;
@@ -486,7 +486,7 @@ out_unmap:
 	return ret;
 }
 
-static int mpc5200_hpcd_remove(struct of_device *op)
+static int mpc5200_hpcd_remove(struct platform_device *op)
 {
 	struct psc_dma *psc_dma = dev_get_drvdata(&op->dev);
 
@@ -518,7 +518,7 @@ MODULE_DEVICE_TABLE(of, mpc5200_hpcd_mat
 static struct platform_driver mpc5200_hpcd_of_driver = {
 	.probe		= mpc5200_hpcd_probe,
 	.remove		= mpc5200_hpcd_remove,
-	.dev = {
+	.driver = {
 		.owner		= THIS_MODULE,
 		.name		= "mpc5200-pcm-audio",
 		.of_match_table    = mpc5200_hpcd_match,


