Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1JKJVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:21:51 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:55120 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab1JKJVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:21:50 -0400
Date: Tue, 11 Oct 2011 20:21:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: build warning after merge of the moduleh tree
Message-Id: <20111011202142.4d18840463055a8bdb9d1590@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_20_21_42_+1100_gz_IoKSauGCGkWVV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_20_21_42_+1100_gz_IoKSauGCGkWVV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (i386 defconfig)
produced this warning:

arch/x86/kernel/cpu/perf_event_intel.c:1323:1: warning: data definition has=
 no type or storage class [enabled by default]
arch/x86/kernel/cpu/perf_event_intel.c:1323:1: warning: type defaults to 'i=
nt' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
arch/x86/kernel/cpu/perf_event_intel.c:1323:1: warning: parameter names (wi=
thout types) in function declaration [enabled by default]

Introduced by commit 144d31e6f190 ("perf, intel: Use GO/HO bits in
perf-ctr") from the tip tree interacting with the module.h slipt up.

I'll add a patch tomorrow to add an include of export.h to this file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Oct_2011_20_21_42_+1100_gz_IoKSauGCGkWVV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlAqmAAoJEECxmPOUX5FELHEQAJeir7ffG7n+lPmVHte/BkD/
czFeQutV5I27zT1SgPYxALKwC44jtRUwttAQmdwPb/BMBLK7DPHf58G4M086EBzZ
eIwOpF0AzPVrrbZo6jomGQfyw2j241JfFzHz67rkf1gXQTXKm6hr/nLRXMiTV+TU
bvix+ekzQpcKJtrP55gs4lQtXa9R3V1rs9J/YNXsEUxSVknXgZl5jgT+3aaYiP2V
kNjpiXTSa0xcfvF5LJ1djh54EJa/Ld9RQhFZHhrkQr2R79yLRnaVWUP5JuLjhn3b
4N9XisZxaPKpvuYjDDMwuPiAnS6M2VV2NX+bv2GBDCk13Hibd5Ry1swdNPTTPYYx
CF5f00p8zoEMw1DUU3BZPFEu1GrEEaQQcJ/mbBYscMsoUKJwJBFWNPk7lClXUNNG
OuYoZffoVFA1WbZk4sC0i1LTwSV9JAgYQHph/V6OP1ClAbDgn4Gn1o8nTKOWOmnP
g8bhl6PYBnUMMBCWEf/hbs7NHhbN3qC9jWKaWfAOlXHI74tgGXyHzs+sjpYW/w/w
hFwa84DZneEsOh+lWTTCLMTdUrACR/6irffqIilseXv/J3VRNcEQk4lL8t6bzOEc
bKLR1VCX61o2ttDFSRvH6XAsUoyoPQktwx8doAUMxVBkbWOX5LyhM1/4apEIzm4o
zlf01NoeOFTFqEwj/ow9
=HFBg
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_20_21_42_+1100_gz_IoKSauGCGkWVV--
