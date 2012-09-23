Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab2IWRaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 13:30:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58675 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2IWRa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 13:30:29 -0400
From: Michal Nazarewicz <mpn@google.com>
To: George Spelvin <linux@horizon.com>, vda.linux@googlemail.com
Cc: hughd@google.com, linux-kernel@vger.kernel.org, linux@horizon.com
Subject: Re: [PATCH 2/4] lib: vsprintf: Optimize division by 10000
In-Reply-To: <1343971271-13355-2-git-send-email-linux@horizon.com>
Organization: Google Inc
References: <1343971271-13355-1-git-send-email-linux@horizon.com> <1343971271-13355-2-git-send-email-linux@horizon.com>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Sun, 23 Sep 2012 19:30:20 +0200
Message-ID: <xa1twqzk640j.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 03 2012, George Spelvin wrote:
> The same multiply-by-inverse technique can be used to
> convert division by 10000 to a 32x32->64-bit multiply.
>
> Signed-off-by: George Spelvin <linux@horizon.com>

You are using a 64-bit multiply in a path that is designed for 32-bit
processors, which makes me feel that it will be slower.

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

iQIcBAEBAgAGBQJQX0csAAoJECBgQBJQdR/0OeEP/2Sf8+wGJcaYa/KotLFECZ/0
ST0d5SkTtm/SyC1KAxMRWZXhbpIFU4zmiyrLp/8aw/8GVlabUKHbuoemoOzkGNEo
FMTPz1d4jD4xZFyp2534R10NYDPLk4NRKy9dyrEOnx4pSa5KHMTRqzlt6DYfTVdz
myrvYMAt1HbkP70HzjHQIkbKGj1XRE2NF/vWGCoyHhcCaJlUZW5YYzYkurcE9Tyd
fs6RZv/FSxWmSCykVXTlzCo8TaKNiJyDfIJ6KW2jg54hGFAo7jDS77PxU8/deWvD
zMCLbNa1rXcl9OcVKymEHxtcR8nTTjtZ/tXIQm7sntOgfIsfOX1R6shA1K75GNmd
mBYa+X5MsAwbaMHNpVo71xAeG68yOTYo6wgDtdd+hEhl/GU0WXTFd49NazE2ety9
CrveN4sbo+YPJoPUF8KOsw+peTwLm6ZBDWuZSNWTvlQF/8SPqESjHkX0rm6gTNrq
28UJgCGmjLlES/NJEcxwN40IfwhuU+Jvnb6F4D5FNZDOsmz09RD1GAeh3AP9CABj
FTxq+6/kWIkraA92GZ7J75yqay1AzwQft8miPabcYHwRZuqiRg69kCD7VPso7KLW
JJNNT8QoM00TzKOIpIZ9mcpM0w8BtEBe7SbAl3MICuOPuTmll8b/kV8+UZi8VJpx
pJieVGUoN9U9bKqJjwdC
=QZya
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
