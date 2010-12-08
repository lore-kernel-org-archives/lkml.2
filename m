Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0LHBNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:13:21 -0500
Received: from kroah.org ([198.145.64.141]:33775 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932772Ab0LHBDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:41 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:46 2010
Message-Id: <20101208005746.180080999@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jonathan Cameron <jic23@cam.ac.uk>, Barry Song <Barry.Song@analog.com>
Subject: [248/289] Staging: iio: adis16220: fix up some sysfs attribute permissions
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 1d904e8950c86e670ace237eaea1d48cd81e94df upstream.

They should not be writable by any user

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Barry Song <Barry.Song@analog.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/iio/accel/adis16220_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/accel/adis16220_core.c
+++ b/drivers/staging/iio/accel/adis16220_core.c
@@ -506,7 +506,7 @@ static IIO_DEVICE_ATTR(reset, S_IWUSR, N
 		adis16220_write_reset, 0);
 
 #define IIO_DEV_ATTR_CAPTURE(_store)				\
-	IIO_DEVICE_ATTR(capture, S_IWUGO, NULL, _store, 0)
+	IIO_DEVICE_ATTR(capture, S_IRUSR, NULL, _store, 0)
 
 static IIO_DEV_ATTR_CAPTURE(adis16220_write_capture);
 


