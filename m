Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935339Ab2JXRb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:31:56 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:42051 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935257Ab2JXRbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:31:53 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Randy Dunlap <rdunlap@xenotime.net>, Felipe Balbi <balbi@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb/gadget: let file storage gadget select libcomposite
In-Reply-To: <20121024144435.GF4368@breakpoint.cc>
Organization: http://mina86.com/
References: <20121018144614.b61961cfae2274d52d340882@canb.auug.org.au> <50809624.30601@xenotime.net> <20121024144435.GF4368@breakpoint.cc>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Wed, 24 Oct 2012 19:30:42 +0200
Message-ID: <xa1thapjlqv1.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 24 2012, Sebastian Andrzej Siewior wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Date: Wed, 24 Oct 2012 16:40:10 +0200
>
> found by randconfig, Randy Dunlap and Stephen Rothwell:
>
> |drivers/built-in.o: In function `fsg_setup':
> |file_storage.c:(.text+0x24db7c): undefined reference to `usb_gadget_conf=
ig_buf'
> |file_storage.c:(.text+0x24db98): undefined reference to `usb_gadget_get_=
string'
> |drivers/built-in.o: In function `fsg_bind':
> |file_storage.c:(.init.text+0xee42): undefined reference to `usb_ep_autoc=
onfig_reset'
> |file_storage.c:(.init.text+0xee51): undefined reference to `usb_ep_autoc=
onfig'
> |file_storage.c:(.init.text+0xee73): undefined reference to `usb_ep_autoc=
onfig'
> |file_storage.c:(.init.text+0xee9e): undefined reference to `usb_ep_autoc=
onfig'
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

At first it looks strange as FSG does not use composite, but yeah:

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
> for v3.7 please.
>
>  drivers/usb/gadget/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index bbcec83..66bc3ab 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -737,6 +737,7 @@ config USB_FUNCTIONFS_GENERIC
>=20=20
>  config USB_FILE_STORAGE
>  	tristate "File-backed Storage Gadget (DEPRECATED)"
> +	select USB_LIBCOMPOSITE
>  	depends on BLOCK
>  	help
>  	  The File-backed Storage Gadget acts as a USB Mass Storage

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJQiCXDAAoJECBgQBJQdR/0f2IP/je3puG5abXBhOU+T/e+J8Sy
8esihs1NgHZxsWSVK0StWCc9u7aFSiZK/9gdjiVATbe0881mz5Mf7r5xYe6UsM6q
ods7nlHRqKH8hkMToyENtgAAcTKbTOUFlemOS8S+ODlq75ICHCdJrNnezbLzgR5b
1xMTsYq05DmIPTqEHonCZoQ2ecLbZt1x37lM5qvBaFnnNEnqk6uYtEX416jfapny
KpllpvAUPISbqyVPACjzMV4MVDtJzQRX2p2AE6TdVyHPBFzzOw3pWMBtNIFnv6YN
1owlmm/FiW6GPwmfEg+dp0I4B2ZuqwD9n+TF4iMJdqUK4D5WByZGgM2Y7HTW5IsI
0EtHBxE9ZiT89e9g4Lyd7E3BESiTaFF/A4VSuq4O4grl3RQd4gxALfIo9YJHXPps
NQynpD2Ldt3sEuQcto93L3ALrLBf6zDy6G//H/75hMksEZbj8Mydc3Knc2RuSKE+
GYohc9+l9+NLllS8pmnL6VoVoHmiKK5+o+xBbQptK4wkUmI/Pr9wkFjAo9OzjKiE
Dq1T95gqFif7rNKDRA86RFNUFSRAwcnEprv9uvH9UTegs9eG6dlHtPw/q5c+03Yz
7oFL0LuJ2GCmqiKkXqAMrKfb0d6Vw6kW4GfVPy5Li6xDT5inkJaT8H1KjQLz9BD7
5Hw83/6WG56EM7GOpSEg
=Zu0Q
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
