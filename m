Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab2K0OdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:33:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56489 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab2K0OdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:33:07 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joel Becker'" <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFC][PATCH] fs: configfs: programmatically create config groups
In-Reply-To: <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com>
Organization: http://mina86.com/
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de> <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Tue, 27 Nov 2012 15:32:57 +0100
Message-ID: <xa1tobijundy.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 27 2012, Andrzej Pietrasiewicz <andrzej.p@samsung.com> wrote:
> I think we _still_ need a way to programmatically create/remove configfs
> directories. Without it, this: "After name is written it will request
> the module and special configuration related files pop up."
> (http://www.spinics.net/lists/linux-usb/msg75118.html)

I agree, and this is orthogonal to exact API used by configfs gadget.

I may be missing something about configfs, but the way I see it, lack of
such functions is a mistake in the configfs API.

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
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQtM8ZAAoJECBgQBJQdR/0BJoP/3gKr1YtWPNnbu8lzyFJj87X
6sL4LrkssPWfylC8XbRDZcHFN/UaH0OHeHnOsajZg3qarqI54XTUA4hnUNQYJc7+
QOow75MDNgSw2uRmQutO35VbC+6sh4uleYaDn0sw8bZQsJgbYY5aK7KY3PAsDL5G
KWNOpQkwqwqk6BR1N6AkCVxoZ3hyrMnRgYEiSej7tV+px0913IdXP6OyrCY9QKvw
BiuUN8Ha+4laXTAnUo1o/sVHLDBpH/fZl/hvmb+2v1wIgy87CEeP2m3xBlygvEo8
hU+3ZOgS27LC+QgWe6u5eyv7h12Ophx9nPhM8+EnNQev7tz/MwFV7b3e8mizM9YY
fd9oC/8haRsY9VEPZ+YUrjjhktmGjWmKUnHLm1uJWPhl974TtFocA/52JYTXC7MK
7jXkH/4K755j7WxDB7mmBbtfbAL0cKPxdv70va5/EprukTBb8iYrVZTAM51Qaixj
/ziZE0ZGa2wQgkPtt7NBbaRrTOBmesRaEFVnyUXWlVKwS9/WMwKS5XNDTTNu2POV
6wqMH8VBQWAKqVq3HKOqe/jgSgOzHE9obcgfITPgzMpOaulRypd/w7o48Nk2aOUw
vVpRzfTig34tHip6LfSRIynfRKwxqcL7jjBiVWufwKDh4pQyMbgQKR+r0jUnRPh9
Wryzur06VR3xWJdGXJKO
=yyVp
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
