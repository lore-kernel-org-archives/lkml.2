Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2IFNAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:00:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47321 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab2IFNAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:00:04 -0400
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
In-Reply-To: <20120906020850.GA31615@bbox>
Organization: http://mina86.com/
References: <1346830033-32069-1-git-send-email-minchan@kernel.org> <xa1t1uigpefc.fsf@mina86.com> <20120906020850.GA31615@bbox>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Thu, 06 Sep 2012 14:59:53 +0200
Message-ID: <xa1tipbr9uie.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On Wed, Sep 05, 2012 at 07:28:23PM +0200, Michal Nazarewicz wrote:
>> If you ask me, I'm not convinced that this improves anything.

On Thu, Sep 06 2012, Minchan Kim wrote:
> At least, it removes MIGRATE_ISOLATE type in free_area->free_list
> which is very irony type as I mentioned. I really don't like such
> type in free_area. What's the benefit if we remain code as it is?
> It could make more problem in future.

I don't really see current situation as making more problems in the
future compared to this code.

You are introducing a new state for a page (ie. it's not in buddy, but
in some new limbo state) and add a bunch of new code and thus bunch of
new  bugs.  I don't see how this improves things over having generic
code that handles moving pages between free lists.

PS.  free_list does exactly what it says on the tin -> the pages are
free, ie. unallocated.  It does not say that they can be allocated. ;)

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

iQIcBAEBAgAGBQJQSJ5JAAoJECBgQBJQdR/0dbsP/1dKXsqBtAKfu9S+jlmbio6O
LlYrEC70r/wcKgsKhAqN8itfFLNrIKDxNhv/sz1aXuKrCTq8QkeQT6kZswgWb/Mp
8/E2L0Z6XXmSjqJnmiDwPmoGDGUCQivE2XIXVkVeafhcqg9Z0HnvWsvVflJu56S4
dmuFsaliqp9iEGQEA+HkYI8VnaXK3sHYhOcOiL2G/4yYVyIlJoH2Pp4AZopeQvKZ
vpCspAutB+HjTSpE6tJg/4LqhmWK6OwCFjBDAuBLmRVnUCqv1hyIMxz7c2bOObdT
1V9NHoMp0Gorzdky1J2rSH29EpugDavrx8f0kOrqzD6BqZhIno86RVHgTWEgCy8e
zbRfecvUoABz+T78M57FjedIghB9yK/CmtvWqGg9apRUuMk6J6znb1Rtbp1bRKmn
tKHkCjpBAW9faLT1EerHLvCEQmnvskV13phu3gDqEf5BWiDmASDz9Vso5zT4N1c9
SKqBpX4XLDL/evEELXM9qMgIHWG7mRJz+AHHaYDFFVheiIiyr0oGwtCFKpJDGkHh
Sf8hvc6ehGYuBCjyH79mkuznIPPDIaWR9yioEXEAq52GsVXt6Xxlgz+oIR8ZYUqC
GffYet3kmnbtX0wX6Z871YWbpk9lQTbaqDVg8OHkSwBM5x8PMVBUeSWNlE177QLd
f5UNFmstTAGmOYE4wqdT
=n5Wc
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
