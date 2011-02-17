Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1BQDrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 22:47:55 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36254 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab1BQDrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 22:47:53 -0500
Date: Thu, 17 Feb 2011 14:47:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, Michal Marek <mmarek@suse.cz>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-Id: <20110217144743.2db26b27.sfr@canb.auug.org.au>
In-Reply-To: <20110131154259.dca1f7e6.sfr@canb.auug.org.au>
References: <20110131154259.dca1f7e6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Feb_2011_14_47_43_+1100_5mj=Ly8IEcbYmQj4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Feb_2011_14_47_43_+1100_5mj=Ly8IEcbYmQj4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 31 Jan 2011 15:42:59 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>=20
> x86_64-linux-gcc: arch/x86/lib/memmove_64.c: No such file or directory
>=20
> Caused by commit 9599ec0471deae24044241e2173090d2cbc0e899 ("x86-64, mem:
> Convert memmove() to assembly file and fix return value bug") interacting
> with our build system.
>=20
> After removing arch/x86/lib/.memmove_64.o.cmd (left over from the build
> before merging the tip tree) from my object tree, it built correctly.

I am still getting this (of course).

Michal, is there anything that the kbuild system can do for us here?
Basically we have changed from using a .c file to generate a .o to using
a .S but the build system does not regenerate the .cmd file.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Feb_2011_14_47_43_+1100_5mj=Ly8IEcbYmQj4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNXJpfAAoJEDMEi1NhKgbsS7MH/1JoyxFEvYcsvb00pNS/4PvC
rqGX8bkK9caxhyKr7VDlFbv8TOFeC1Udp4IhkCM+9xtiBqmgw3cdO8eTNnjJFsjz
hHyJF0PwiXKw9C8O6S6rcssyL14zQiFFaPjcoGmSJe4JHM1hqs5JT3exGDjDrewP
kY7cMNa4B5r2PxBAeJ3tQy1n1zLaLD0wNsO1dI5wBFnUR+k6wBBPqliP+nrGGii1
9RlpWKuSdnq1tOOf7X+qOYysAKxawBc7o2iPtQUc3PQujWWVMs7bK6mbtYlHOgED
Isrexy25UAvuvl3aigKycXB2VB0HKk/zjtGl3O8c7zKKnAxQ0bmD/cCUJaEm4EQ=
=FNcR
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Feb_2011_14_47_43_+1100_5mj=Ly8IEcbYmQj4--
