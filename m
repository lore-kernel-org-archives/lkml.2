Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030225Ab1LPWfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 17:35:17 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:42428 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932694Ab1LPWfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 17:35:12 -0500
Date: Sat, 17 Dec 2011 00:35:06 +0200
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Xiaochen Shen <xiaochen.shen@intel.com>
Subject: Re: linux-next: Tree for Dec 16 (usb/gadget/langwell)
Message-ID: <20111216223505.GA14030@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111216170042.650147ec79e792dce950f6e3@canb.auug.org.au>
 <4EEB98E0.8080002@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <4EEB98E0.8080002@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 16, 2011 at 11:15:44AM -0800, Randy Dunlap wrote:
> On 12/15/2011 10:00 PM, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Changes since 20111215:
>=20
>=20
> (not new today; I saw this last week but apparently did not
> get around to reporting it)
>=20
>=20
> drivers/usb/gadget/langwell_udc.c: In function 'handle_setup_packet':
> drivers/usb/gadget/langwell_udc.c:2321:19: error: 'struct langwell_otg' h=
as no member named 'otg'
> drivers/usb/gadget/langwell_udc.c:2322:15: error: 'struct langwell_otg' h=
as no member named 'hsm'
> drivers/usb/gadget/langwell_udc.c: In function 'handle_usb_reset':
> drivers/usb/gadget/langwell_udc.c:2757:16: error: 'struct langwell_otg' h=
as no member named 'otg'
> drivers/usb/gadget/langwell_udc.c:2758:12: error: 'struct langwell_otg' h=
as no member named 'hsm'
> drivers/usb/gadget/langwell_udc.c: In function 'handle_bus_suspend':
> drivers/usb/gadget/langwell_udc.c:2774:15: error: 'struct langwell_otg' h=
as no member named 'otg'
> drivers/usb/gadget/langwell_udc.c:2775:16: error: 'struct langwell_otg' h=
as no member named 'hsm'
> drivers/usb/gadget/langwell_udc.c:2776:13: error: 'struct langwell_otg' h=
as no member named 'hsm'
> drivers/usb/gadget/langwell_udc.c:2779:5: error: implicit declaration of =
function 'langwell_update_transceiver'
> drivers/usb/gadget/langwell_udc.c:2783:12: error: 'struct langwell_otg' h=
as no member named 'hsm'
> drivers/usb/gadget/langwell_udc.c:2785:17: error: 'struct langwell_otg' h=
as no member named 'hsm'
> drivers/usb/gadget/langwell_udc.c:2786:13: error: 'struct langwell_otg' h=
as no member named 'hsm'
> drivers/usb/gadget/langwell_udc.c: In function 'handle_bus_resume':
> drivers/usb/gadget/langwell_udc.c:2827:15: error: 'struct langwell_otg' h=
as no member named 'otg'
> drivers/usb/gadget/langwell_udc.c:2828:12: error: 'struct langwell_otg' h=
as no member named 'hsm'
> drivers/usb/gadget/langwell_udc.c: In function 'langwell_udc_probe':
> drivers/usb/gadget/langwell_udc.c:3119:2: error: implicit declaration of =
function 'otg_to_langwell'
> drivers/usb/gadget/langwell_udc.c:3119:12: warning: assignment makes poin=
ter from integer without a cast
> drivers/usb/gadget/langwell_udc.c:3120:18: error: 'struct langwell_otg' h=
as no member named 'regs'
> drivers/usb/gadget/langwell_udc.c: In function 'init':
> drivers/usb/gadget/langwell_udc.c:3529:2: error: implicit declaration of =
function 'langwell_register_peripheral'
> drivers/usb/gadget/langwell_udc.c: In function 'cleanup':
> drivers/usb/gadget/langwell_udc.c:3540:2: error: implicit declaration of =
function 'langwell_unregister_peripheral'
> drivers/usb/gadget/langwell_udc.c:3540:2: warning: 'return' with a value,=
 in function returning void

aparently this has never been compiled with CONFIG_USB_LANGWELL_OTG
before.

Xiaochen, please fix that ASAP. Now that I look at it, that driver
should have been on staging. It's pretty messed up. Isn't it one of
those devices which is based on ChipIdea's core ? I wonder when that
consolidation work will get done.

I expect to see this fixed still on 3.2 series. Also needs a backport to
fix older stable kernels. v2.6.31 is the first kernel with that driver
available.

Thanks for the report Randy

--=20
balbi

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO68eZAAoJEIaOsuA1yqRErLEP/2cXXA0hWVihHJtjQpxvAZ1v
Favb332H5Y5CN1M5iVH0CqW1AsQ58IeQD7zqCRPoJX4IPuA7jkXmgVHvhvXTyCSg
7Z9YjXGBxA0dzoeYN5GaSluMefrjMVu5Swp23Xf1Ke8AWMiOEJ3mBJdeViCPeZYe
C/f5EmYug8rrS7ExwyQnxTOKuO1n8LwnnuUJwRR+toL24Qa6C+buzqHCE7HE5PFV
uZ2ut1o5FGYkR8wy2qiut34wz7jF2XSMqk6U04tXMGwmCEdZtJ/M68c7r2Og61WJ
vzm01qRNnZthZ8IaBrb2RioevgTtUVsLUPHRsB5nS27eVI2fHIcEHo9r8xU+nOWL
FSfcP+/kpUVmlnFxy2RUTFkBshJT0N59Ljkn7oroyd7TJ0oYjTkguHSNmYZF24J8
xoSFvlKeXEeZxTh1J/C5pTPdet1tVnn1kKHA6yXQRTYYTVA1pZ7hfoSp9bDNIkTE
CVU0cieF3iCchN4+NxA9hZqIItjr4tXNm1oESMKssHhqVJiVsn4PNjVFy5QKqlHG
E3kjh6kgQPEYEpukVEz4nh0cNbWfKZxIWVeOYgEXsYf23hHhoGZval+jHIE10G0q
lsS6+fKhyt167QZd6zL4f4vvawy+Eklvht9ErfV6CPjQF+sanmyZDSZzZ5ZHGfIA
4HyRiyNS7bU4HooJpgyx
=CFog
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
