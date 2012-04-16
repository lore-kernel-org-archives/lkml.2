Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab2DPQIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:08:19 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:35882 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2DPQIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:08:17 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <1334591862-5169-1-git-send-email-ldewangan@nvidia.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <1334591862-5169-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] staging: iio: light: isl29028: fix correct mask value
From: Jonathan Cameron <jic23@cam.ac.uk>
Date: Mon, 16 Apr 2012 17:08:07 +0100
To: Laxman Dewangan <ldewangan@nvidia.com>, gregkh@linuxfoundation.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Message-ID: <f9fb01a9-362a-4540-9547-63263a4ca10e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Laxman Dewangan <ldewangan@nvidia.com> wrote:

>The mask value in the read_raw/write_raw is absolute
>value, not the bit position value.
>Fixing this in the implemented function to check value,
>not with the bit position value.
Oops I should have caught that.
Sorry 
>
>Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Acked-by: <jic23@kernel.org>
>---
>Somehow this was missed on my testing.
>I tested today again with linux next and found this issue.
>
> drivers/staging/iio/light/isl29028.c |    8 ++++----
> 1 files changed, 4 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/staging/iio/light/isl29028.c
>b/drivers/staging/iio/light/isl29028.c
>index e705e45..4e6ac24 100644
>--- a/drivers/staging/iio/light/isl29028.c
>+++ b/drivers/staging/iio/light/isl29028.c
>@@ -272,7 +272,7 @@ static int isl29028_write_raw(struct iio_dev
>*indio_dev,
> 	mutex_lock(&chip->lock);
> 	switch (chan->type) {
> 	case IIO_PROXIMITY:
>-		if (mask != IIO_CHAN_INFO_SAMP_FREQ_SEPARATE_BIT) {
>+		if (mask != IIO_CHAN_INFO_SAMP_FREQ) {
> 			dev_err(chip->dev,
> 				"proximity: mask value 0x%08lx not supported\n",
> 				mask);
>@@ -294,7 +294,7 @@ static int isl29028_write_raw(struct iio_dev
>*indio_dev,
> 		break;
> 
> 	case IIO_LIGHT:
>-		if (mask != IIO_CHAN_INFO_SCALE_SEPARATE_BIT) {
>+		if (mask != IIO_CHAN_INFO_SCALE) {
> 			dev_err(chip->dev,
> 				"light: mask value 0x%08lx not supported\n",
> 				mask);
>@@ -349,14 +349,14 @@ static int isl29028_read_raw(struct iio_dev
>*indio_dev,
> 		ret = IIO_VAL_INT;
> 		break;
> 
>-	case IIO_CHAN_INFO_SAMP_FREQ_SEPARATE_BIT:
>+	case IIO_CHAN_INFO_SAMP_FREQ:
> 		if (chan->type != IIO_PROXIMITY)
> 			break;
> 		*val = chip->prox_sampling;
> 		ret = IIO_VAL_INT;
> 		break;
> 
>-	case IIO_CHAN_INFO_SCALE_SEPARATE_BIT:
>+	case IIO_CHAN_INFO_SCALE:
> 		if (chan->type != IIO_LIGHT)
> 			break;
> 		*val = chip->lux_scale;
>-- 
>1.7.1.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
