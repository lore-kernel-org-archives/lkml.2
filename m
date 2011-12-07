Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab1LGQSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:18:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270Ab1LGQSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:18:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:24 2011
Message-Id: <20111207160824.347276591@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:41 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Timur Tabi <timur@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [21/80] ASoC: fsl_ssi: properly initialize the sysfs attribute object
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <timur@freescale.com>

commit 0f768a7235d3dfb6f4833030a95a06419df089cb upstream.

Commit 6992f533 ("sysfs: Use one lockdep class per sysfs attribute")
requires 'struct attribute' objects to be initialized with sysfs_attr_init().

Signed-off-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/fsl/fsl_ssi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -698,6 +698,7 @@ static int __devinit fsl_ssi_probe(struc
 
 	/* Initialize the the device_attribute structure */
 	dev_attr = &ssi_private->dev_attr;
+	sysfs_attr_init(&dev_attr->attr);
 	dev_attr->attr.name = "statistics";
 	dev_attr->attr.mode = S_IRUGO;
 	dev_attr->show = fsl_sysfs_ssi_show;


