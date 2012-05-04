Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab2EDL7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 07:59:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51629 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab2EDL7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 07:59:49 -0400
MIME-Version: 1.0
In-Reply-To: <1336056176-2508-1-git-send-email-rydberg@euromail.se>
References: <1336056176-2508-1-git-send-email-rydberg@euromail.se>
Date: Fri, 4 May 2012 13:59:48 +0200
Message-ID: <CAN+gG=FSg+eZxGUY1BU0k_mkxiPZQ9BHuqUb00NTij_JWbDUcA@mail.gmail.com>
Subject: Re: [PATCH] HID: hid-multitouch: Only match MT interfaces
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

thanks for submitting this.

On Thu, May 3, 2012 at 4:42 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> All known hid-multitouch devices currently match any device group.
> However, some devices present interfaces belonging to different groups,
> resulting in a race between the hid-generic and hid-multitouch modules.
> This patch narrows the MT device list to match only HID_GROUP_MULTITOUCH,
> which solves the problem.
>
> Reported-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hid/hid-multitouch.c |  145 +++++++++++++++++++++---------------------
>  1 file changed, 74 insertions(+), 71 deletions(-)
>
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index ea465f1..20e9552 100644
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
> @@ -735,276 +738,276 @@ static const struct hid_device_id mt_devices[] = {
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

You are missing /* Baanto multitouch devices */ here. Please use the
branch for-next of Jiri....

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
>        { .driver_data = MT_CLS_CYPRESS,
> -               HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
> +               MT_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
>                        USB_DEVICE_ID_CYPRESS_TRUETOUCH) },

Please keep the HID_USB_DEVICE for this at least as I don't want to
expose the other interfaces of this particular device (they'll get the
same name than the multitouch one, which may confuse the end-user).

Thanks,
Benjamin


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
