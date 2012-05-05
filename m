Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab2EEKkV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 06:40:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34797 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab2EEKkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 06:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <1336138324-8217-1-git-send-email-rydberg@euromail.se>
References: <1336138324-8217-1-git-send-email-rydberg@euromail.se>
Date: Sat, 5 May 2012 12:40:18 +0200
Message-ID: <CAN+gG=ETZKxtbLgivf2ZgfQrF=vrfKkbZ37ybzAXz60uNS8qvg@mail.gmail.com>
Subject: Re: [PATCH v2] HID: hid-multitouch: Only match MT interfaces
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

thanks for the respin.

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
...and Tested-by too ;-)

Cheers,
Benjamin

On Fri, May 4, 2012 at 3:32 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> All known hid-multitouch devices currently match any device group.
> However, some devices present interfaces belonging to different groups,
> resulting in a race between the hid-generic and hid-multitouch modules.
> This patch narrows the MT device list to match only HID_GROUP_MULTITOUCH,
> which solves the problem.
>
> As an exception, the USB_DEVICE_ID_CYPRESS_TRUETOUCH panel is not
> modified, in order to suppress the unwanted extra interfaces of the
> device.
>
> Reported-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Ok, here is the version without changing the cypress device. Jiri assured
> that he will take care of the merge with the baanto device, so that one is
> omitted here.
>
> Thanks,
> Henrik
>
>  drivers/hid/hid-multitouch.c |  143 +++++++++++++++++++++---------------------
>  1 file changed, 73 insertions(+), 70 deletions(-)
>
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index ea465f1..b10c204 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -110,6 +110,9 @@ struct mt_device {
>
>  #define MT_DEFAULT_MAXCONTACT  10
>
> +#define MT_USB_DEVICE(v, p)    HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH, v, p)
> +#define MT_BT_DEVICE(v, p)     HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_MULTITOUCH, v, p)
> +
>  /*
>  * these device-dependent functions determine what slot corresponds
>  * to a valid contact that was just read.
> @@ -735,50 +738,50 @@ static const struct hid_device_id mt_devices[] = {
>
>        /* 3M panels */
>        { .driver_data = MT_CLS_3M,
> -               HID_USB_DEVICE(USB_VENDOR_ID_3M,
> +               MT_USB_DEVICE(USB_VENDOR_ID_3M,
>                        USB_DEVICE_ID_3M1968) },
>        { .driver_data = MT_CLS_3M,
> -               HID_USB_DEVICE(USB_VENDOR_ID_3M,
> +               MT_USB_DEVICE(USB_VENDOR_ID_3M,
>                        USB_DEVICE_ID_3M2256) },
>        { .driver_data = MT_CLS_3M,
> -               HID_USB_DEVICE(USB_VENDOR_ID_3M,
> +               MT_USB_DEVICE(USB_VENDOR_ID_3M,
>                        USB_DEVICE_ID_3M3266) },
>
>        /* ActionStar panels */
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
> +               MT_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
>                        USB_DEVICE_ID_ACTIONSTAR_1011) },
>
>        /* Atmel panels */
>        { .driver_data = MT_CLS_SERIAL,
> -               HID_USB_DEVICE(USB_VENDOR_ID_ATMEL,
> +               MT_USB_DEVICE(USB_VENDOR_ID_ATMEL,
>                        USB_DEVICE_ID_ATMEL_MULTITOUCH) },
>        { .driver_data = MT_CLS_SERIAL,
> -               HID_USB_DEVICE(USB_VENDOR_ID_ATMEL,
> +               MT_USB_DEVICE(USB_VENDOR_ID_ATMEL,
>                        USB_DEVICE_ID_ATMEL_MXT_DIGITIZER) },
>
>        /* Cando panels */
>        { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
> -               HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
> +               MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
>                        USB_DEVICE_ID_CANDO_MULTI_TOUCH) },
>        { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
> -               HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
> +               MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
>                        USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1) },
>        { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
> -               HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
> +               MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
>                        USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6) },
>        { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
> -               HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
> +               MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
>                        USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6) },
>
>        /* Chunghwa Telecom touch panels */
>        {  .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT,
> +               MT_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT,
>                        USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH) },
>
>        /* CVTouch panels */
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_CVTOUCH,
> +               MT_USB_DEVICE(USB_VENDOR_ID_CVTOUCH,
>                        USB_DEVICE_ID_CVTOUCH_SCREEN) },
>
>        /* Cypress panel */
> @@ -788,223 +791,223 @@ static const struct hid_device_id mt_devices[] = {
>
>        /* eGalax devices (resistive) */
>        { .driver_data = MT_CLS_EGALAX,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480D) },
>        { .driver_data = MT_CLS_EGALAX,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480E) },
>
>        /* eGalax devices (capacitive) */
>        { .driver_data = MT_CLS_EGALAX,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C) },
>        { .driver_data = MT_CLS_EGALAX_SERIAL,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7207) },
>        { .driver_data = MT_CLS_EGALAX_SERIAL,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_725E) },
>        { .driver_data = MT_CLS_EGALAX_SERIAL,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7224) },
>        { .driver_data = MT_CLS_EGALAX_SERIAL,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_722A) },
>        { .driver_data = MT_CLS_EGALAX,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B) },
>        { .driver_data = MT_CLS_EGALAX_SERIAL,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7262) },
>        { .driver_data = MT_CLS_EGALAX,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1) },
>        { .driver_data = MT_CLS_EGALAX_SERIAL,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72AA) },
>        { .driver_data = MT_CLS_EGALAX,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72FA) },
>        { .driver_data = MT_CLS_EGALAX,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302) },
>        { .driver_data = MT_CLS_EGALAX_SERIAL,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7349) },
>        { .driver_data = MT_CLS_EGALAX_SERIAL,
> -               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +               MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
>
>        /* Elo TouchSystems IntelliTouch Plus panel */
>        { .driver_data = MT_CLS_DUAL_NSMU_CONTACTID,
> -               HID_USB_DEVICE(USB_VENDOR_ID_ELO,
> +               MT_USB_DEVICE(USB_VENDOR_ID_ELO,
>                        USB_DEVICE_ID_ELO_TS2515) },
>
>        /* GeneralTouch panel */
>        { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
> -               HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
> +               MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
>                        USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS) },
>
>        /* Gametel game controller */
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_FRUCTEL,
> +               MT_BT_DEVICE(USB_VENDOR_ID_FRUCTEL,
>                        USB_DEVICE_ID_GAMETEL_MT_MODE) },
>
>        /* GoodTouch panels */
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_GOODTOUCH,
> +               MT_USB_DEVICE(USB_VENDOR_ID_GOODTOUCH,
>                        USB_DEVICE_ID_GOODTOUCH_000f) },
>
>        /* Hanvon panels */
>        { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
> -               HID_USB_DEVICE(USB_VENDOR_ID_HANVON_ALT,
> +               MT_USB_DEVICE(USB_VENDOR_ID_HANVON_ALT,
>                        USB_DEVICE_ID_HANVON_ALT_MULTITOUCH) },
>
>        /* Ideacom panel */
>        { .driver_data = MT_CLS_SERIAL,
> -               HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM,
> +               MT_USB_DEVICE(USB_VENDOR_ID_IDEACOM,
>                        USB_DEVICE_ID_IDEACOM_IDC6650) },
>        { .driver_data = MT_CLS_SERIAL,
> -               HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM,
> +               MT_USB_DEVICE(USB_VENDOR_ID_IDEACOM,
>                        USB_DEVICE_ID_IDEACOM_IDC6651) },
>
>        /* Ilitek dual touch panel */
>        {  .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_ILITEK,
> +               MT_USB_DEVICE(USB_VENDOR_ID_ILITEK,
>                        USB_DEVICE_ID_ILITEK_MULTITOUCH) },
>
>        /* IRTOUCH panels */
>        { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
> -               HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
> +               MT_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
>                        USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
>
>        /* LG Display panels */
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_LG,
> +               MT_USB_DEVICE(USB_VENDOR_ID_LG,
>                        USB_DEVICE_ID_LG_MULTITOUCH) },
>
>        /* Lumio panels */
>        { .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
> -               HID_USB_DEVICE(USB_VENDOR_ID_LUMIO,
> +               MT_USB_DEVICE(USB_VENDOR_ID_LUMIO,
>                        USB_DEVICE_ID_CRYSTALTOUCH) },
>        { .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
> -               HID_USB_DEVICE(USB_VENDOR_ID_LUMIO,
> +               MT_USB_DEVICE(USB_VENDOR_ID_LUMIO,
>                        USB_DEVICE_ID_CRYSTALTOUCH_DUAL) },
>
>        /* MosArt panels */
>        { .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
> -               HID_USB_DEVICE(USB_VENDOR_ID_ASUS,
> +               MT_USB_DEVICE(USB_VENDOR_ID_ASUS,
>                        USB_DEVICE_ID_ASUS_T91MT)},
>        { .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
> -               HID_USB_DEVICE(USB_VENDOR_ID_ASUS,
> +               MT_USB_DEVICE(USB_VENDOR_ID_ASUS,
>                        USB_DEVICE_ID_ASUSTEK_MULTITOUCH_YFO) },
>        { .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
> -               HID_USB_DEVICE(USB_VENDOR_ID_TURBOX,
> +               MT_USB_DEVICE(USB_VENDOR_ID_TURBOX,
>                        USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
>
>        /* Panasonic panels */
>        { .driver_data = MT_CLS_PANASONIC,
> -               HID_USB_DEVICE(USB_VENDOR_ID_PANASONIC,
> +               MT_USB_DEVICE(USB_VENDOR_ID_PANASONIC,
>                        USB_DEVICE_ID_PANABOARD_UBT780) },
>        { .driver_data = MT_CLS_PANASONIC,
> -               HID_USB_DEVICE(USB_VENDOR_ID_PANASONIC,
> +               MT_USB_DEVICE(USB_VENDOR_ID_PANASONIC,
>                        USB_DEVICE_ID_PANABOARD_UBT880) },
>
>        /* PenMount panels */
>        { .driver_data = MT_CLS_CONFIDENCE,
> -               HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
> +               MT_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
>                        USB_DEVICE_ID_PENMOUNT_PCI) },
>
>        /* PixArt optical touch screen */
>        { .driver_data = MT_CLS_INRANGE_CONTACTNUMBER,
> -               HID_USB_DEVICE(USB_VENDOR_ID_PIXART,
> +               MT_USB_DEVICE(USB_VENDOR_ID_PIXART,
>                        USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN) },
>        { .driver_data = MT_CLS_INRANGE_CONTACTNUMBER,
> -               HID_USB_DEVICE(USB_VENDOR_ID_PIXART,
> +               MT_USB_DEVICE(USB_VENDOR_ID_PIXART,
>                        USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1) },
>        { .driver_data = MT_CLS_INRANGE_CONTACTNUMBER,
> -               HID_USB_DEVICE(USB_VENDOR_ID_PIXART,
> +               MT_USB_DEVICE(USB_VENDOR_ID_PIXART,
>                        USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2) },
>
>        /* PixCir-based panels */
>        { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
> -               HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
> +               MT_USB_DEVICE(USB_VENDOR_ID_HANVON,
>                        USB_DEVICE_ID_HANVON_MULTITOUCH) },
>        { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
> -               HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
> +               MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
>                        USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH) },
>
>        /* Quanta-based panels */
>        { .driver_data = MT_CLS_CONFIDENCE_CONTACT_ID,
> -               HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
> +               MT_USB_DEVICE(USB_VENDOR_ID_QUANTA,
>                        USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
>        { .driver_data = MT_CLS_CONFIDENCE_CONTACT_ID,
> -               HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
> +               MT_USB_DEVICE(USB_VENDOR_ID_QUANTA,
>                        USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3001) },
>        { .driver_data = MT_CLS_CONFIDENCE_CONTACT_ID,
> -               HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
> +               MT_USB_DEVICE(USB_VENDOR_ID_QUANTA,
>                        USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008) },
>
>        /* Stantum panels */
>        { .driver_data = MT_CLS_CONFIDENCE,
> -               HID_USB_DEVICE(USB_VENDOR_ID_STANTUM,
> +               MT_USB_DEVICE(USB_VENDOR_ID_STANTUM,
>                        USB_DEVICE_ID_MTP)},
>        { .driver_data = MT_CLS_CONFIDENCE,
> -               HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM,
> +               MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM,
>                        USB_DEVICE_ID_MTP_STM)},
>        { .driver_data = MT_CLS_CONFIDENCE,
> -               HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_SITRONIX,
> +               MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_SITRONIX,
>                        USB_DEVICE_ID_MTP_SITRONIX)},
>
>        /* TopSeed panels */
>        { .driver_data = MT_CLS_TOPSEED,
> -               HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED2,
> +               MT_USB_DEVICE(USB_VENDOR_ID_TOPSEED2,
>                        USB_DEVICE_ID_TOPSEED2_PERIPAD_701) },
>
>        /* Touch International panels */
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_TOUCH_INTL,
> +               MT_USB_DEVICE(USB_VENDOR_ID_TOUCH_INTL,
>                        USB_DEVICE_ID_TOUCH_INTL_MULTI_TOUCH) },
>
>        /* Unitec panels */
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_UNITEC,
> +               MT_USB_DEVICE(USB_VENDOR_ID_UNITEC,
>                        USB_DEVICE_ID_UNITEC_USB_TOUCH_0709) },
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_UNITEC,
> +               MT_USB_DEVICE(USB_VENDOR_ID_UNITEC,
>                        USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
>        /* XAT */
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_XAT,
> +               MT_USB_DEVICE(USB_VENDOR_ID_XAT,
>                        USB_DEVICE_ID_XAT_CSR) },
>
>        /* Xiroku */
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
> +               MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>                        USB_DEVICE_ID_XIROKU_SPX) },
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
> +               MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>                        USB_DEVICE_ID_XIROKU_MPX) },
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
> +               MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>                        USB_DEVICE_ID_XIROKU_CSR) },
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
> +               MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>                        USB_DEVICE_ID_XIROKU_SPX1) },
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
> +               MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>                        USB_DEVICE_ID_XIROKU_MPX1) },
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
> +               MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>                        USB_DEVICE_ID_XIROKU_CSR1) },
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
> +               MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>                        USB_DEVICE_ID_XIROKU_SPX2) },
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
> +               MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>                        USB_DEVICE_ID_XIROKU_MPX2) },
>        { .driver_data = MT_CLS_DEFAULT,
> -               HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
> +               MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>                        USB_DEVICE_ID_XIROKU_CSR2) },
>
>        /* Generic MT device */
> --
> 1.7.10
>
