Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab2IKVg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 17:36:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48474 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab2IKVg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 17:36:57 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [RFC] memory-hotplug: remove MIGRATE_ISOLATE from free_area->free_list
In-Reply-To: <20120911010336.GC14205@bbox>
Organization: http://mina86.com/
References: <1346830033-32069-1-git-send-email-minchan@kernel.org> <xa1t1uigpefc.fsf@mina86.com> <20120906020850.GA31615@bbox> <xa1tipbr9uie.fsf@mina86.com> <20120911010336.GC14205@bbox>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Tue, 11 Sep 2012 23:36:48 +0200
Message-ID: <xa1tr4q8w8b3.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11 2012, Minchan Kim wrote:
> I saw two bug report about MIGRATE_ISOALTE type and NR_FREE_PAGES account=
ing
> mistmatch problem until now and I think we can meet more problems
> in the near future without solving it.
>
> Maybe, [1] would be a solution but I really don't like to add new branch
> in hotpath, even MIGRATE_ISOLATE used very rarely.
> so, my patch is inpired. If there is another good idea that avoid
> new branch in hotpath and solve the fundamental problem, I will drop this
> patch.
>
> [1] http://permalink.gmane.org/gmane.linux.kernel.mm/85199.

Well...  I am still not convinced.

Than again you clearly have put some thought into it and, more
importantly, I'm not the one deciding whether this gets merged or
not, anyway. ;)

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

iQIcBAEBAgAGBQJQT67wAAoJECBgQBJQdR/0+cIQAIE1nwegXCV6WY+kBW/I6o16
07xXNU1XkGZhB37+6ysSWP4fJvj+8vUZXSgM9v1+5SK8KpvMLk+vL7QcRh3vyGBJ
PG7hQSBnjgjl6HF6pDTQugXrH9/CwqBsxb8QUGklZXUBCZPm0wj1oxkWlGVRrVRX
I8evcHOuu8KsfMsPsptRoTBCN/hM9sHmOiBrYn1/+YwiyB0x0v7jp5PJvvHbgcF4
/Rf4JUF8P0YXLed5ru8Ux/uUuHnGa0OOWpxPB9d1KoKZleduvZrn51hl95mNR8mn
yNBl186ExrAfvJUgKmuthQqQx+E/fOHeC6vSBDlsq6bV0MNP8TTpcSNrhbugG6K+
j8oKlk8uEq2fFFDf6pzVOn/Zt0phiiHp2U5UylGQgdsMQnFc1E6xGd1/1o4x2e6M
Al0MLsdeK8OXDIFTwfjSgLXeQUVp6pNs5zhixNzpHkDVRd01WL6XoW9HJscbxfQi
RxBvUhqBzKIEOndC2pGodnuMWUouD5CKy05SucKLxqAGhQGzp24/f80p37+ujW2f
/dUsIS78VYRNyEc06zWh+GSArmE6NEsm//Uj9c208a4PJfTtM5iN92Jcx7KPKK0X
OhycJTHr8Mx+02he0aAuGpLp2UgNaiObSThJq2/9MsqDNaprVHuaVgKoO0WTmPl+
okzgHxzvxJM8SApJoDwP
=NV0O
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
