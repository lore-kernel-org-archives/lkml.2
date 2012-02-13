Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2BMIlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 03:41:22 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:45948 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993Ab2BMIlV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 03:41:21 -0500
MIME-Version: 1.0
In-Reply-To: <20120213080644.6105.54221.stgit@zurg>
References: <20120213080644.6105.54221.stgit@zurg>
From: Nestor Lopez Casado <nlopezcasad@logitech.com>
Date: Mon, 13 Feb 2012 09:40:49 +0100
Message-ID: <CAE7qMrrubKoOSo+kwG9rpx6ac8U=6PQtHTDEh416NBBJNr8mGA@mail.gmail.com>
Subject: Re: [PATCH] HID: use generic driver for Logitech Unifying receivers
 if CONFIG_HID_LOGITECH_DJ=n
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konstantin,

This was the original implementation
http://www.spinics.net/lists/linux-input/msg15225.html
Jiri suggested we removed the conditional compilation and we accepted.

Which are your reasons to add those conditionals back again?

Cheers,

Nestor

On Mon, Feb 13, 2012 at 9:06 AM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> Before commit 534a7b8e1 "HID: Add full support for Logitech Unifying receivers"
> Logitech Unifying receiver can work as generic device without special driver,
> after that commit these devices does not works without special driver.
>
> After this patch they will use generic driver if special driver is disabled.
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  drivers/hid/hid-core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index af08ce7..3d7a174 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1462,8 +1462,10 @@ static const struct hid_device_id hid_have_special_driver[] = {
>        { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_DFGT_WHEEL) },
>        { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G25_WHEEL) },
>        { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G27_WHEEL) },
> +#if IS_ENABLED(CONFIG_HID_LOGITECH_DJ)
>        { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER) },
>        { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER_2) },
> +#endif
>        { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WII_WHEEL) },
>        { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD2) },
>        { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACETRAVELLER) },
>
