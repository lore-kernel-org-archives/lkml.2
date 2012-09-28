Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423217Ab2I1VIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:08:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51788 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423177Ab2I1VFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:05:55 -0400
X-Sasl-enc: 91zryRD3dLZ2DJLF4yilIDEyBcS0Ccwo7Ir7za+SY9Ba 1348866355
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alfredo Capella <alfredo.capella@gmail.com>
Subject: [ 124/127] spi/spi-fsl-spi: reference correct pdata in fsl_spi_cs_control
Date: Fri, 28 Sep 2012 13:34:57 -0700
Message-Id: <20120928203100.392359285@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

commit 067aa4815a9bc12a569d8a06afef50ba5773afbf upstream.

Commit 178db7d3, "spi: Fix device unregistration when unregistering
the bus master", changed spi device initialization of dev.parent pointer
to be the master's device pointer instead of his parent.

This introduced a bug in spi-fsl-spi, since its usage of spi device
pointer was not updated accordingly. This was later fixed by commit
5039a86, "spi/mpc83xx: fix NULL pdata dereference bug", but it missed
another spot on fsl_spi_cs_control function where we also need to update
usage of spi device pointer. This change address that.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Alfredo Capella <alfredo.capella@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi_fsl_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi_fsl_spi.c
+++ b/drivers/spi/spi_fsl_spi.c
@@ -936,7 +936,7 @@ err:
 
 static void fsl_spi_cs_control(struct spi_device *spi, bool on)
 {
-	struct device *dev = spi->dev.parent;
+	struct device *dev = spi->dev.parent->parent;
 	struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(dev->platform_data);
 	u16 cs = spi->chip_select;
 	int gpio = pinfo->gpios[cs];


