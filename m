Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab2IKLQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:16:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44844 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab2IKLQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:16:05 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Kyungmin Park <kmpark@infradead.org>, Minchan Kim <minchan@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: cma: Discard clean pages during contiguous allocation instead of migration
In-Reply-To: <1347324112-14134-1-git-send-email-minchan@kernel.org>
Organization: http://mina86.com/
References: <1347324112-14134-1-git-send-email-minchan@kernel.org>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Tue, 11 Sep 2012 13:15:56 +0200
Message-ID: <xa1tehm8yfmb.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Tue, Sep 11 2012, Minchan Kim wrote:
> This patch drops clean cache pages instead of migration during
> alloc_contig_range() to minimise allocation latency by reducing the amount
> of migration is necessary. It's useful for CMA because latency of migrati=
on
> is more important than evicting the background processes working set.
> In addition, as pages are reclaimed then fewer free pages for migration
> targets are required so it avoids memory reclaiming to get free pages,
> which is a contributory factor to increased latency.
>
> * from v1
>   * drop migrate_mode_t
>   * add reclaim_clean_pages_from_list instad of MIGRATE_DISCARD support -=
 Mel
>
> I measured elapsed time of __alloc_contig_migrate_range which migrates
> 10M in 40M movable zone in QEMU machine.
>
> Before - 146ms, After - 7ms
>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

Thanks!

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

iQIcBAEBAgAGBQJQTx1sAAoJECBgQBJQdR/0rcAP/34tPp7PJzehiwRqe7xBd/7W
dmjRpYfGP08EvaxUgxPRdC/EAZTpgBy/jsVoa1vEXc1rAM3pCwKR3L5cTFd8xc4o
/mKYzWAQy3N9zF/VrZiicZqLoguZJs9jqQoyqY9sO8qaMYqzQ92ETof1gsIGAv7J
tx4UlECDu1tQrp9cDSMcP97Z1JnMh3hJ2V1cLrouW4nuQBCcImF3eR5NdEM84pEC
rhBCmonm2X7SwPWkmc7tWXOEiqT3h9O7WGOl8Qc2JFDINVYXsGJFCwUC1LRIHqOt
zFjwOmOeOdrqog6Wf2hRY7LpCzSjWsmz6MP747dJOZxlv+cdocIF6ibj6ZgoHjJj
Ced0baWmH7fi963o9czgwO6JGeQ5swS06b+etFTwurQaRqNYc7nXhMoMZppaFuRq
kEEfTbf2fkRONVoaWhUI7smSt7HH4zAjKlfN1YTXCy/fey2B37X7tBhQZsrGGwvm
xn1zPXnxcrffu6L8afiPHqswFZCLX+Ta8KdPQvQP2ir23WPZ3P5f9VBt9e77uYng
gu+2u8+zIalS9OPfZiUI2VB/xfR5TdR1HJZQHU4Xl/KzcWiQyjrKWamjnh3nxRfg
G7BfNuwhZVnM+vDzjc+DHr56uJnxEAf9NMnKv6a9gXZRQHdI4QiImkAnZfhNtjSl
/zy9TV9nwTkRcYhbKOHq
=C9Mk
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
