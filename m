Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab1EYD2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:28:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33044 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab1EYD2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:28:18 -0400
Date: Wed, 25 May 2011 13:28:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-next: build failure after merge of the final tree (kvm tree
 related)
Message-Id: <20110525132809.6d85b3c2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_May_2011_13_28_09_+1000_AA6nfbQujQQ0vpSt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_May_2011_13_28_09_+1000_AA6nfbQujQQ0vpSt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

cc1: warnings being treated as errors
arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function '__kvm_set_memor=
y_region':
arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:654: error: cast to pointer f=
rom integer of different size
arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:654: error: cast to pointer f=
rom integer of different size

Caused by commit 95de6ce677d6 ("KVM: add missing void __user * cast to
access_ok() call").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_May_2011_13_28_09_+1000_AA6nfbQujQQ0vpSt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3HdJAAoJEDMEi1NhKgbsyIwH/1GCApV7ESIjedC7pIWTQKI6
B9tMR8+yNj0jm8XJ64LVU7UrvRIkHEQjobKZ0BF93+zSkiywYzknCiurLAA5jlt5
R1OPdJJ2aK+LJGc6YNCPpDXMaLeAWFZQ0zkic3FGiB3G3nqhWTO53MKmY507TZQ1
LuQcx2slhHA6+XDVQhtk2GZ8NZxg/djztfreJEc+5Qje75Th334rBk5k8jWSBdtM
CCYUNvneyzV0Ns5dHSjfy5RTjZ1r/aoI+w/ZntJNy7ui1S+ZelgFaa1WqSP3+4RL
B30wnGdy/ns/aw0h4AUo+uxq90G4jAj7UywLtm/l/aoaIdfC/80jdVs7fzLo7RQ=
=Mj0u
-----END PGP SIGNATURE-----

--Signature=_Wed__25_May_2011_13_28_09_+1000_AA6nfbQujQQ0vpSt--
