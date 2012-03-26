Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab2CZNOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:14:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60054 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab2CZNOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:14:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120326124929.GA4190@redhat.com>
References: <CANeMGR5xS6GwG18q5QnKt5_pWJB4fEKFoywZDx=kA_JFVREGxw@mail.gmail.com>
 <20120326124929.GA4190@redhat.com>
From: Guan Xin <guanx.bac@gmail.com>
Date: Mon, 26 Mar 2012 15:14:00 +0200
Message-ID: <CANeMGR7-_sDbkSXKJd0svEn0R983WNoaVnDdgBU6OzBt67Db+w@mail.gmail.com>
Subject: Re: Remove over-broad module alias from zaurus.
To: Dave Jones <davej@redhat.com>, Guan Xin <guanx.bac@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8fb1f05a2d95ea04bc25280f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8fb1f05a2d95ea04bc25280f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 26, 2012 at 2:49 PM, Dave Jones <davej@redhat.com> wrote:
> On Mon, Mar 26, 2012 at 10:39:48AM +0200, Guan Xin wrote:
> =C2=A0> > On Fri, 17 Jun 2011 20:02:10 -0400, Dave Jones wrote:
> =C2=A0> > This module and a bunch of dependancies are getting loaded on s=
everal
> =C2=A0> > of laptops I have (probably picking up the mobile broadband dev=
ice),
> =C2=A0> > that have nothing to do with zaurus. Matching by class without
> =C2=A0> > any vendor/device pair isn't the right thing to do here, as it
> =C2=A0> > will prevent any other driver from correctly binding to it.
> =C2=A0> > (Or in the absense of a driver, will just waste time & memory b=
y
> =C2=A0> > =C2=A0unnecessarily loading modules)
> =C2=A0> >
> =C2=A0> > Signed-off-by: Dave Jones <davej@redhat.com>
> =C2=A0> > - =C2=A0USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MDL=
M,
> =C2=A0> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0USB_CDC_PROTO_NONE),
> =C2=A0> > - =C2=A0.driver_info =3D (unsigned long) &bogus_mdlm_info,
> =C2=A0> > -}, {
> =C2=A0> > =C2=A0 =C2=A0/* Motorola MOTOMAGX phones */
> =C2=A0> > =C2=A0 =C2=A0USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x6425, USB_=
CLASS_COMM,
> =C2=A0> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),
> =C2=A0>
> =C2=A0> After removal of this, my Motorola Rokr E6 (22b8:6027) cannot be =
recognized.
> =C2=A0> Can this be added back with more specific device info, just like =
the
> =C2=A0> Motorola MOTOMAGX phones?
>
> Yes, just cut-n-paste one of the other entries, change the ID,
> make sure it works and send a diff.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Dave

This patch is tested to work with 2.6.39.4 and 3.2.13.

--- a/drivers/net/usb/zaurus.c  2012-03-26 14:59:36.702998639 +0200
+++ b/drivers/net/usb/zaurus.c  2012-03-26 15:02:16.860801959 +0200
@@ -332,6 +332,11 @@
        .driver_info =3D ZAURUS_PXA_INFO,
 },
 {
+       /* Motorola Rokr E6 */
+       USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x6027, USB_CLASS_COMM,
+                       USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),
+       .driver_info =3D (unsigned long) &bogus_mdlm_info,
+}, {
        /* Motorola MOTOMAGX phones */
        USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x6425, USB_CLASS_COMM,
                        USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),

Guan

--e89a8fb1f05a2d95ea04bc25280f
Content-Type: application/octet-stream; name="zaurus.diff"
Content-Disposition: attachment; filename="zaurus.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h09jffs60

LS0tIGEvZHJpdmVycy9uZXQvdXNiL3phdXJ1cy5jCTIwMTItMDMtMjYgMTQ6NTk6MzYuNzAyOTk4
NjM5ICswMjAwCisrKyBiL2RyaXZlcnMvbmV0L3VzYi96YXVydXMuYwkyMDEyLTAzLTI2IDE1OjAy
OjE2Ljg2MDgwMTk1OSArMDIwMApAQCAtMzMyLDYgKzMzMiwxMSBAQAogCS5kcml2ZXJfaW5mbyA9
IFpBVVJVU19QWEFfSU5GTywKIH0sCiB7CisJLyogTW90b3JvbGEgUm9rciBFNiAqLworCVVTQl9E
RVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKDB4MjJiOCwgMHg2MDI3LCBVU0JfQ0xBU1NfQ09NTSwK
KwkJCVVTQl9DRENfU1VCQ0xBU1NfTURMTSwgVVNCX0NEQ19QUk9UT19OT05FKSwKKwkuZHJpdmVy
X2luZm8gPSAodW5zaWduZWQgbG9uZykgJmJvZ3VzX21kbG1faW5mbywKK30sIHsKIAkvKiBNb3Rv
cm9sYSBNT1RPTUFHWCBwaG9uZXMgKi8KIAlVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTygw
eDIyYjgsIDB4NjQyNSwgVVNCX0NMQVNTX0NPTU0sCiAJCQlVU0JfQ0RDX1NVQkNMQVNTX01ETE0s
IFVTQl9DRENfUFJPVE9fTk9ORSksCg==
--e89a8fb1f05a2d95ea04bc25280f--
