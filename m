Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab2E0BLo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:11:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab2E0BLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:11:38 -0400
Message-Id: <20120527010433.768465216@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:34 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [ 71/94] spi/spi-fsl-spi: reference correct pdata in
 fsl_spi_cs_control
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-fsl-spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -931,7 +931,7 @@ err:
 
 static void fsl_spi_cs_control(struct spi_device *spi, bool on)
 {
-	struct device *dev = spi->dev.parent;
+	struct device *dev = spi->dev.parent->parent;
 	struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(dev->platform_data);
 	u16 cs = spi->chip_select;
 	int gpio = pinfo->gpios[cs];


