Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab1DTJyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:54:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64096 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1DTJyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=EMXh1lm/77/YHdoEKJ/DWZ4zVn/BdSTddSlOhjf7nSzjhEkce0M2oSYiA7PhYrAsxR
         J17stJQdYWKbzzV7Hh8Ch8vLERjuI6Xfhw/E1IGrnLNtbbgWB02YFuDRg96h8r48t3xl
         9hIFnTigisgiN7Kfpym71ZXWa/VgXh7uh0pM8=
MIME-Version: 1.0
In-Reply-To: <20110420094700.GA2258@polaris.bitmath.org>
References: <1303291155-3148-1-git-send-email-salt@salt.com.tw>
	<20110420094700.GA2258@polaris.bitmath.org>
Date: Wed, 20 Apr 2011 11:54:07 +0200
X-Google-Sender-Auth: FW58HioS9geIi05qzno-gk3rY_s
Message-ID: <BANLkTin7Q3fD3vg90qCk12MGaVEvLBe0Mg@mail.gmail.com>
Subject: Re: [PATCH] HID: add support for PenMount dual-touch panel
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>,
        Richard Nauber <richard.nauber@googlemail.com>
Cc: PenMount <penmount.touch@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        PenMount <salt@salt.com.tw>
Content-Type: multipart/mixed; boundary=90e6ba4763af07baab04a1569b11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba4763af07baab04a1569b11
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Henrik,



