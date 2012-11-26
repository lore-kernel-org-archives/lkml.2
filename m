Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab2KZQ43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:56:29 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43021 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2KZQ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:56:28 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
In-Reply-To: <50B39921.6090308@linutronix.de>
Organization: http://mina86.com/
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 26 Nov 2012 17:56:04 +0100
Message-ID: <xa1ty5hogv6j.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On 11/26/2012 09:35 AM, Andrzej Pietrasiewicz wrote:
>> In some parts of the kernel (e.g. planned configfs integration into usb
>> gadget) there is a need to programmatically create config groups
>> (directories) but it would be preferable to disallow creating them by
>> the user. This is more or less what default_groups used to be for.
>> But e.g. in the mass storage gadget, after storing the number of
>> luns (logical units) into some configfs attribute, the corresponding lun#
>> directories should be created, their number is not known up front so
>> default_groups are no good for this.
>>
>> Example:
>>
>> $ echo 3>  /cfg/..../mass_storage/luns
>>
>> causes
>>
>> /cfg/....../mass_storage/lun0
>> /cfg/....../mass_storage/lun1
>> /cfg/....../mass_storage/lun2

On Mon, Nov 26 2012, Sebastian Andrzej Siewior wrote:
> I though we did not want the luns file but instead use
>
> mkdir /cfg/....../mass_storage/lun0
> mkdir /cfg/....../mass_storage/lun1
>
> directly.

I think that's suboptimal, and we can do better.  There are too many
corner cases (ie. what if user does =E2=80=9Cmkdir lun7=E2=80=9D without th=
e previous
luns?), it adds complexity to the kernel (ie. parsing of the name), and
the thing is overly complicated for user (=E2=80=9Cecho 5 > nluns=E2=80=9D =
is much nicer
than having to create 5 directories).

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

iQIcBAEBAgAGBQJQs58kAAoJECBgQBJQdR/0AFwP/0fudMRbSQ+HZ1RHH1NWn/Kj
fsCbfObtTf+D4wHuujzjGBF9NS2mjUIy7SBx+Nj9C6cKiElYywZAPxuu+Rahc6GN
DDhHdcDXj9pXhKVDw12aHTtgQE8NnKcLTWds/xIiuTYvSVg+oD6I3VQPU/iQaMLK
tnIQzsDgO6yI4Xk1SD+x8jvAi6UfQsrr324vtat9JczZ+GNd8RWIXDYzuRHQz20P
Wrtd5fu9xt9jirf5YwkBTdFyr3vQ46WuoP/n/Q59yMxJVY5k89D7KHPs8xWZTzrL
7YEQYCGQJKgYULU7OROM9Xb/0CnRO2tAg/wxX2lw4wsfgB6hJsie6vs6IpmCiSZK
bmTJZHAn5FKapdlRFgJ4d1tBIjT30IzCosgN9ea4Rd1WIkkNdjO0h00MXNmIdeL4
O9qMM4djNDufYVpkAc1XZS9bIkoJ31HAptz1roeu1DK0JtHGpE8awvdp7D4/TYQ0
EohrWNZMwb4NHRoqzTwpCvrYFyLcsr23hlFqIc78EHENPKtA8+0M286BElIK+tA1
mEbF5/kMKBvIXRx+Kzq/LwyNL1XIWjk32Bdy/3gqiiQbL3huPLwsYtuaiAEu/5jL
6AoaPTjJXvgVNz4LokdL1xRUh47QqFtdnYSL09GAJXU6pLoAz1QzTTOxgGSUUUIV
GidvFAtj7IscPjOw8Thu
=xDY1
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
