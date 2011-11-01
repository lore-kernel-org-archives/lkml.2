Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1KAJZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:25:06 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:46185 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1KAJZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:25:05 -0400
Date: Tue, 1 Nov 2011 20:24:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konstantin Ozerkov <kozerkov@parallels.com>,
        "Denis V. Lunev" <den@openvz.org>
Subject: linux-next: build failure after merge of the final tree (sound tree
 related)
Message-Id: <20111101202452.76723ee949d47fb37a6207dd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_20_24_52_+1100_xD5IS=Gud5yHaOFk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_20_24_52_+1100_xD5IS=Gud5yHaOFk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from sound/pci/intel8x0.c:46:0:
arch/powerpc/include/asm/kvm_para.h: In function 'kvm_arch_para_features':
arch/powerpc/include/asm/kvm_para.h:166:22: error: 'KVM_HC_FEATURES' undecl=
ared (first use in this function)

Caused by commit 228cf79376f1 ("ALSA: intel8x0: Improve performance in
virtual environment").  It should probably be including linux/kvm_para.h
instead of asm/kvm_para.h.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Nov_2011_20_24_52_+1100_xD5IS=Gud5yHaOFk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr7rkAAoJEECxmPOUX5FEgaAQAINnkg1gySuuuR0rqydZSWYZ
N0ktK2AAkrFv2EtLMPRoWxFGLp0Y0wz2rASJWj7Jf/L27kmhE3RY/VikwVVFIeLI
GyZ3yEZ8ryQK4VnKNbRvRnC93IMvPNUxenRvC++ARkpRNaHqDdL7NQGpehHbP11p
tCAlYY3FkSbUZq17r+ToAnvgu6CSME+sRRE3rJ2YLWymy5RXQI9CAMMKhtNp3LTH
RzRQK2kW0UFtSvjB0jcX/ttVPs0w5pHeI9XHAHwzMb3ATbgG+T2HcLOfNyLi54jj
M5a8qBIBNlblj5E1AJEEPlxy7FStGQmqJ+4k/TNuKTIXB74Bpuzq/IcgOF8dXZyJ
TFGyYHq8FqlZWjIgnqSDwmzSPvGRrIKZsRx0Qp3Sqh7AHesJ+h/dN1fpS6yctzBn
FdIQ8fqs3YxKPm+h75SnnXfquVyxu+xvir3glZ3XsFVkaoryO0ydvKi2BxRHXovn
EC4uLrhNe+jnfa4mGoQ1ifEHDk87d9fRQXv57BHscimwiOyinAYBrq7WCTPk6q/e
/UopnoHdqD/ScYq7XU2GN3c6oeD0b+FoaIglydiRXkIxv8g10+S6V69eHq9PNy7R
+mcdLehuqVACVauvn4p0AUr4Yoz2jcufXKlfzlPfV4Q/Sspt78j2HXKYksl/8Qbu
FUb80NTuPMJisaDyMFE5
=dlfx
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_20_24_52_+1100_xD5IS=Gud5yHaOFk--
