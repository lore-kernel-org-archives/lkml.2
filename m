Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab1JGUmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:42:51 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:56554 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754473Ab1JGUmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:42:49 -0400
Date: Fri, 7 Oct 2011 16:42:47 -0400
From: Eric B Munson <emunson@mgebm.net>
To: eranian@google.com
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, anton@samba.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hbabu@us.ibm.com
Subject: Oprofile Regression Caused by commit
 e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25 on PPC
Message-ID: <20111007204247.GA5444@mgebm.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This commit seems to have caused a regression with oprofile.  It is fairly easy
to trigger, simply run oprofile monitoring an event that will fire (something
frequent like CPU cycles) causes oprofile to fail saying that the PMU is in use.
If I disable CONFIG_CGROUP_PERF, everything goes back to working.  I suspect the
problem is that the PMU is being initialized without being reserved for perf.  I
am not yet sure of the right fix yet so if you have any suggestions I would
appreciate them.

Eric

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOj2RHAAoJEH65iIruGRnNMZoIAM6Si87Hl2r6AEz3ur4qKA6q
F+Ss7ATTl2b5QdqI8vlPjO86xBn89Rjr6cazxQDXqm4fgRphZg/Pa3DGZ8gXTJhB
yA9alOaYg5r19W2FuSRbob403qTikpMlDFyeYq8QOqV9sE4UevoYzwVkLrkYVtAf
tZFBWCRMJ6Du8O/n0aAVG1uk95WWkIIor1ZO+37kq7zc8w4p9ZVgh5kj5uTEmUDC
I8aVkATIITr76VPhvkhSaSreeJDlsqm+Hv1JISKn+yvaxj32I32U//s8h4XS73sH
FHgFKKGTiKdDnHgP1UcRpFW6jdUamJpaHbGpJx/v/2j9nrEepsaxPSkl7DoxS3Y=
=zfK+
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