On Wed, Apr 20, 2011 at 11:47, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi,
>
> thanks for the patch. Please find comments inline.
>
> On Wed, Apr 20, 2011 at 05:19:15PM +0800, PenMount wrote:
>> This patch adds PenMount support to hid-multitouch.
>> A new class MT_CLS_CONFIDENCE_SERIAL_MODE is defined for PenMount,
>> since it uses HID_DG_CONFIDENCE as the valid flag.
>> A new quirk MT_QUIRK_SERIAL_REPORT_MODE is defined,
>> since PenMount uses serial reporting mode and there is no
>> HID_DG_CONTACTCOUNT usage in it's report descriptor.
>>
>> Signed-off-by: PenMount <salt@salt.com.tw>
>> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>> =A0drivers/hid/Kconfig =A0 =A0 =A0 =A0 =A0| =A0 =A01 +
>> =A0drivers/hid/hid-core.c =A0 =A0 =A0 | =A0 =A01 +
>> =A0drivers/hid/hid-ids.h =A0 =A0 =A0 =A0| =A0 =A03 +++
>> =A0drivers/hid/hid-multitouch.c | =A0 14 ++++++++++++++
>> =A04 files changed, 19 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
>> index 996ae3a..8058cf1 100644
>> --- a/drivers/hid/Kconfig
>> +++ b/drivers/hid/Kconfig
>> @@ -313,6 +313,7 @@ config HID_MULTITOUCH
>> =A0 =A0 =A0 =A0 - Cypress TrueTouch panels
>> =A0 =A0 =A0 =A0 - Hanvon dual touch panels
>> =A0 =A0 =A0 =A0 - IrTouch Infrared USB panels
>> + =A0 =A0 =A0 - PenMount dual touch panels
>> =A0 =A0 =A0 =A0 - Pixcir dual touch panels
>> =A0 =A0 =A0 =A0 - 'Sensing Win7-TwoFinger' panel by GeneralTouch
>> =A0 =A0 =A0 =A0 =A0 =A0- eGalax dual-touch panels, including the
>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> index c3d6626..6e31b9f 100644
>> --- a/drivers/hid/hid-core.c
>> +++ b/drivers/hid/hid-core.c
>> @@ -1438,6 +1438,7 @@ static const struct hid_device_id hid_have_special=
_driver[] =3D {
>> =A0 =A0 =A0 { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TO=
UCH_SCREEN_18) },
>> =A0 =A0 =A0 { HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_PK=
B1700) },
>> =A0 =A0 =A0 { HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WK=
B2000) },
>> + =A0 =A0 { HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUN=
T_PCI) },
>> =A0 =A0 =A0 { HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETAL=
YNX_MAXTER_REMOTE) },
>> =A0 =A0 =A0 { HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_=
OPTICAL_TOUCH) },
>> =A0 =A0 =A0 { HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_=
IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
>> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>> index d485894..a4d0505 100644
>> --- a/drivers/hid/hid-ids.h
>> +++ b/drivers/hid/hid-ids.h
>> @@ -487,6 +487,9 @@
>> =A0#define USB_VENDOR_ID_PETALYNX =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x18b1
>> =A0#define USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE 0x0037
>>
>> +#define USB_VENDOR_ID_PENMOUNT =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x14e1
>> +#define USB_DEVICE_ID_PENMOUNT_PCI =A0 0x3500
>> +
>> =A0#define USB_VENDOR_ID_PHILIPS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x0471
>> =A0#define USB_DEVICE_ID_PHILIPS_IEEE802154_DONGLE 0x0617
>>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index 0175f85..c88d96d 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -50,6 +50,7 @@ MODULE_LICENSE("GPL");
>> =A0#define MT_QUIRK_VALID_IS_INRANGE =A0 =A0(1 << 4)
>> =A0#define MT_QUIRK_VALID_IS_CONFIDENCE (1 << 5)
>> =A0#define MT_QUIRK_EGALAX_XYZ_FIXUP =A0 =A0(1 << 6)
>> +#define MT_QUIRK_SERIAL_REPORT_MODE =A0(1 << 7)
>>
>> =A0struct mt_slot {
>> =A0 =A0 =A0 __s32 x, y, p, w, h;
>> @@ -89,6 +90,7 @@ struct mt_class {
>> =A0#define MT_CLS_EGALAX =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A05
>> =A0#define MT_CLS_STANTUM =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 6
>> =A0#define MT_CLS_3M =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A07
>> +#define MT_CLS_CONFIDENCE_SERIAL_MODE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A08
>>
>> =A0#define MT_DEFAULT_MAXCONTACT =A0 =A0 =A0 =A010
>>
>> @@ -156,6 +158,9 @@ struct mt_class mt_classes[] =3D {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 .sn_move =3D 2048,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 .sn_width =3D 128,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 .sn_height =3D 128 },
>> + =A0 =A0 { .name =3D MT_CLS_CONFIDENCE_SERIAL_MODE,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .quirks =3D MT_QUIRK_VALID_IS_CONFIDENCE |
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MT_QUIRK_SERIAL_REPORT_MODE },
>>
>> =A0 =A0 =A0 { }
>> =A0};
>> @@ -196,6 +201,10 @@ static int mt_input_mapping(struct hid_device *hdev=
, struct hid_input *hi,
>> =A0 =A0 =A0 struct mt_class *cls =3D td->mtclass;
>> =A0 =A0 =A0 __s32 quirks =3D cls->quirks;
>>
>> + =A0 =A0 if ((quirks & MT_QUIRK_SERIAL_REPORT_MODE) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 (!td->last_field_index))
>> + =A0 =A0 =A0 =A0 =A0 =A0 td->last_field_index =3D field->report->maxfie=
ld - 1;
>> +
>
> Are the events not emitted automatically per touch, if the lines above ar=
e omitted?
>
>> =A0 =A0 =A0 switch (usage->hid & HID_USAGE_PAGE) {
>>
>> =A0 =A0 =A0 case HID_UP_GENDESK:
>> @@ -585,6 +594,11 @@ static const struct hid_device_id mt_devices[] =3D =
{
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 USB_DEVICE_ID_IRTOUCH_INFRAR=
ED_USB) },
>>
>> + =A0 =A0 /* PenMount panels */
>> + =A0 =A0 { =A0.driver_data =3D MT_CLS_CONFIDENCE_SERIAL_MODE,
>> + =A0 =A0 =A0 =A0 =A0 =A0 HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 USB_DEVICE_ID_PENMOUNT_PCI) },
>> +
>> =A0 =A0 =A0 /* PixCir-based panels */
>> =A0 =A0 =A0 { .driver_data =3D MT_CLS_DUAL_INRANGE_CONTACTID,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
>> --
>> 1.7.4.1
>>
>
> Benjamin: Since field->index =3D=3D 0 is in use, it seems the driver coul=
d
> execute event emission wrongly under some circumstances (when
> last_field_index =3D=3D 0). Is that related to the reason for the quirk i=
n
> this patch?

In fact, I have a second patch just on top of this one. It has been
tested by Ryan with PenMount devices.
I was waiting for Penmount to be included first as it does not impact
any other drivers.

I inline the code here, but my gmail client will destroy tabs (so I
attached it too)....

Can you test it against 3M?

Richard, can you test it (after applying the PenMount patch) too?

Thanks,
Benjamin

>From ac6b68d27b70e91846f2179d15804144dfab8bc1 Mon Sep 17 00:00:00 2001
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Date: Tue, 19 Apr 2011 11:49:44 +0200
Subject: [PATCH] HID: hid-multitouch: refactor last_field_index

the current implementation requires the devices to report
HID_DG_CONTACTCOUNT to set the last_field_index value.
However, devices reporting in serial mode (DWAV and PenMount)
do not send this field.
Other devices (3M) add other fields in the reports descriptor
that are not multitouch related at the end, thus the need to
add a special case in the default case when handling events.

A first work around has been set up but with PenMount devices,
we have reached the limit.

The idea is to calculate the last_field_index by relying only on
multitouch fields the device send. This allows us to remove
the handling of non-multitouch events in hid-multitouch, and
guarantee that the function mt_emit_event is always called.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |   37 +++++++++++++++----------------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 5d4ba79..51b5d27 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -50,7 +50,6 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_VALID_IS_INRANGE	(1 << 4)
 #define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 5)
 #define MT_QUIRK_EGALAX_XYZ_FIXUP	(1 << 6)
-#define MT_QUIRK_SERIAL_REPORT_MODE	(1 << 7)

 struct mt_slot {
 	__s32 x, y, p, w, h;
@@ -90,7 +89,7 @@ struct mt_class {
 #define MT_CLS_EGALAX				5
 #define MT_CLS_STANTUM				6
 #define MT_CLS_3M				7
-#define MT_CLS_CONFIDENCE_SERIAL_MODE		8
+#define MT_CLS_CONFIDENCE			8

 #define MT_DEFAULT_MAXCONTACT	10

@@ -158,9 +157,8 @@ struct mt_class mt_classes[] =3D {
 		.sn_move =3D 2048,
 		.sn_width =3D 128,
 		.sn_height =3D 128 },
-	{ .name =3D MT_CLS_CONFIDENCE_SERIAL_MODE,
-		.quirks =3D MT_QUIRK_VALID_IS_CONFIDENCE |
-			MT_QUIRK_SERIAL_REPORT_MODE },
+	{ .name =3D MT_CLS_CONFIDENCE,
+		.quirks =3D MT_QUIRK_VALID_IS_CONFIDENCE },

 	{ }
 };
@@ -201,10 +199,6 @@ static int mt_input_mapping(struct hid_device
*hdev, struct hid_input *hi,
 	struct mt_class *cls =3D td->mtclass;
 	__s32 quirks =3D cls->quirks;

-	if ((quirks & MT_QUIRK_SERIAL_REPORT_MODE) &&
-		(!td->last_field_index))
-		td->last_field_index =3D field->report->maxfield - 1;
-
 	switch (usage->hid & HID_USAGE_PAGE) {

 	case HID_UP_GENDESK:
@@ -219,6 +213,7 @@ static int mt_input_mapping(struct hid_device
*hdev, struct hid_input *hi,
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_X, field, cls->sn_move);
 			td->last_slot_field =3D usage->hid;
+			td->last_field_index =3D field->index;
 			return 1;
 		case HID_GD_Y:
 			if (quirks & MT_QUIRK_EGALAX_XYZ_FIXUP)
@@ -230,6 +225,7 @@ static int mt_input_mapping(struct hid_device
*hdev, struct hid_input *hi,
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_Y, field, cls->sn_move);
 			td->last_slot_field =3D usage->hid;
+			td->last_field_index =3D field->index;
 			return 1;
 		}
 		return 0;
@@ -238,18 +234,22 @@ static int mt_input_mapping(struct hid_device
*hdev, struct hid_input *hi,
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
 			td->last_slot_field =3D usage->hid;
+			td->last_field_index =3D field->index;
 			return 1;
 		case HID_DG_CONFIDENCE:
 			td->last_slot_field =3D usage->hid;
+			td->last_field_index =3D field->index;
 			return 1;
 		case HID_DG_TIPSWITCH:
 			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
 			input_set_capability(hi->input, EV_KEY, BTN_TOUCH);
 			td->last_slot_field =3D usage->hid;
+			td->last_field_index =3D field->index;
 			return 1;
 		case HID_DG_CONTACTID:
 			input_mt_init_slots(hi->input, td->maxcontacts);
 			td->last_slot_field =3D usage->hid;
+			td->last_field_index =3D field->index;
 			return 1;
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
@@ -257,6 +257,7 @@ static int mt_input_mapping(struct hid_device
*hdev, struct hid_input *hi,
 			set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
 				cls->sn_width);
 			td->last_slot_field =3D usage->hid;
+			td->last_field_index =3D field->index;
 			return 1;
 		case HID_DG_HEIGHT:
 			hid_map_usage(hi, usage, bit, max,
@@ -266,6 +267,7 @@ static int mt_input_mapping(struct hid_device
*hdev, struct hid_input *hi,
 			input_set_abs_params(hi->input,
 					ABS_MT_ORIENTATION, 0, 1, 0, 0);
 			td->last_slot_field =3D usage->hid;
+			td->last_field_index =3D field->index;
 			return 1;
 		case HID_DG_TIPPRESSURE:
 			if (quirks & MT_QUIRK_EGALAX_XYZ_FIXUP)
@@ -278,13 +280,15 @@ static int mt_input_mapping(struct hid_device
*hdev, struct hid_input *hi,
 			set_abs(hi->input, ABS_PRESSURE, field,
 				cls->sn_pressure);
 			td->last_slot_field =3D usage->hid;
+			td->last_field_index =3D field->index;
 			return 1;
 		case HID_DG_CONTACTCOUNT:
-			td->last_field_index =3D field->report->maxfield - 1;
+			td->last_field_index =3D field->index;
 			return 1;
 		case HID_DG_CONTACTMAX:
 			/* we don't set td->last_slot_field as contactcount and
 			 * contact max are global to the report */
+			td->last_field_index =3D field->index;
 			return -1;
 		}
 		/* let hid-input decide for the others */
@@ -433,23 +437,12 @@ static int mt_event(struct hid_device *hid,
struct hid_field *field,
 			break;

 		default:
-			if (td->last_field_index
-				&& field->index =3D=3D td->last_field_index)
-				/* we reach here when the last field in the
-				 * report is not related to multitouch.
-				 * This is not good. As a temporary solution,
-				 * we trigger our mt event completion and
-				 * ignore the field.
-				 */
-				break;
 			/* fallback to the generic hidinput handling */
 			return 0;
 		}

 		if (usage->hid =3D=3D td->last_slot_field) {
 			mt_complete_slot(td);
-			if (!td->last_field_index)
-				mt_emit_event(td, field->hidinput->input);
 		}

 		if (field->index =3D=3D td->last_field_index
@@ -595,7 +588,7 @@ static const struct hid_device_id mt_devices[] =3D {
 			USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },

 	/* PenMount panels */
-	{ .driver_data =3D MT_CLS_CONFIDENCE_SERIAL_MODE,
+	{ .driver_data =3D MT_CLS_CONFIDENCE,
 		HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
 			USB_DEVICE_ID_PENMOUNT_PCI) },

--=20
1.7.4.2

--90e6ba4763af07baab04a1569b11
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-HID-hid-multitouch-refactor-last_field_index.patch"
Content-Disposition: attachment; 
	filename="0001-HID-hid-multitouch-refactor-last_field_index.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmq2xp460

RnJvbSBhYzZiNjhkMjdiNzBlOTE4NDZmMjE3OWQxNTgwNDE0NGRmYWI4YmMxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCZW5qYW1pbiBUaXNzb2lyZXMgPGJlbmphbWluLnRpc3NvaXJl
c0BlbmFjLmZyPgpEYXRlOiBUdWUsIDE5IEFwciAyMDExIDExOjQ5OjQ0ICswMjAwClN1YmplY3Q6
IFtQQVRDSF0gSElEOiBoaWQtbXVsdGl0b3VjaDogcmVmYWN0b3IgbGFzdF9maWVsZF9pbmRleAoK
dGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24gcmVxdWlyZXMgdGhlIGRldmljZXMgdG8gcmVwb3J0
CkhJRF9ER19DT05UQUNUQ09VTlQgdG8gc2V0IHRoZSBsYXN0X2ZpZWxkX2luZGV4IHZhbHVlLgpI
b3dldmVyLCBkZXZpY2VzIHJlcG9ydGluZyBpbiBzZXJpYWwgbW9kZSAoRFdBViBhbmQgUGVuTW91
bnQpCmRvIG5vdCBzZW5kIHRoaXMgZmllbGQuCk90aGVyIGRldmljZXMgKDNNKSBhZGQgb3RoZXIg
ZmllbGRzIGluIHRoZSByZXBvcnRzIGRlc2NyaXB0b3IKdGhhdCBhcmUgbm90IG11bHRpdG91Y2gg
cmVsYXRlZCBhdCB0aGUgZW5kLCB0aHVzIHRoZSBuZWVkIHRvCmFkZCBhIHNwZWNpYWwgY2FzZSBp
biB0aGUgZGVmYXVsdCBjYXNlIHdoZW4gaGFuZGxpbmcgZXZlbnRzLgoKQSBmaXJzdCB3b3JrIGFy
b3VuZCBoYXMgYmVlbiBzZXQgdXAgYnV0IHdpdGggUGVuTW91bnQgZGV2aWNlcywKd2UgaGF2ZSBy
ZWFjaGVkIHRoZSBsaW1pdC4KClRoZSBpZGVhIGlzIHRvIGNhbGN1bGF0ZSB0aGUgbGFzdF9maWVs
ZF9pbmRleCBieSByZWx5aW5nIG9ubHkgb24KbXVsdGl0b3VjaCBmaWVsZHMgdGhlIGRldmljZSBz
ZW5kLiBUaGlzIGFsbG93cyB1cyB0byByZW1vdmUKdGhlIGhhbmRsaW5nIG9mIG5vbi1tdWx0aXRv
dWNoIGV2ZW50cyBpbiBoaWQtbXVsdGl0b3VjaCwgYW5kCmd1YXJhbnRlZSB0aGF0IHRoZSBmdW5j
dGlvbiBtdF9lbWl0X2V2ZW50IGlzIGFsd2F5cyBjYWxsZWQuCgpTaWduZWQtb2ZmLWJ5OiBCZW5q
YW1pbiBUaXNzb2lyZXMgPGJlbmphbWluLnRpc3NvaXJlc0BlbmFjLmZyPgotLS0KIGRyaXZlcnMv
aGlkL2hpZC1tdWx0aXRvdWNoLmMgfCAgIDM3ICsrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgMjIgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9oaWQvaGlkLW11bHRpdG91Y2guYyBiL2RyaXZlcnMv
aGlkL2hpZC1tdWx0aXRvdWNoLmMKaW5kZXggNWQ0YmE3OS4uNTFiNWQyNyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9oaWQvaGlkLW11bHRpdG91Y2guYworKysgYi9kcml2ZXJzL2hpZC9oaWQtbXVsdGl0
b3VjaC5jCkBAIC01MCw3ICs1MCw2IEBAIE1PRFVMRV9MSUNFTlNFKCJHUEwiKTsKICNkZWZpbmUg
TVRfUVVJUktfVkFMSURfSVNfSU5SQU5HRQkoMSA8PCA0KQogI2RlZmluZSBNVF9RVUlSS19WQUxJ
RF9JU19DT05GSURFTkNFCSgxIDw8IDUpCiAjZGVmaW5lIE1UX1FVSVJLX0VHQUxBWF9YWVpfRklY
VVAJKDEgPDwgNikKLSNkZWZpbmUgTVRfUVVJUktfU0VSSUFMX1JFUE9SVF9NT0RFCSgxIDw8IDcp
CiAKIHN0cnVjdCBtdF9zbG90IHsKIAlfX3MzMiB4LCB5LCBwLCB3LCBoOwpAQCAtOTAsNyArODks
NyBAQCBzdHJ1Y3QgbXRfY2xhc3MgewogI2RlZmluZSBNVF9DTFNfRUdBTEFYCQkJCTUKICNkZWZp
bmUgTVRfQ0xTX1NUQU5UVU0JCQkJNgogI2RlZmluZSBNVF9DTFNfM00JCQkJNwotI2RlZmluZSBN
VF9DTFNfQ09ORklERU5DRV9TRVJJQUxfTU9ERQkJOAorI2RlZmluZSBNVF9DTFNfQ09ORklERU5D
RQkJCTgKIAogI2RlZmluZSBNVF9ERUZBVUxUX01BWENPTlRBQ1QJMTAKIApAQCAtMTU4LDkgKzE1
Nyw4IEBAIHN0cnVjdCBtdF9jbGFzcyBtdF9jbGFzc2VzW10gPSB7CiAJCS5zbl9tb3ZlID0gMjA0
OCwKIAkJLnNuX3dpZHRoID0gMTI4LAogCQkuc25faGVpZ2h0ID0gMTI4IH0sCi0JeyAubmFtZSA9
IE1UX0NMU19DT05GSURFTkNFX1NFUklBTF9NT0RFLAotCQkucXVpcmtzID0gTVRfUVVJUktfVkFM
SURfSVNfQ09ORklERU5DRSB8Ci0JCQlNVF9RVUlSS19TRVJJQUxfUkVQT1JUX01PREUgfSwKKwl7
IC5uYW1lID0gTVRfQ0xTX0NPTkZJREVOQ0UsCisJCS5xdWlya3MgPSBNVF9RVUlSS19WQUxJRF9J
U19DT05GSURFTkNFIH0sCiAKIAl7IH0KIH07CkBAIC0yMDEsMTAgKzE5OSw2IEBAIHN0YXRpYyBp
bnQgbXRfaW5wdXRfbWFwcGluZyhzdHJ1Y3QgaGlkX2RldmljZSAqaGRldiwgc3RydWN0IGhpZF9p
bnB1dCAqaGksCiAJc3RydWN0IG10X2NsYXNzICpjbHMgPSB0ZC0+bXRjbGFzczsKIAlfX3MzMiBx
dWlya3MgPSBjbHMtPnF1aXJrczsKIAotCWlmICgocXVpcmtzICYgTVRfUVVJUktfU0VSSUFMX1JF
UE9SVF9NT0RFKSAmJgotCQkoIXRkLT5sYXN0X2ZpZWxkX2luZGV4KSkKLQkJdGQtPmxhc3RfZmll
bGRfaW5kZXggPSBmaWVsZC0+cmVwb3J0LT5tYXhmaWVsZCAtIDE7Ci0KIAlzd2l0Y2ggKHVzYWdl
LT5oaWQgJiBISURfVVNBR0VfUEFHRSkgewogCiAJY2FzZSBISURfVVBfR0VOREVTSzoKQEAgLTIx
OSw2ICsyMTMsNyBAQCBzdGF0aWMgaW50IG10X2lucHV0X21hcHBpbmcoc3RydWN0IGhpZF9kZXZp
Y2UgKmhkZXYsIHN0cnVjdCBoaWRfaW5wdXQgKmhpLAogCQkJLyogdG91Y2hzY3JlZW4gZW11bGF0
aW9uICovCiAJCQlzZXRfYWJzKGhpLT5pbnB1dCwgQUJTX1gsIGZpZWxkLCBjbHMtPnNuX21vdmUp
OwogCQkJdGQtPmxhc3Rfc2xvdF9maWVsZCA9IHVzYWdlLT5oaWQ7CisJCQl0ZC0+bGFzdF9maWVs
ZF9pbmRleCA9IGZpZWxkLT5pbmRleDsKIAkJCXJldHVybiAxOwogCQljYXNlIEhJRF9HRF9ZOgog
CQkJaWYgKHF1aXJrcyAmIE1UX1FVSVJLX0VHQUxBWF9YWVpfRklYVVApCkBAIC0yMzAsNiArMjI1
LDcgQEAgc3RhdGljIGludCBtdF9pbnB1dF9tYXBwaW5nKHN0cnVjdCBoaWRfZGV2aWNlICpoZGV2
LCBzdHJ1Y3QgaGlkX2lucHV0ICpoaSwKIAkJCS8qIHRvdWNoc2NyZWVuIGVtdWxhdGlvbiAqLwog
CQkJc2V0X2FicyhoaS0+aW5wdXQsIEFCU19ZLCBmaWVsZCwgY2xzLT5zbl9tb3ZlKTsKIAkJCXRk
LT5sYXN0X3Nsb3RfZmllbGQgPSB1c2FnZS0+aGlkOworCQkJdGQtPmxhc3RfZmllbGRfaW5kZXgg
PSBmaWVsZC0+aW5kZXg7CiAJCQlyZXR1cm4gMTsKIAkJfQogCQlyZXR1cm4gMDsKQEAgLTIzOCwx
OCArMjM0LDIyIEBAIHN0YXRpYyBpbnQgbXRfaW5wdXRfbWFwcGluZyhzdHJ1Y3QgaGlkX2Rldmlj
ZSAqaGRldiwgc3RydWN0IGhpZF9pbnB1dCAqaGksCiAJCXN3aXRjaCAodXNhZ2UtPmhpZCkgewog
CQljYXNlIEhJRF9ER19JTlJBTkdFOgogCQkJdGQtPmxhc3Rfc2xvdF9maWVsZCA9IHVzYWdlLT5o
aWQ7CisJCQl0ZC0+bGFzdF9maWVsZF9pbmRleCA9IGZpZWxkLT5pbmRleDsKIAkJCXJldHVybiAx
OwogCQljYXNlIEhJRF9ER19DT05GSURFTkNFOgogCQkJdGQtPmxhc3Rfc2xvdF9maWVsZCA9IHVz
YWdlLT5oaWQ7CisJCQl0ZC0+bGFzdF9maWVsZF9pbmRleCA9IGZpZWxkLT5pbmRleDsKIAkJCXJl
dHVybiAxOwogCQljYXNlIEhJRF9ER19USVBTV0lUQ0g6CiAJCQloaWRfbWFwX3VzYWdlKGhpLCB1
c2FnZSwgYml0LCBtYXgsIEVWX0tFWSwgQlROX1RPVUNIKTsKIAkJCWlucHV0X3NldF9jYXBhYmls
aXR5KGhpLT5pbnB1dCwgRVZfS0VZLCBCVE5fVE9VQ0gpOwogCQkJdGQtPmxhc3Rfc2xvdF9maWVs
ZCA9IHVzYWdlLT5oaWQ7CisJCQl0ZC0+bGFzdF9maWVsZF9pbmRleCA9IGZpZWxkLT5pbmRleDsK
IAkJCXJldHVybiAxOwogCQljYXNlIEhJRF9ER19DT05UQUNUSUQ6CiAJCQlpbnB1dF9tdF9pbml0
X3Nsb3RzKGhpLT5pbnB1dCwgdGQtPm1heGNvbnRhY3RzKTsKIAkJCXRkLT5sYXN0X3Nsb3RfZmll
bGQgPSB1c2FnZS0+aGlkOworCQkJdGQtPmxhc3RfZmllbGRfaW5kZXggPSBmaWVsZC0+aW5kZXg7
CiAJCQlyZXR1cm4gMTsKIAkJY2FzZSBISURfREdfV0lEVEg6CiAJCQloaWRfbWFwX3VzYWdlKGhp
LCB1c2FnZSwgYml0LCBtYXgsCkBAIC0yNTcsNiArMjU3LDcgQEAgc3RhdGljIGludCBtdF9pbnB1
dF9tYXBwaW5nKHN0cnVjdCBoaWRfZGV2aWNlICpoZGV2LCBzdHJ1Y3QgaGlkX2lucHV0ICpoaSwK
IAkJCXNldF9hYnMoaGktPmlucHV0LCBBQlNfTVRfVE9VQ0hfTUFKT1IsIGZpZWxkLAogCQkJCWNs
cy0+c25fd2lkdGgpOwogCQkJdGQtPmxhc3Rfc2xvdF9maWVsZCA9IHVzYWdlLT5oaWQ7CisJCQl0
ZC0+bGFzdF9maWVsZF9pbmRleCA9IGZpZWxkLT5pbmRleDsKIAkJCXJldHVybiAxOwogCQljYXNl
IEhJRF9ER19IRUlHSFQ6CiAJCQloaWRfbWFwX3VzYWdlKGhpLCB1c2FnZSwgYml0LCBtYXgsCkBA
IC0yNjYsNiArMjY3LDcgQEAgc3RhdGljIGludCBtdF9pbnB1dF9tYXBwaW5nKHN0cnVjdCBoaWRf
ZGV2aWNlICpoZGV2LCBzdHJ1Y3QgaGlkX2lucHV0ICpoaSwKIAkJCWlucHV0X3NldF9hYnNfcGFy
YW1zKGhpLT5pbnB1dCwKIAkJCQkJQUJTX01UX09SSUVOVEFUSU9OLCAwLCAxLCAwLCAwKTsKIAkJ
CXRkLT5sYXN0X3Nsb3RfZmllbGQgPSB1c2FnZS0+aGlkOworCQkJdGQtPmxhc3RfZmllbGRfaW5k
ZXggPSBmaWVsZC0+aW5kZXg7CiAJCQlyZXR1cm4gMTsKIAkJY2FzZSBISURfREdfVElQUFJFU1NV
UkU6CiAJCQlpZiAocXVpcmtzICYgTVRfUVVJUktfRUdBTEFYX1hZWl9GSVhVUCkKQEAgLTI3OCwx
MyArMjgwLDE1IEBAIHN0YXRpYyBpbnQgbXRfaW5wdXRfbWFwcGluZyhzdHJ1Y3QgaGlkX2Rldmlj
ZSAqaGRldiwgc3RydWN0IGhpZF9pbnB1dCAqaGksCiAJCQlzZXRfYWJzKGhpLT5pbnB1dCwgQUJT
X1BSRVNTVVJFLCBmaWVsZCwKIAkJCQljbHMtPnNuX3ByZXNzdXJlKTsKIAkJCXRkLT5sYXN0X3Ns
b3RfZmllbGQgPSB1c2FnZS0+aGlkOworCQkJdGQtPmxhc3RfZmllbGRfaW5kZXggPSBmaWVsZC0+
aW5kZXg7CiAJCQlyZXR1cm4gMTsKIAkJY2FzZSBISURfREdfQ09OVEFDVENPVU5UOgotCQkJdGQt
Pmxhc3RfZmllbGRfaW5kZXggPSBmaWVsZC0+cmVwb3J0LT5tYXhmaWVsZCAtIDE7CisJCQl0ZC0+
bGFzdF9maWVsZF9pbmRleCA9IGZpZWxkLT5pbmRleDsKIAkJCXJldHVybiAxOwogCQljYXNlIEhJ
RF9ER19DT05UQUNUTUFYOgogCQkJLyogd2UgZG9uJ3Qgc2V0IHRkLT5sYXN0X3Nsb3RfZmllbGQg
YXMgY29udGFjdGNvdW50IGFuZAogCQkJICogY29udGFjdCBtYXggYXJlIGdsb2JhbCB0byB0aGUg
cmVwb3J0ICovCisJCQl0ZC0+bGFzdF9maWVsZF9pbmRleCA9IGZpZWxkLT5pbmRleDsKIAkJCXJl
dHVybiAtMTsKIAkJfQogCQkvKiBsZXQgaGlkLWlucHV0IGRlY2lkZSBmb3IgdGhlIG90aGVycyAq
LwpAQCAtNDMzLDIzICs0MzcsMTIgQEAgc3RhdGljIGludCBtdF9ldmVudChzdHJ1Y3QgaGlkX2Rl
dmljZSAqaGlkLCBzdHJ1Y3QgaGlkX2ZpZWxkICpmaWVsZCwKIAkJCWJyZWFrOwogCiAJCWRlZmF1
bHQ6Ci0JCQlpZiAodGQtPmxhc3RfZmllbGRfaW5kZXgKLQkJCQkmJiBmaWVsZC0+aW5kZXggPT0g
dGQtPmxhc3RfZmllbGRfaW5kZXgpCi0JCQkJLyogd2UgcmVhY2ggaGVyZSB3aGVuIHRoZSBsYXN0
IGZpZWxkIGluIHRoZQotCQkJCSAqIHJlcG9ydCBpcyBub3QgcmVsYXRlZCB0byBtdWx0aXRvdWNo
LgotCQkJCSAqIFRoaXMgaXMgbm90IGdvb2QuIEFzIGEgdGVtcG9yYXJ5IHNvbHV0aW9uLAotCQkJ
CSAqIHdlIHRyaWdnZXIgb3VyIG10IGV2ZW50IGNvbXBsZXRpb24gYW5kCi0JCQkJICogaWdub3Jl
IHRoZSBmaWVsZC4KLQkJCQkgKi8KLQkJCQlicmVhazsKIAkJCS8qIGZhbGxiYWNrIHRvIHRoZSBn
ZW5lcmljIGhpZGlucHV0IGhhbmRsaW5nICovCiAJCQlyZXR1cm4gMDsKIAkJfQogCiAJCWlmICh1
c2FnZS0+aGlkID09IHRkLT5sYXN0X3Nsb3RfZmllbGQpIHsKIAkJCW10X2NvbXBsZXRlX3Nsb3Qo
dGQpOwotCQkJaWYgKCF0ZC0+bGFzdF9maWVsZF9pbmRleCkKLQkJCQltdF9lbWl0X2V2ZW50KHRk
LCBmaWVsZC0+aGlkaW5wdXQtPmlucHV0KTsKIAkJfQogCiAJCWlmIChmaWVsZC0+aW5kZXggPT0g
dGQtPmxhc3RfZmllbGRfaW5kZXgKQEAgLTU5NSw3ICs1ODgsNyBAQCBzdGF0aWMgY29uc3Qgc3Ry
dWN0IGhpZF9kZXZpY2VfaWQgbXRfZGV2aWNlc1tdID0gewogCQkJVVNCX0RFVklDRV9JRF9JUlRP
VUNIX0lORlJBUkVEX1VTQikgfSwKIAogCS8qIFBlbk1vdW50IHBhbmVscyAqLwotCXsgLmRyaXZl
cl9kYXRhID0gTVRfQ0xTX0NPTkZJREVOQ0VfU0VSSUFMX01PREUsCisJeyAuZHJpdmVyX2RhdGEg
PSBNVF9DTFNfQ09ORklERU5DRSwKIAkJSElEX1VTQl9ERVZJQ0UoVVNCX1ZFTkRPUl9JRF9QRU5N
T1VOVCwKIAkJCVVTQl9ERVZJQ0VfSURfUEVOTU9VTlRfUENJKSB9LAogCi0tIAoxLjcuNC4yCgo=
--90e6ba4763af07baab04a1569b11--
