Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0LLX4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:56:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36707 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab0LLXsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:13 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: gregkh@suse.de, jic23@cam.ac.uk, Barry.Song@analog.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [186/223] Staging: iio: adis16220: fix up some sysfs attribute permissions
Message-Id: <20101212234811.CEA67B27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

commit 1d904e8950c86e670ace237eaea1d48cd81e94df upstream.

They should not be writable by any user

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
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
-	IIO_DEVICE_ATTR(capture, S_IWUGO, NULL, _store, 0)
+	IIO_DEVICE_ATTR(capture, S_IRUSR, NULL, _store, 0)
 
 static IIO_DEV_ATTR_CAPTURE(adis16220_write_capture);
 
