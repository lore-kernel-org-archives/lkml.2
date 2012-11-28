Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2K1NFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:05:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64560 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab2K1NFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:05:20 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joel Becker'" <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
In-Reply-To: <50B5C821.4000406@linutronix.de>
Organization: http://mina86.com/
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de> <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com> <50B4E364.8030704@linutronix.de> <xa1tip8ruia5.fsf@mina86.com> <50B5C821.4000406@linutronix.de>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Wed, 28 Nov 2012 14:05:07 +0100
Message-ID: <xa1ta9u1naik.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On 11/27/2012 05:23 PM, Michal Nazarewicz wrote:
>> How should a generic tool know what kind of actions are needed for given
>> function to be removed?  If you ask me, there should be a way to unbind
>> gadget and unload all modules without any specific knowledge of the
>> functions.  If there is no such mechanism, then it's a bad user
>> interface.

On Wed, Nov 28 2012, Sebastian Andrzej Siewior wrote:
> Well. You need only to remove the directories you created.

My point is that there should be a way to write a script that is unaware
of the way function is configured, ie. which directories were created
and which were not.

Besides, if you rmdir lun0, is the function still supposed to work with
all LUNs present?  In my opinion, while gadget is bound, it should not
be possible to modify such things.

> An unbind would be  simply an unlink of the gadget  which is linked to
> the udc.   All configurations  remain so  you can link  it at  a later
> point without touching the configuration because it is as it was.

Yes, but that's not my concern.  My concern is that I should be able to
put a relatively simple code in my shutdown script (or whatever) which
unbinds all gadgets, without knowing what kind of functions are used.

And I'm proposing that this could be done by allowing user to just do:

	cd /cfs/...
	rmdir gadgets/*		# unbind and remove all gadgets
	rmdir functions/*/*	# unbind and remove all function instances
	rmdir functions/*	# unload all functions
	rmdir udcs/*		# unload all UDCs
=20=20=20=20=20=20=20=20
>> I think the question is of information flow direction.  If user gives
>> some information to the kernel, she should be the one creating any
>> necessary directories.  But if the information comes from kernel to the
>> user, the kernel should create the structure.

> Yes that is a point. But the "name" can go away if we use it in the
> directory name. That is what other configfs user do. The same is true
> for luns for instance. I just want to avoid adding features because we
> do something different compared to every other configfs user.

You've lost me here.  What are we talking about again?  What =E2=80=9Cname=
=E2=80=9D are
you referring to?

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

iQIcBAEBAgAGBQJQtgwDAAoJECBgQBJQdR/0TTQP/RWO/HJ/1BakyE5gTgUWidDX
gLoyCVsPTUYh7RzrdB/CxOq1SPz0OXkWB2ZqYp53RiF0buO0OUi6dJEREGwCvwMY
F9RUSltaeITfFr/bXXS+xoo7SBuPWGFQ3IvEJ01tucQcatRMuPfib7Os66uRx1YV
J1nnBhttU+kFwAjdJATV7cbTB8xs1lKNtYMOu8CEmscDtp7lhSLesUxGzBsqNi+g
rrb/WbPQlo5C/TRqHzTmDF82JRE4cY6aliccOCZ8nvr1mpv5/Tfj/j8fz2/oC5YC
PtUpSO0h5OqFFoxO+HlXh5DunDQQ7aJf1SHaAZksPFsK+kPxI2DVnHdKNioT4JSj
yhpf5xZx1efd8U+LZjp0p0x9piSzZUtUg9TmdlT4L9X/Qap1MNPWqsHuUvuXbprb
XyPqtZzj0XgK0bP+UGCUOeSXZbR9zMdaFH7PBR/HCPHq00j4Vj5GFbxwAgaHQYnT
h8heawhnLtDUeG0/raL+WlNI/csPTJ1djgCbCHR2K4hBWIdaYGTzQQh0u6SURtnR
yOEty4SOQ6IUqbYxJDBJMVhE12rqzAe45c/iZKVRVEARBFnG/un9aVvFeuM+TghE
bp4E7/1PHD8kH8FF/omlPvGplW5KQEWbLUqdXZ4ZyUvrNJY0gegeagnSs1nbnynq
mAZmSyEas0mLTwj71Iv0
=Buxh
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
