Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab0HPCVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 22:21:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51346 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab0HPCVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 22:21:05 -0400
Date: Mon, 16 Aug 2010 12:20:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] spi: update for of_device to platform_device replacement
Message-Id: <20100816122059.c3ee7f6a.sfr@canb.auug.org.au>
In-Reply-To: <20100809120509.be36a4fa.sfr@canb.auug.org.au>
References: <20100809120509.be36a4fa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/ata/sata_dwc_460ex.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Hi Grant,

On Mon, 9 Aug 2010 12:05:09 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> I also added this merge fix patch (as suggest by you):

This patch now is needed in Linus' tree.  I will add it to my fixes tree
for today.  Linus, can you take this, please?

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index ea24c1e..2673a3d 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1588,7 +1588,7 @@ static const struct ata_port_info sata_dwc_port_info[] = {
 	},
 };
 
-static int sata_dwc_probe(struct of_device *ofdev,
+static int sata_dwc_probe(struct platform_device *ofdev,
 			const struct of_device_id *match)
 {
 	struct sata_dwc_device *hsdev;
@@ -1702,7 +1702,7 @@ error_out:
 	return err;
 }
 
-static int sata_dwc_remove(struct of_device *ofdev)
+static int sata_dwc_remove(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct ata_host *host = dev_get_drvdata(dev);
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
