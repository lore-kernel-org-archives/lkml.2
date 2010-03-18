Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0CRRKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:10:52 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:42919
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752636Ab0CRRKu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:10:50 -0400
Date: Thu, 18 Mar 2010 13:10:47 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Subject: Re: [V2 PATCH 06/10] of/drivers: Always use struct device.of_node
 to  get node pointer
Message-ID: <20100318131047.6dbdef73@lappy.seanm.ca>
In-Reply-To: <fa686aa41003181007k9202cd6n44d2d3997ef626a1@mail.gmail.com>
References: <20100318144836.21082.93040.stgit@angua>
	<20100318152238.21082.10985.stgit@angua>
	<20100318125939.2b39d7f2@lappy.seanm.ca>
	<fa686aa41003181007k9202cd6n44d2d3997ef626a1@mail.gmail.com>
Organization: PIKA
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAHlBMVEXOy8P+/f8hHBFoOhetjm76/P5qPzJLJxltXUSaX0wbgtjEAAACY0lEQVQ4jWWUQWvcMBCF91BCjiuIIWcX6nsE9uZWgknjWwW7sD2rjL1XGzzpNS2ufI5xVv+2byTHSehcbO8nzWjeG+1GqcPhZfTlEl8/hUdVbgDUvfNT+SEqH8Ho/UdQCjDJg0dMceVUhVcBKhn8Go7qTjd4CYCcBL7OQ9GmGXfNuICauaNmIKrbNGWivAngQPhMOScibODGOZ2PYUfdMlCnyTJWpFlu9SkW14Ps6cdZHoJ4F4ENPzxOD3i2cZMA9VCHdV/KCmdC3i7WMAKyNuNfZVUwzoA2pmqjDkZd1ikjfpblTDj32PhSwEH9GHTBrQDvpaXT9Aqc1cz9HwHedg20qkLxK2cLNIh1q8p+Ae53TsMJ36shAewdDPHz+B/YDqOffEhTvXMQYIbp0SppIdQKIIG31XwK4Pk2OrYAuGQX0JHUowDUPY1O77xkeob6CLsxYQfZvMhxNJhYsNY56bjjktA6Pgl6WIiLiOC6g1hQltMMIJBY/FrEhcRisIWcrG3csa8DEOt6pGs5HwIw2zrkCW6TCN0sQP2tuwjSmouWb10EiXrJcUwhqAzfx2aWaYe5F48k9qbBYplKFybRmGPvbuJIyUTKTAagkquabrJWcnV0OqONqFWSfH/qi52cDOvHs10bVOobgEb73NPoh1WSJDky72whkmDcVmCkCMuJU9Yn/y6VMWaGriTTiesmUxZTIS4yOIR5qPzZSbMr2LefcaB4P/V7kNxlvcY9xJnEQ70Cc2w7aCFXtBCnVqC2uCEiU2hz6TxuuUsz0TDy/C1Vcgwayh8AwFvxg9k/LTcWUfA/se5dIXIv87sAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010 11:07:35 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Thu, Mar 18, 2010 at 10:59 AM, Sean MacLennan
> <smaclennan@pikatech.com> wrote:
> > On Thu, 18 Mar 2010 09:22:39 -0600
> > Grant Likely <grant.likely@secretlab.ca> wrote:
> >
> >> The following structure elements duplicate the information in
> >> 'struct device.of_node' and so are being eliminated.  This patches
> >> makes all readers of the following elements use device.of_node
> >> instead.
> >
> > The NDFC driver also needs a patch... or at least the version from
> > your last of_patch set does. I am included the patch I needed to
> > get it to compile.
> 
> Thanks Sean, I've added this patch to my series.  s-o-b line please?
> 
> g.

Signed-off-by: Sean MacLennan <smaclennan@pikatech.com>
---
diff --git a/drivers/mtd/nand/ndfc.c b/drivers/mtd/nand/ndfc.c
index 19d94a2..5a232ec 100644
--- a/drivers/mtd/nand/ndfc.c
+++ b/drivers/mtd/nand/ndfc.c
@@ -238,14 +238,14 @@ static int __devinit ndfc_probe(struct of_device *ofdev,
 	dev_set_drvdata(&ofdev->dev, ndfc);
 
 	/* Read the reg property to get the chip select */
-	reg = of_get_property(ofdev->node, "reg", &len);
+	reg = of_get_property(ofdev->dev.of_node, "reg", &len);
 	if (reg == NULL || len != 12) {
 		dev_err(&ofdev->dev, "unable read reg property (%d)\n", len);
 		return -ENOENT;
 	}
 	ndfc->chip_select = reg[0];
 
-	ndfc->ndfcbase = of_iomap(ofdev->node, 0);
+	ndfc->ndfcbase = of_iomap(ofdev->dev.of_node, 0);
 	if (!ndfc->ndfcbase) {
 		dev_err(&ofdev->dev, "failed to get memory\n");
 		return -EIO;
@@ -254,20 +254,20 @@ static int __devinit ndfc_probe(struct of_device *ofdev,
 	ccr = NDFC_CCR_BS(ndfc->chip_select);
 
 	/* It is ok if ccr does not exist - just default to 0 */
-	reg = of_get_property(ofdev->node, "ccr", NULL);
+	reg = of_get_property(ofdev->dev.of_node, "ccr", NULL);
 	if (reg)
 		ccr |= *reg;
 
 	out_be32(ndfc->ndfcbase + NDFC_CCR, ccr);
 
 	/* Set the bank settings if given */
-	reg = of_get_property(ofdev->node, "bank-settings", NULL);
+	reg = of_get_property(ofdev->dev.of_node, "bank-settings", NULL);
 	if (reg) {
 		int offset = NDFC_BCFG0 + (ndfc->chip_select << 2);
 		out_be32(ndfc->ndfcbase + offset, *reg);
 	}
 
-	err = ndfc_chip_init(ndfc, ofdev->node);
+	err = ndfc_chip_init(ndfc, ofdev->dev.of_node);
 	if (err) {
 		iounmap(ndfc->ndfcbase);
 		return err;
