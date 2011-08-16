Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab1HPHcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 03:32:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50105 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1HPHcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 03:32:17 -0400
MIME-Version: 1.0
In-Reply-To: <1313467929-28250-1-git-send-email-jeffbrown@android.com>
References: <1313467929-28250-1-git-send-email-jeffbrown@android.com>
Date: Tue, 16 Aug 2011 09:32:16 +0200
Message-ID: <CAN+gG=GYZxxOL8PKDdvb-HNhBq-M+rWu+qFkiZTFufyciqP3vQ@mail.gmail.com>
Subject: Re: [PATCH] hid-multitouch: Add LG Display Multitouch device.
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: jeffbrown@android.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        rydberg@euromail.se, chatty@enac.fr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 06:12,  <jeffbrown@android.com> wrote:
> From: Jeff Brown <jeffbrown@android.com>
>
> This panel is also known as the Dell ST2220Tc.

Reviewed-By: Benjamin Tissoires <Benjamin_Tissoires@logitech.com>

>
> Signed-off-by: jeffbrown@android.com
>
> ---
>  drivers/hid/Kconfig          |    1 +
>  drivers/hid/hid-core.c       |    1 +
>  drivers/hid/hid-ids.h        |    3 +++
>  drivers/hid/hid-multitouch.c |    5 +++++
>  4 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 306b15f..3cbe8cc 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -328,6 +328,7 @@ config HID_MULTITOUCH
>          - Hanvon dual touch panels
>          - Ilitek dual touch panels
>          - IrTouch Infrared USB panels
> +         - LG Display panels (Dell ST2220Tc)
>          - Lumio CrystalTouch panels
>          - MosArt dual-touch panels
>          - PenMount dual touch panels
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 1a5cf0c..11b3b39 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1396,6 +1396,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
>        { HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
>        { HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
>        { HID_USB_DEVICE(USB_VENDOR_ID_LCPOWER, USB_DEVICE_ID_LCPOWER_LC1000 ) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_LG, USB_DEVICE_ID_LG_MULTITOUCH) },
>        { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
>        { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
>        { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2) },
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index db63ccf..637e6e9 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -419,6 +419,9 @@
>  #define USB_DEVICE_ID_LD_HYBRID                0x2090
>  #define USB_DEVICE_ID_LD_HEATCONTROL   0x20A0
>
> +#define USB_VENDOR_ID_LG               0x1fd2
> +#define USB_DEVICE_ID_LG_MULTITOUCH    0x0064
> +
>  #define USB_VENDOR_ID_LOGITECH         0x046d
>  #define USB_DEVICE_ID_LOGITECH_RECEIVER        0xc101
>  #define USB_DEVICE_ID_LOGITECH_HARMONY_FIRST  0xc110
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 58d0e7a..9fc15e1 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -672,6 +672,11 @@ static const struct hid_device_id mt_devices[] = {
>                HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
>                        USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
>
> +       /* LG Display panels */
> +       { .driver_data = MT_CLS_DEFAULT,
> +               HID_USB_DEVICE(USB_VENDOR_ID_LG,
> +                       USB_DEVICE_ID_LG_MULTITOUCH) },
> +
>        /* Lumio panels */
>        { .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
>                HID_USB_DEVICE(USB_VENDOR_ID_LUMIO,
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
