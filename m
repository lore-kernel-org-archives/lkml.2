Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab1KZIIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 03:08:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50441 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1KZIID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 03:08:03 -0500
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 26 Nov 2011 16:07:18 +0800
Message-ID: <CANFwon20C9NC6GmWnwfSHcWOSFe-7fdt_QbCQQNhegieNeDUNA@mail.gmail.com>
Subject: [PATCH] fix build error of function iio_event_getfd
To: Jonathan Cameron <jic23@cam.ac.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got a build error:
  CC [M]  drivers/staging/iio/industrialio-core.o
/home/teawater/kernel2/linux/drivers/staging/iio/industrialio-core.c:
In function ‘iio_event_getfd’:
/home/teawater/kernel2/linux/drivers/staging/iio/industrialio-core.c:262:32:
error: ‘ev_int’ undeclared (first use in this function)
/home/teawater/kernel2/linux/drivers/staging/iio/industrialio-core.c:262:32:
note: each undeclared identifier is reported only once for each
function it appears in
Not sure it is fixed or not.
Post a patch for it.

Signed-off-by: Hui Zhu <teawater@gmail.com>
---
 drivers/staging/iio/industrialio-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -243,6 +243,7 @@ static const struct file_operations iio_
 static int iio_event_getfd(struct iio_dev *indio_dev)
 {
 	int fd;
+	struct iio_event_interface *ev_int = indio_dev->event_interface;

 	if (indio_dev->event_interface == NULL)
 		return -ENODEV;
