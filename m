Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1FTRex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:34:53 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:48298 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755565Ab1FTRew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:34:52 -0400
Date: Mon, 20 Jun 2011 20:34:45 +0300
From: Felipe Balbi <balbi@ti.com>
To: Viliam Mateicka <viliam.mateicka@gmail.com>
Cc: balbi@ti.com, Skacore Systems <skacore.systems@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s3c2410_udc: fix custom UDC command handling
Message-ID: <20110620173444.GG26623@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <Pine.LNX.4.44L0.1106201105430.2113-100000@iolanthe.rowland.org>
 <20110620151522.GN14262@legolas.emea.dhcp.ti.com>
 <BANLkTi=5S6bWs3jr9hTsg2=LXh4xKAprUA@mail.gmail.com>
 <20110620153645.GQ14262@legolas.emea.dhcp.ti.com>
 <BANLkTik-zdp57zTjrafR0jXGoJiq2hrm3g@mail.gmail.com>
 <BANLkTi=tuh028X-Rr9i8ZF_B_Q6VBK2-Lw@mail.gmail.com>
 <20110620160650.GA26623@legolas.emea.dhcp.ti.com>
 <BANLkTi=nEma5muF9R3_QUzZWWJ64DW9Skw@mail.gmail.com>
 <20110620170551.GE26623@legolas.emea.dhcp.ti.com>
 <BANLkTinc-9hxLQ1Epf5=PoHvxtapfO7Vvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IuhbYIxU28t+Kd57"
Content-Disposition: inline
In-Reply-To: <BANLkTinc-9hxLQ1Epf5=PoHvxtapfO7Vvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IuhbYIxU28t+Kd57
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 20, 2011 at 07:27:18PM +0200, Viliam Mateicka wrote:
> I wonder then, who applies the patch first. One ass can't stop
> progress (was there some progress afterall ?) because of one
> line-break (which git produces by default afterall) and several
> non-conforming whitespace conversions. I think you should stop
> replying to me, because I'm kinda starting to like trolling afterall.

Look, maybe you're just new to git/linux and that's fine. The only
problem we had from day one is that you have been a complete dick when
replying.

If you go that road, that's what you'll get in return.

Just so you see the properly formatted patch, I'm quoting below. See
that there's no line breaks introduced by git.

commit c27c9b5312f4b2a7e66ee772943355d77fc2c550
Author: Viliam Mateicka <viliam.mateicka@gmail.com>
Date:   Mon Jun 20 19:08:27 2011 +0300

    usb: gadget: s3c2410_udc: fix custom UDC command handling
   =20
    There is a bug in Samsung's UDC driver, which is
    completely disabling the USB device when a custom
    UDC command is used.
   =20
    Following patch seems to get the right=A0behavior
    (e.g. enabling pull-up instead of disabling then
    Vcc is applied).
   =20
    Signed-off-by: Viliam Mateicka <viliam.mateicka@gmail.com>
   =20
    [ balbi@ti.com : manually re-created the patch because
    	author was unable to send a proper one ]
   =20
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_=
udc.c
index 100f263..b6e1ca5 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1567,7 +1567,7 @@ static void s3c2410_udc_command(enum s3c2410_udc_cmd_=
e cmd)
 		return;
=20
 	if (udc_info->udc_command) {
-		udc_info->udc_command(S3C2410_UDC_P_DISABLE);
+		udc_info->udc_command(cmd);
 	} else if (gpio_is_valid(udc_info->pullup_pin)) {
 		int value;
=20

(if you see any line breaks that's your mailer, it's better to check
=66rom the archives [1])

[1] http://marc.info/?l=3Dlinux-usb

--=20
balbi

--IuhbYIxU28t+Kd57
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN/4S0AAoJEAv8Txj19kN1ARYH/3Tcs/4gGVzeGgop6Rqc2gpG
B9RDyqLtMuyTA96khUWMpNPTILUHHsBsB3eSnq7amLWDrWx4aRRBYp9AhokEGni9
vVSv2C+TNrM7JVUN8khxA4lMtXLUfJ1ExvJO2wPgM1KDY/jdmXtmkWYzL4ZB4hXh
yjnOPizKbqoSsuLtYpVBfu/DqSSZggxe9LDEoEc6JJJGP7iIB6RqjPMUr/S1WPTu
cmWzFh6iHvrYG2yy6pvgM7GjvmewMTMeztuaNTEQidNBcWVtA6YWVTTJanGEDo6F
QuySPHr5oFS5sRVquS3kHzTrEkPV5vAUigqW2wQQtvghlmDfbnVSmfk6IJ0Pbng=
=lm4v
-----END PGP SIGNATURE-----

--IuhbYIxU28t+Kd57--
