Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab0IPEwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 00:52:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56280 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab0IPEwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 00:52:49 -0400
Date: Thu, 16 Sep 2010 14:52:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the irqflags tree
Message-Id: <20100916145243.6656cfba.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Sep_2010_14_52_43_+1000_Lq7gl2ZvcBDgs9Uy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Sep_2010_14_52_43_+1000_Lq7gl2ZvcBDgs9Uy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

After merging the irqflags tree, today's linux-next build (x86_64 allmodcon=
fig)
failed like this:

arch/x86/xen/spinlock.c: In function 'xen_spin_lock_slow':
arch/x86/xen/spinlock.c:227: error: implicit declaration of function '__raw=
_local_save_flags'

Caused by bd7712423fe88b35e4e107a820589406db26a72a ("Fix IRQ flag
handling naming").

I am impressed ... 3 Signed-off-by's, 1 Tested-by, 13 Acked-by's, 2
Reviewed-by's and still an x86_64 allmodconfig build fails.  :-)
[Sorry, I couldn't resist and, yes, I do realise that this patch covers
many architectures and that this statistic is irrelevant]

I have dropped the irqflags tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Sep_2010_14_52_43_+1000_Lq7gl2ZvcBDgs9Uy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkaKbAAoJEDMEi1NhKgbsOAoH/jlXrSU+YjWwIYe999xlRFEI
X1AyT7jljzEWQjt0fctMFepDwuLtxwajiqzviUfFOrU3Ob609Gu2aHVWG+g/Xe8G
C5Q9yDV2VO+akuEI9bMMdKAgvQXC3skq0aymjRpGyWSWFMGtbV9NdcwQojUCLeSb
u3klNl1lf0M65RwpSUoHp5oII2EwaZQRYHarZZPq1FrPAkM6kE5PkpOGJwrSzvF8
OC5M3F9IaXN2obMXDJajTkfO5u3lL2wAsSCvwgEXuGn1KyKlK9/egLnx49AzUGYJ
02tcNP2kNMehx+KulZFUFKeaXs77+lDIpwqAett7glKsjBkNdbwwdo1cHgQ/U4o=
=iZwN
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Sep_2010_14_52_43_+1000_Lq7gl2ZvcBDgs9Uy--
