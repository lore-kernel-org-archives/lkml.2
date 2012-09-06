Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab2IFHMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:12:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53602 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab2IFHMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:12:05 -0400
Date: Thu, 6 Sep 2012 17:11:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>
Subject: linux-next: build failure after merge of the final tree (powerpc
 tree related)
Message-Id: <20120906171153.c80e87ea8db3dd3f4ac87cf5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Sep_2012_17_11_53_+1000_9qgwl6mOfInQ1Z19"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Sep_2012_17_11_53_+1000_9qgwl6mOfInQ1Z19
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

In file included from drivers/atm/fore200e.c:70:0:
drivers/atm/fore200e.h:263:3: error: redefinition of typedef 'opcode_t' wit=
h different type
arch/powerpc/include/asm/probes.h:25:13: note: previous declaration of 'opc=
ode_t' was here

Caused by commit 7118e7e648e0 ("powerpc: Consolidate {k,u}probe
definitions") from the powerpc tree.

I have reverted that commit (and the two following:
41ab5266c362	"powerpc: Add trap_nr to thread_struct"
8b7b80b9ebb4	"powerpc: Uprobes port to powerpc")
for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Sep_2012_17_11_53_+1000_9qgwl6mOfInQ1Z19
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQSEy5AAoJEECxmPOUX5FEo0EQAIALijyHzcSPJTpOkXOC5al6
1hc+LVqeBwRSwuLJyXObyXTIIU1C9kaDB3ziJ0Ji2WXG7M8FEHf8K8q1xbw6fQ8A
whcIZjVlZ7gfj+l31iFGsLqMI2sZq1V1Pk2/zuZst7HrDS3AsDLxQY7xRSIW7W+u
nSLrzrIFA1n9r0SVhtelVNSUE471g4kJ7ww4aI8rig72m08zD/AzfK9zFkHxhH00
4LXIHqTYhWTsMIhk79UirBFWLyinKStS7uCIfBF2Cxxlqao0mrrPlEDTd3VBRiEk
IgHVzu4lQ+pquI0Fk7IjbkmxGWyMsR3X1cyt6tl9EAuy95iW/HIB8H02heL2ka0U
v55XAibbgn04WTlLROZFRSyWlsGXg7Fp/yL83x2lHpbysBlO+vNk9uFt1kugMcU6
9nW75BpyDQWoHQbOZFoK+N5NChw0qEyZz4iCMBuj44BGY9XJgRaR0Se2nOh2D6co
6tCDBsPM8r+tUEsnZ2/W1EmzLmw1xg+R/SnrxaYPIbJUZhS/B5FRIiZhadNJHFbF
02GC63qd3S5GxbWRFY5QCM5XIBU0e2kKNBga8czTxNr619ehXnUiZ/C/4rdfRJyQ
OVfAKCYmSctefKyKo4ITfW4+AbLJlBSCN7609lrpR/ykcMLJ67dky1oLaOCViEfc
jTogHNotM+TNnccFAWrO
=xExw
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Sep_2012_17_11_53_+1000_9qgwl6mOfInQ1Z19--
