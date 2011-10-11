Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1JKDiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:38:09 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:55818 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1JKDiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:38:07 -0400
Date: Tue, 11 Oct 2011 14:37:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@googlemail.com>,
        Bastien Nocera <hadess@hadess.net>,
        Jason Gerecke <killertofu@gmail.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: linux-next: manual merge of the hid tree with Linus' tree
Message-Id: <20111011143755.68708e9f278048e12321a9e6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_14_37_55_+1100_6RW2hr+DpDRUvYut"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_14_37_55_+1100_6RW2hr+DpDRUvYut
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the hid tree got a conflict in
drivers/hid/hid-wacom.c between commit 3512069eefd3 ("Input: wacom - add
POINTER and DIRECT device properties") from Linus' tree and commit
3797ef6b6bc0 ("HID: wacom: Set input bits before registration") from the
hid tree.

I fixed it up (maybe - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hid/hid-wacom.c
index 72ca689,519f56c..0000000
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@@ -304,6 -304,46 +304,48 @@@ static int wacom_raw_event(struct hid_d
  	return 1;
  }
 =20
+ static int wacom_input_mapped(struct hid_device *hdev, struct hid_input *=
hi,
+ 	struct hid_field *field, struct hid_usage *usage, unsigned long **bit,
+ 								int *max)
+ {
+ 	struct input_dev *input =3D hi->input;
+=20
++	__set_bit(INPUT_PROP_POINTER, input->propbit);
++
+ 	/* Basics */
+ 	input->evbit[0] |=3D BIT(EV_KEY) | BIT(EV_ABS) | BIT(EV_REL);
+=20
+ 	__set_bit(REL_WHEEL, input->relbit);
+=20
+ 	__set_bit(BTN_TOOL_PEN, input->keybit);
+ 	__set_bit(BTN_TOUCH, input->keybit);
+ 	__set_bit(BTN_STYLUS, input->keybit);
+ 	__set_bit(BTN_STYLUS2, input->keybit);
+ 	__set_bit(BTN_LEFT, input->keybit);
+ 	__set_bit(BTN_RIGHT, input->keybit);
+ 	__set_bit(BTN_MIDDLE, input->keybit);
+=20
+ 	/* Pad */
+ 	input->evbit[0] |=3D BIT(EV_MSC);
+=20
+ 	__set_bit(MSC_SERIAL, input->mscbit);
+=20
+ 	__set_bit(BTN_0, input->keybit);
+ 	__set_bit(BTN_1, input->keybit);
+ 	__set_bit(BTN_TOOL_FINGER, input->keybit);
+=20
+ 	/* Distance, rubber and mouse */
+ 	__set_bit(BTN_TOOL_RUBBER, input->keybit);
+ 	__set_bit(BTN_TOOL_MOUSE, input->keybit);
+=20
+ 	input_set_abs_params(input, ABS_X, 0, 16704, 4, 0);
+ 	input_set_abs_params(input, ABS_Y, 0, 12064, 4, 0);
+ 	input_set_abs_params(input, ABS_PRESSURE, 0, 511, 0, 0);
+ 	input_set_abs_params(input, ABS_DISTANCE, 0, 32, 0, 0);
+=20
+ 	return 0;
+ }
+=20
  static int wacom_probe(struct hid_device *hdev,
  		const struct hid_device_id *id)
  {

--Signature=_Tue__11_Oct_2011_14_37_55_+1100_6RW2hr+DpDRUvYut
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOk7oTAAoJEECxmPOUX5FEyAQP/3n2KLFOEx4n40KdraseoLcj
CujWau6dXVPTXyFAflR0ab91F/vC33q7sMFqRHa7ZayX0xt6vR0Fx2skAriJlCmj
4nZqYl57UY/JFyRv7MedKhqLj8KFUnGIuh4lotuUvuZqQHC3RhiHrnsGeL4tLPQ/
1YDRBPC58FVg9IrSiKxeSG5u9oSw2Zoew+uhfOp00BDE55/Vjtfmkax0n0oT/lgj
t1g7NRo943ZJBJGiF3/tnIn5TleEPLgG6Mv6r1uicifC/UMaI1K/Y8iKh/4iY+7N
P6IT+0C//nvif8hHrijDHeH0d4DkcEe30HgbLgtMuB2v9YoFaFUXBQkdcXSeGfzH
dqt5zOkIxjYecBLbcPjbUGGgJKAaofE8bdjznR12lMgbQLZt9LUqhBQbS28lfWG8
KUmn4PWyIGvciPIi5q7QWD/7dGBSOHT/mjuu7HUkuIfeEBRYJEx1FUmwkDp2DbdB
bNYoWiHrIXOlPLHsUksEzf7UKT1ybfFaFEjjFaLK6Z4wDmlEfmUQQNm4f12u4oO1
9iTNMrk32+uzzNWThqgtIiyIS4wyeceuvAWhfmaujaZYKuv1b6odssWaSDzswlim
7L7J5c2QtLqsTRTy7fG38moIir+qix8up5RuL4gwbMCWRGC1Yw5vX02s1v9T9a+d
axrHoePuRRBQM8aBOMle
=04TZ
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_14_37_55_+1100_6RW2hr+DpDRUvYut--
