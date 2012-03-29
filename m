Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2C2Fhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 01:37:31 -0400
Received: from ns.lbox.cz ([62.245.111.135]:38339 "EHLO ns.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab2C2FhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 01:37:23 -0400
Date: Thu, 29 Mar 2012 07:36:39 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: gregkh@linuxfoundation.org
Cc: mel@csn.ul.ie, stable@vger.kernel.org,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Subject: Re: Patch "mm: vmscan: forcibly scan highmem if there are too many
	buffer_heads pinning highmem" has been added to the 3.3-stable tree
Message-ID: <20120329053639.GA7603@pcnci2.linuxbox.cz>
References: <13325234973644@kroah.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <13325234973644@kroah.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovaws by Kaspersky antivirus, 7190113 records (last update: 20120329)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 7190113 records (last update: 20120329)
X-Spam-Score: 2.8 (**), 15 required
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.2 (ns.lbox.cz [62.245.111.135]); Thu, 29 Mar 2012 07:36:41 +0200 (CEST)
X-Spam-Report: -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
    -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                                [score: 0.0005]
     0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal information
     4.6 AWL                    AWL: From: address is in the auto white-list
     1.0 DIRTY_DOMAIN           Spurious domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I'm not 100% sure, but I think this one could go to 3.0.x as well, am I rig=
ht?
If it's so, could I try to provide backport? (it't doesn't apply cleanly).
Mel, would You care to review then? Or do You plan to send Your own backpor=
t?

cheers!

nik


On Fri, Mar 23, 2012 at 10:24:57AM -0700, gregkh@linuxfoundation.org wrote:
>=20
> This is a note to let you know that I've just added the patch titled
>=20
>     mm: vmscan: forcibly scan highmem if there are too many buffer_heads =
pinning highmem
>=20
> to the 3.3-stable tree which can be found at:
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.g=
it;a=3Dsummary
>=20
> The filename of the patch is:
>      mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-p=
inning-highmem.patch
> and it can be found in the queue-3.3 subdirectory.
>=20
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>=20
>=20
> From cc715d99e529d470dde2f33a6614f255adea71f3 Mon Sep 17 00:00:00 2001
> From: Mel Gorman <mel@csn.ul.ie>
> Date: Wed, 21 Mar 2012 16:34:00 -0700
> Subject: mm: vmscan: forcibly scan highmem if there are too many buffer_h=
eads pinning highmem
>=20
> From: Mel Gorman <mel@csn.ul.ie>
>=20
> commit cc715d99e529d470dde2f33a6614f255adea71f3 upstream.
>=20
> Stuart Foster reported on bugzilla that copying large amounts of data
> from NTFS caused an OOM kill on 32-bit X86 with 16G of memory.  Andrew
> Morton correctly identified that the problem was NTFS was using 512
> blocks meaning each page had 8 buffer_heads in low memory pinning it.
>=20
> In the past, direct reclaim used to scan highmem even if the allocating
> process did not specify __GFP_HIGHMEM but not any more.  kswapd no longer
> will reclaim from zones that are above the high watermark.  The intention
> in both cases was to minimise unnecessary reclaim.  The downside is on
> machines with large amounts of highmem that lowmem can be fully consumed
> by buffer_heads with nothing trying to free them.
>=20
> The following patch is based on a suggestion by Andrew Morton to extend
> the buffer_heads_over_limit case to force kswapd and direct reclaim to
> scan the highmem zone regardless of the allocation request or watermarks.
>=20
> Addresses https://bugzilla.kernel.org/show_bug.cgi?id=3D42578
>=20
> [hughd@google.com: move buffer_heads_over_limit check up]
> [akpm@linux-foundation.org: buffer_heads_over_limit is unlikely]
> Reported-by: Stuart Foster <smf.linux@ntlworld.com>
> Tested-by: Stuart Foster <smf.linux@ntlworld.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Christoph Lameter <cl@linux.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
>=20
> ---
>  mm/vmscan.c |   42 +++++++++++++++++++++++++++++-------------
>  1 file changed, 29 insertions(+), 13 deletions(-)
>=20
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1643,18 +1643,6 @@ static void move_active_pages_to_lru(str
>  	unsigned long pgmoved =3D 0;
>  	struct page *page;
> =20
> -	if (buffer_heads_over_limit) {
> -		spin_unlock_irq(&zone->lru_lock);
> -		list_for_each_entry(page, list, lru) {
> -			if (page_has_private(page) && trylock_page(page)) {
> -				if (page_has_private(page))
> -					try_to_release_page(page, 0);
> -				unlock_page(page);
> -			}
> -		}
> -		spin_lock_irq(&zone->lru_lock);
> -	}
> -
>  	while (!list_empty(list)) {
>  		struct lruvec *lruvec;
> =20
> @@ -1737,6 +1725,14 @@ static void shrink_active_list(unsigned
>  			continue;
>  		}
> =20
> +		if (unlikely(buffer_heads_over_limit)) {
> +			if (page_has_private(page) && trylock_page(page)) {
> +				if (page_has_private(page))
> +					try_to_release_page(page, 0);
> +				unlock_page(page);
> +			}
> +		}
> +
>  		if (page_referenced(page, 0, mz->mem_cgroup, &vm_flags)) {
>  			nr_rotated +=3D hpage_nr_pages(page);
>  			/*
> @@ -2235,6 +2231,14 @@ static bool shrink_zones(int priority, s
>  	unsigned long nr_soft_scanned;
>  	bool aborted_reclaim =3D false;
> =20
> +	/*
> +	 * If the number of buffer_heads in the machine exceeds the maximum
> +	 * allowed level, force direct reclaim to scan the highmem zone as
> +	 * highmem pages could be pinning lowmem pages storing buffer_heads
> +	 */
> +	if (buffer_heads_over_limit)
> +		sc->gfp_mask |=3D __GFP_HIGHMEM;
> +
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
>  					gfp_zone(sc->gfp_mask), sc->nodemask) {
>  		if (!populated_zone(zone))
> @@ -2724,6 +2728,17 @@ loop_again:
>  			 */
>  			age_active_anon(zone, &sc, priority);
> =20
> +			/*
> +			 * If the number of buffer_heads in the machine
> +			 * exceeds the maximum allowed level and this node
> +			 * has a highmem zone, force kswapd to reclaim from
> +			 * it to relieve lowmem pressure.
> +			 */
> +			if (buffer_heads_over_limit && is_highmem_idx(i)) {
> +				end_zone =3D i;
> +				break;
> +			}
> +
>  			if (!zone_watermark_ok_safe(zone, order,
>  					high_wmark_pages(zone), 0, 0)) {
>  				end_zone =3D i;
> @@ -2786,7 +2801,8 @@ loop_again:
>  				(zone->present_pages +
>  					KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
>  				KSWAPD_ZONE_BALANCE_GAP_RATIO);
> -			if (!zone_watermark_ok_safe(zone, order,
> +			if ((buffer_heads_over_limit && is_highmem_idx(i)) ||
> +				    !zone_watermark_ok_safe(zone, order,
>  					high_wmark_pages(zone) + balance_gap,
>  					end_zone, 0)) {
>  				shrink_zone(priority, zone, &sc);
>=20
>=20
> Patches currently in stable-queue which might be from mel@csn.ul.ie are
>=20
> queue-3.3/mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_he=
ads-pinning-highmem.patch
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAk9z9OcACgkQ3xdJJrLygV4OHQCeNJC4pgLw6zWScLt9E3b/kkab
vwkAni/dh7Fd9UXa3S5zlF38iPA3J0IA
=B5sp
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
