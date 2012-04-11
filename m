Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946Ab2DKXR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:17:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964933Ab2DKXRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:17:55 -0400
Message-Id: <20120411231028.849418300@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 62/78] mfd: Fix section mismatch warning for da9052-spi
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit e536b62095301271d974983044a011c29fcb2ea2 upstream.

Add __devinit annotation for da9052_spi_probe to fix below build warning:

WARNING: drivers/built-in.o(.text+0x349b4): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init()
The function da9052_spi_probe() references
the function __devinit da9052_device_init().
This is often because da9052_spi_probe lacks a __devinit
annotation or the annotation of da9052_device_init is wrong.

Also add __devexit annotation for da9052_spi_remove because we have
__devexit_p around it in the remove callback.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/da9052-spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -21,7 +21,7 @@
 
 #include <linux/mfd/da9052/da9052.h>
 
-static int da9052_spi_probe(struct spi_device *spi)
+static int __devinit da9052_spi_probe(struct spi_device *spi)
 {
 	int ret;
 	const struct spi_device_id *id = spi_get_device_id(spi);
@@ -61,7 +61,7 @@ err:
 	return ret;
 }
 
-static int da9052_spi_remove(struct spi_device *spi)
+static int __devexit da9052_spi_remove(struct spi_device *spi)
 {
 	struct da9052 *da9052 = dev_get_drvdata(&spi->dev);
 


