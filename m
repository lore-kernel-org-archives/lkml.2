Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1KZJTo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 04:19:44 -0500
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:49860 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1KZJTm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 04:19:42 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <CANFwon20C9NC6GmWnwfSHcWOSFe-7fdt_QbCQQNhegieNeDUNA@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CANFwon20C9NC6GmWnwfSHcWOSFe-7fdt_QbCQQNhegieNeDUNA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] fix build error of function iio_event_getfd
From: Jonathan Cameron <jic23@cam.ac.uk>
Date: Sat, 26 Nov 2011 09:19:34 +0000
To: Hui Zhu <teawater@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Message-ID: <a3c3695e-8a13-4e44-9660-0df049d86003@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks but this is 7th fix I have seen.

Hui Zhu <teawater@gmail.com> wrote:

>Got a build error:
>  CC [M]  drivers/staging/iio/industrialio-core.o
>/home/teawater/kernel2/linux/drivers/staging/iio/industrialio-core.c:
>In function ‘iio_event_getfd’:
>/home/teawater/kernel2/linux/drivers/staging/iio/industrialio-core.c:262:32:
>error: ‘ev_int’ undeclared (first use in this function)
>/home/teawater/kernel2/linux/drivers/staging/iio/industrialio-core.c:262:32:
>note: each undeclared identifier is reported only once for each
>function it appears in
>Not sure it is fixed or not.
>Post a patch for it.
>
>Signed-off-by: Hui Zhu <teawater@gmail.com>
>---
> drivers/staging/iio/industrialio-core.c |    1 +
> 1 file changed, 1 insertion(+)
>
>--- a/drivers/staging/iio/industrialio-core.c
>+++ b/drivers/staging/iio/industrialio-core.c
>@@ -243,6 +243,7 @@ static const struct file_operations iio_
> static int iio_event_getfd(struct iio_dev *indio_dev)
> {
> 	int fd;
>+	struct iio_event_interface *ev_int = indio_dev->event_interface;
>
> 	if (indio_dev->event_interface == NULL)
> 		return -ENODEV;

-- 
Sent from my Android phone 
with K-9 Mail. Please excuse my brevity.
