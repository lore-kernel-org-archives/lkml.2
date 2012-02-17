Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab2BQKUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 05:20:50 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43631 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2BQKUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 05:20:48 -0500
Date: Fri, 17 Feb 2012 21:20:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20120217212037.0859c427418b73b2cb17428d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Feb_2012_21_20_37_+1100_.F8CEvWcVe.plEaP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Feb_2012_21_20_37_+1100_.F8CEvWcVe.plEaP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next fails to build (s390 allnoconfig) like this:

In file included from arch/s390/mm/maccess.c:15:
include/linux/gfp.h: In function 'gfp_zonelist':
include/linux/gfp.h:267: error: '__enabled_CONFIG_NUMA' undeclared (first u=
se in this function)
include/linux/gfp.h:267: error: (Each undeclared identifier is reported onl=
y once
include/linux/gfp.h:267: error: for each function it appears in.)
include/linux/gfp.h:267: error: '__enabled_CONFIG_NUMA_MODULE' undeclared (=
first use in this function)

and many more.  This also happens in other architectures and configs but
(obviously) not all builds.

Presumably caused by commit 053361e1a072 ("mm: replace NUMA_BUILD with
IS_ENABLED(CONFIG_NUMA)").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Feb_2012_21_20_37_+1100_.F8CEvWcVe.plEaP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPin1AAoJEECxmPOUX5FEENEP/2vnZNeHkVzoaeDqQ7Kcp+qw
EjrPMxPzeHyjooOcpPJlHQx7XM8F7wf1dhcrlwdFKA35pk8H9pRDIR3XDjMtMxyO
mrKoblwQ6kGcHmcA3WK4QJ3nMHI/vAQHHKI9A4KbTyxojW2JHE5t4SDY/IG0OV17
rZkr8ejuwVfXdNkpBWoc8O6+IYF7PDXJXYyftGerT3Yw/7/g4i5hx9mPFOU9jtSi
dJSkUHt9zZEubBEQdelhObM1gpuJKSkxxoFwYAfUYygjvw6UI13sVYRaTCA1RHUr
gcFvFJQBO9XUcnIvcMa7cC1yhMO5Nxlnr4bGW5BLpuwp6QV/2snEkbYm/tP/BV7P
TinmLCSSLia3TCCI3nhy8RRwC7JpvIZ2eI6P5+bhvWZXvKnFITFjmb7OzEY288Qa
dUvbWzY8G0W1mrrNCPHxXaIn4m8gMW4KTzcA2GeMttyKckP5kGxu2Tdk98XRtFvj
inIS/quqSjSQ5h4VLya2dSmK+QfSTbK9mtmEJcUNGhboMU+vZSL/CAyV8HyDW3fp
RiSVd3KVvrm/DbtuKvmM7HowMLJOnjMGhfvs+hPdAdBy4fWjn2OhPlhIBD/K9X8S
LfP0eXM6xAAeik3sgVd0fXCv29tGM9yg71dFSqd4mXl8BVdVcFmOWHRjwIRsMutR
k36QFLwd21JSaKYZB3wL
=suKi
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Feb_2012_21_20_37_+1100_.F8CEvWcVe.plEaP--
