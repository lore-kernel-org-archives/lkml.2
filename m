Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935251Ab2DMLAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:00:18 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:50102 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758521Ab2DMLAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:00:16 -0400
Date: Fri, 13 Apr 2012 13:59:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: Re: Enabling multiple gadgets on top of composite driver
Message-ID: <20120413105921.GM7154@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <D5ECB3C7A6F99444980976A8C6D896384FA30FA942@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6CiRFyVmOOJ3DkBX"
Content-Disposition: inline
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FA30FA942@EAPEX1MAIL1.st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6CiRFyVmOOJ3DkBX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 13, 2012 at 06:51:26PM +0800, Bhupesh SHARMA wrote:
> Hi,
>=20
> I have a query regarding enabling multiple gadgets (like g_webcam, g_zero=
 etc..)
> on top of the Composite driver.
>=20
> My use case is very simple:
> 	- I want to expose a USB composite device to a standard USB host, where
> 	  the Composite device supports a webcam gadget + zero gadget + some oth=
er gadget..

look at how nokia.c does it.

> On the older kernels like 2.6.27, this was easily possible, but the latest
> gadget code doesn't seem to support the same:
> 	- I can see that first a 'choicemenu' is provided which allows selection=
 of only
> 	  one gadget at a time.

Answer M instead of Y to "USB Gadget Drivers"

> 	- The "common" stuff like "composite.c", "epautoconfig.c" have been incl=
uded in
> 	  each f_* function driver (for e.g. f_uvc.c, f_sourcesink.c, etc..), so=
 even if
> 	  I somehow tweak the 'choicemenu' stuff, I get redeclaration errors.

yeah, that still needs to be cleaned up. The story behind that is very
long.

> What is the best way to enable multiple gadgets (like g_webcam, g_zero
> etc..) on top of the Composite driver or am I missing something here?

Either you want multiple gadgets or you want a composite gadget, what is
it ? If you want a composite gadget, you need to write a small C file
which combines multiple functions together (see nokia.c), if you want
multiple gadget drivers, just make them all modules. I always compile
all gadget drivers as modules and can use any one of them at any time.

--=20
balbi

--6CiRFyVmOOJ3DkBX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPiAcJAAoJEIaOsuA1yqRER4sQAKnUzUNYe/O1hz1sbYBOyWFX
sjspqrtV2JeTJyf7LO7drtipQ1nfoOzKIfbfPqUer0+1V57Qy6Icy3BOhlnV5cK6
kqICJBRR4NCLjt93YUFAO6sZvIfjMADgjs7jNj0IJ6Ka8ss+7Ww8XfY/XWN5aPg6
Izndly8RJkYvJz1nzX/qEpfn+SoCJDS0QMY+Ja7w+iOGB6A868SvS/c+9rQ+/lJr
ynE9b1QcLiEaM9b3kGe1Y0ihYbSheKqOSfymywkHFgT1Nj2Bny5iTX9vFmXSpgf2
mcS0ieUC7NJdmzbKm7HyCJjcqMKR42kbqVxeBJ67/GlVCZrcX5ijeDb2BbMsYDxS
GbaYmCvVaQOF4IprR//Zoaa8iArOp4t4/AAjwFOtoVlj2RVb5MGPmcsF7bm55nTG
Vy3j0y2Ez21+ZP2U/6ughKKG8bT8KKz//DMc1Njstqmr4poQJ/CoONYPD7pXUquK
SvVsYmiISLfWDug7+bgWMu/WwERziOc1B6q/cFr6OacXzKsStGWXsYmdxJ01kgbc
kCsIrFUF1QVdJyq68K0229K65WfWm5duyJKOHDhdit+Jk0EBjx0+Xc32xzI4l1o6
+HCsNnqOJHOeQ1RCKrRq8ckpDdFWofvbj0kkBoscw8pD4AAdp7WZeFaPKrS4gNpf
G5bg9/OWPCVQqN2Jl9MB
=cdhS
-----END PGP SIGNATURE-----

--6CiRFyVmOOJ3DkBX--
