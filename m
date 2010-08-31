Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab0HaDSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 23:18:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54274 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756698Ab0HaDSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 23:18:18 -0400
Date: Tue, 31 Aug 2010 13:18:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: linux-next: build failure after merge of the final tree (net tree
 related)
Message-Id: <20100831131812.1b8eb758.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__31_Aug_2010_13_18_12_+1000_CPuavcD+cMDqTMXK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_Aug_2010_13_18_12_+1000_CPuavcD+cMDqTMXK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/starfire.c: In function 'starfire_init':
drivers/net/starfire.c:2081: error: negative width in bit-field '<anonymous=
>'

This is:
	BUILD_BUG_ON(sizeof(dma_addr_t) !=3D sizeof(netdrv_addr_t));
in starfire_init().

Immediate cause is commit 56543af9563d91c1c5596a7980b416389bdea071
("starfire: use BUILD_BUG_ON for netdrv_addr_t").

The real cause is the complete mess at the start of starfire.c that
tries to determine if dma_addr_t is 64 bits or not ...

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__31_Aug_2010_13_18_12_+1000_CPuavcD+cMDqTMXK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMfHR0AAoJEDMEi1NhKgbs/uMH/1OY+6NldYt2vDwCQ8oGx6nh
XtBcXoCpMVKqzXgdL5qJXtGDmrKZRezx8JXUX2HrHGb4QjRZaMm5iCwTQI4V63/D
tcthEf14nlvpA0YsWtGCjZDj/KXZoIrixVmy1gWLp8tb/gXnLOkCfqeTCw9gyGiW
ZXGcwrERhzVU/aOUyXJ/COcfCtCAjns2wa7ay6wx79itokHyiNaVMhhyC7OrPILe
4BZpjH7ElXtHq3qSnBd752ReoSEglPJrRW8Y27m/evGZNWZdVk/EHdHwFUifFJDk
MnxjpDElZVygWLn6v+paUPqd6RDE//VF8nqtGlyFSXfAwwez8vmyDvbW1hnXC2s=
=bBvr
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Aug_2010_13_18_12_+1000_CPuavcD+cMDqTMXK--
