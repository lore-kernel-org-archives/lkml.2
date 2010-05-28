Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab0E1A51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:57:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34477 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab0E1A5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:57:25 -0400
Date: Fri, 28 May 2010 10:57:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: linux-next: build failure in Linus' tree
Message-Id: <20100528105719.a356ba4f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_May_2010_10_57_19_+1000_bB8D7b4aL/bCa0jj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_May_2010_10_57_19_+1000_bB8D7b4aL/bCa0jj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the gcl-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/built-in.o: In function `.copy_process':
fork.c:(.text+0x14c34): undefined reference to `.__node_random'
fork.c:(.text+0x14c44): undefined reference to `.__node_random'

Caused by commit 0ac0c0d0f837c499afd02a802f9cf52d3027fa3b ("cpusets:
randomize node rotor used in cpuset_mem_spread_node()").

This commit assumes that __node_random() exists if (MAX_NUMNODES > 1) and
uses it if CONFIG_CPUSETS is set, but only creates it for x86 ...  there
is at least one other architecture where those conditions are true.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_May_2010_10_57_19_+1000_bB8D7b4aL/bCa0jj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv/FO8ACgkQjjKRsyhoI8xBSACfa71X4OK2XoP7Mf3X6VHjpEUH
X/gAoLkJZExWOASMHhyJWjO0T2DhRBZm
=rO3u
-----END PGP SIGNATURE-----

--Signature=_Fri__28_May_2010_10_57_19_+1000_bB8D7b4aL/bCa0jj--
