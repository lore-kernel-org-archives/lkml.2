Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2GPRk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:40:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39775 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab2GPRkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:40:53 -0400
From: Michal Nazarewicz <mina86@tlen.pl>
To: Joonsoo Kim <js1304@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Sasha Levin <levinsasha928@gmail.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/3] mm: fix possible incorrect return value of migrate_pages() syscall
References: <1342455272-32703-1-git-send-email-js1304@gmail.com>
	<1342455272-32703-2-git-send-email-js1304@gmail.com>
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: AC1F 5F5C D418 88F8 CC84  5858 2060 4012 5075 1FF4
X-PGP: 50751FF4
Date: Mon, 16 Jul 2012 19:40:38 +0200
In-Reply-To: <1342455272-32703-2-git-send-email-js1304@gmail.com> (Joonsoo
	Kim's message of "Tue, 17 Jul 2012 01:14:31 +0900")
Message-ID: <87394rr4dl.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Joonsoo Kim <js1304@gmail.com> writes:
> do_migrate_pages() can return the number of pages not migrated.
> Because migrate_pages() syscall return this value directly,
> migrate_pages() syscall may return the number of pages not migrated.
> In fail case in migrate_pages() syscall, we should return error value.
> So change err to -EIO
>
> Additionally, Correct comment above do_migrate_pages()
>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> Cc: Sasha Levin <levinsasha928@gmail.com>
> Cc: Christoph Lameter <cl@linux.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 1d771e4..f7df271 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -948,7 +948,7 @@ static int migrate_to_node(struct mm_struct *mm, int =
source, int dest,
>   * Move pages between the two nodesets so as to preserve the physical
>   * layout as much as possible.
>   *
> - * Returns the number of page that could not be moved.
> + * Returns error or the number of pages not migrated.
>   */
>  int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
>  		     const nodemask_t *to, int flags)
> @@ -1382,6 +1382,8 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned=
 long, maxnode,
>=20=20
>  	err =3D do_migrate_pages(mm, old, new,
>  		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
> +	if (err > 0)
> +		err =3D -EIO;
>=20=20
>  	mmput(mm);
>  out:

=2D-=20
Best regards,                                          _     _
 .o. | Liege of Serenly Enlightened Majesty of       o' \,=3D./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
 ooo +-<mina86-mina86.com>-<jid:mina86-jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQBFIWAAoJECBgQBJQdR/0VmoP/29TAo7BZJZ7bQeRHUiNscCn
iKRmMbiRaBmdJegPizzDmZytkzZaskM2raSycDHenuHBXcT9xfKN9atI/KrA1+h0
/wnu1ZwsLq7nCnBvVvBFqGepe98SISrhn2xb7o8/yvM+lB2XgqrDMam4BxBUNxs/
W9yhJ5HeBobEp9noO0r6y9eZhvjT7Sg4wSMgaP3bV2SeWHJT74oiOYxqxTupcpb6
aKptUCGyLFgq8o5XMG2Cm9X/sVJTDTqYd4w5d3RLqPQr8r/GumWiVc+2gRG044XJ
buECAEoiqoZNvnzaopfmTzh4yZy62faMTNo4GtQwhx+8zch98+rh9vfUzaNWrI/n
XPAFp7VLzoktomfKBvQKvLmEbORBIPcrwpz+Na+gTIdXpcW9Vkm3Yn6tX53HkWSd
tj8EsxyVPelwAn+NmPKCBdTqLe6DFsIyFTTfFdf+H5erMjiXLuhYpplJBouayGpc
J2SedhR5OvN3Fcn5gZl1Nl1ceHdACZtjK55xMwu55xlnjtEHYjFF8sI97nUPSeC1
HZ4akknU9Tgvz5Wt+riz9YJzsiHNCcsUTTFpBa76EeFVlKE0w4MF4gOYvXzoq3eN
gDKKbCBQFV3r2BLhZPck2V0QYJV33R8hUvsLDfIZTNDdlKkFSWNnRcHP+5XuPiqz
Ib1WgnmuUJsNEk5BJHRt
=GeRr
-----END PGP SIGNATURE-----
--=-=-=--
