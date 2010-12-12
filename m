Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0LLX4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:56:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36711 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab0LLXsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:14 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: gregkh@suse.de, jic23@cam.ac.uk, Barry.Song@analog.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [187/223] Staging: iio: adis16220: fix up my fixup for some sysfs attribute permissions
Message-Id: <20101212234812.DED6EB27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

commit c9e51d9e4bee3da47623622884f4828e079a0581 upstream.

They should be writable by root, not readable.
Doh, stupid me with the wrong flags.

Reported-by: Jonathan Cameron <jic23@cam.ac.uk>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Barry Song <Barry.Song@analog.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/iio/accel/adis16220_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/staging/iio/accel/adis16220_core.c
===================================================================
--- linux.orig/drivers/staging/iio/accel/adis16220_core.c
+++ linux/drivers/staging/iio/accel/adis16220_core.c
@@ -506,7 +506,7 @@ static IIO_DEVICE_ATTR(reset, S_IWUSR, N
 		adis16220_write_reset, 0);
 
 #define IIO_DEV_ATTR_CAPTURE(_store)				\
-	IIO_DEVICE_ATTR(capture, S_IRUSR, NULL, _store, 0)
+	IIO_DEVICE_ATTR(capture, S_IWUSR, NULL, _store, 0)
 
 static IIO_DEV_ATTR_CAPTURE(adis16220_write_capture);
 
