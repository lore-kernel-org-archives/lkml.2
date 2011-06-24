Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab1FXWHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 18:07:39 -0400
Received: from nitrogen.vapor.com ([213.203.212.226]:47246 "EHLO
	nitrogen.vapor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab1FXWHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 18:07:38 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jun 2011 18:07:37 EDT
Subject: [BUG?] numa required on x86_64?
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WJBQhO2Pmz4nmoSdzyrH"
Date: Sat, 25 Jun 2011 00:00:58 +0200
Message-ID: <1308952859.25830.8.camel@pi>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WJBQhO2Pmz4nmoSdzyrH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

Just found this when wanting to play with development kernels again.
Since there is no -gitXX snapshots anymore, I cloned the git =3D)...

But, it failed to build properly with my config:

mm/page_cgroup.c line 308: node_start_pfn and node_end_pfn is only
defined under NUMA on x86_64.

The commit that changed the use of this was introduced recently while
the mmzone_64.h hasn't been changed since april.

commit 37573e8c718277103f61f03741bdc5606d31b07e
Author: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date:   Wed Jun 15 15:08:42 2011 -0700

    memcg: fix init_page_cgroup nid with sparsemem
   =20
    Commit 21a3c9646873 ("memcg: allocate memory cgroup structures in local
    nodes") makes page_cgroup allocation as NUMA aware.  But that caused a
    problem https://bugzilla.kernel.org/show_bug.cgi?id=3D36192.
   =20
    The problem was getting a NID from invalid struct pages, which was not
    initialized because it was out-of-node, out of [node_start_pfn,
    node_end_pfn)
   =20
    Now, with sparsemem, page_cgroup_init scans pfn from 0 to max_pfn.  But
    this may scan a pfn which is not on any node and can access memmap whic=
h
    is not initialized.
   =20
    This makes page_cgroup_init() for SPARSEMEM node aware and remove a cod=
e
    to get nid from page->flags.  (Then, we'll use valid NID always.)
   =20
    [akpm@linux-foundation.org: try to fix up comments]
    Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


--=20
Ian Kumlien  -- http://demius.net || http://pomac.netswarm.net

--=-WJBQhO2Pmz4nmoSdzyrH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk4FCRoACgkQ7F3Euyc51N+J+wCcDSypUKYD6T2gO8fX9I21e63u
P7AAnR4gzoX8sWpoqJnvQ4pdxAClXZ++
=u4F0
-----END PGP SIGNATURE-----

--=-WJBQhO2Pmz4nmoSdzyrH--

