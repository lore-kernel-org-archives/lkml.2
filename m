Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab2IEMnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:43:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62246 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2IEMny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:43:54 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 2/2] mm: support MIGRATE_DISCARD
In-Reply-To: <1346832673-12512-2-git-send-email-minchan@kernel.org>
Organization: http://mina86.com/
References: <1346832673-12512-1-git-send-email-minchan@kernel.org> <1346832673-12512-2-git-send-email-minchan@kernel.org>
User-Agent: Notmuch/0.14+2~g416b120 (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Wed, 05 Sep 2012 14:43:44 +0200
Message-ID: <xa1tmx14prlr.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 05 2012, Minchan Kim wrote:
> This patch introudes MIGRATE_DISCARD mode in migration.
> It drops *clean cache pages* instead of migration so that
> migration latency could be reduced by avoiding (memcpy + page remapping).
> It's useful for CMA because latency of migration is very important rather
> than eviction of background processes's workingset. In addition, it needs
> less free pages for migration targets so it could avoid memory reclaiming
> to get free pages, which is another factor increase latency.
>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

The principle is very good (I always intended for CMA to discard clean
pages but simply did not have time to implement it), and the code looks
reasonably good to me.

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

iQIcBAEBAgAGBQJQR0kBAAoJECBgQBJQdR/0kGsP/2NCgi4lCCoDTDUf98M9ayaE
1yG7CBCBtwkwZ6whTmQiVokBBuhbzXK2+fKzmT5pJin2WS0Yz+A2mBJQM4pIgwf7
QPWYEB6pJ0Y2uS9SkSCAYrxAdkRDXIufhvv9y/tQk24S0ZPNfTdSWSe43H5s5oEP
/GlBX+1Z/7HapE3xOtbFLsQxnREdC3hoolGNhxpoAXp9hQZO4EnFqmd4VQsnoJ7s
w34cPv4Whnjs32wP9ItCRhE0mOfgCixhKNWqKAe46Nb9lAx6NTfdZq/D+E2LB4KF
51tGE/Z3Q4XyZEax8xf0BDIKRGZeIJpq0WzxJlJlkCkihQgvojmGbRCp47Spr6pj
/Cs4rJExHWLrs4YKJu+pxNMLVVxMS0vIforPtMG/WOzSlHdND3jVJBz1SOXVEpN8
O9egq3ObQL7/i29539shdM1ulsrXcmoCNRBVZVsgu2v+a//fct+Ryh0dxfmMdt7X
iPD33G4Nn2V23P5hnWlEiXJwBobEEvxzI3ky9TN7HwFI2vIDddEiP407GVLmLqgY
ZirLXPf7/L0abDnusYP9SWDFDn3fqwHGuWyl1YzhewXerwGG8c7ThJJeZuAcBm9f
m3oOH841SFd31tjUe7VpF8LvAeHhEHyyxO3ERX1q6DiMFutYismi4DsF8Ohvywv5
WluorFV3c6a0DSTyR9uE
=8XOl
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
