Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab2JSDHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:07:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52142 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804Ab2JSDHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:07:06 -0400
Date: Fri, 19 Oct 2012 14:07:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (tip/s390 trees related)
Message-Id: <20121019140702.39b6e85901be2e39254b576a@canb.auug.org.au>
In-Reply-To: <20121018182953.GA20658@gmail.com>
References: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
	<20121018182953.GA20658@gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__19_Oct_2012_14_07_02_+1100_BPIyOvgS7s8bk4GH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Oct_2012_14_07_02_+1100_BPIyOvgS7s8bk4GH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Thu, 18 Oct 2012 20:29:53 +0200 Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >=20
> > After merging the final tree, today's linux-next build (s390 allyesconf=
ig)
> > failed like this:
> >=20
> > mm/huge_memory.c:1424:2: error: implicit declaration of function 'pmd_p=
gprot' [-Werror=3Dimplicit-function-declaration]
> > mm/huge_memory.c:1424:7: error: incompatible types when assigning to ty=
pe 'pgprot_t' from type 'int'
> >=20
> > (see http://kisskb.ellerman.id.au/kisskb/buildresult/7383823/)
> >=20
> > Caused by commit 35d3d3427314 ("s390/thp: select
> > HAVE_ARCH_TRANSPARENT_HUGEPAGE") from the s390 tree interacting with
> > commit 93c9d633bd9e ("mm/thp: Preserve pgprot across huge page split")
> > from the tip tree.
> >=20
> > N.B. Mips also selects HAVE_ARCH_TRANSPARENT_HUGEPAGE as of commit
> > e21a828a1bba ("MIPS: Transparent Huge Pages support") from the mips tree
> > and so will be broken in some configs now as well.
> >=20
> > Anyone have suggested merge fix patches I can apply?
>=20
> Resolved it for now by excluding those changes, will put them=20
> back in once they are fixed.

It looks as though you have not gone back far enough - you removed a
couple of merges of sched/numa, but there are more. I have two of the
problems resolved with merge patches that supply pmd_pgprot() for s390
and mips, but there is another problem with mips (see Ralf's other email).

Also, I suspect that if you do exclude all the sched/numa changes it will
make a mess of Andrew's mmotm (as it basically sits on top of linux-next).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__19_Oct_2012_14_07_02_+1100_BPIyOvgS7s8bk4GH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQgMPWAAoJEECxmPOUX5FE+qIP+wVoKr45ibqRji4b4ghGberU
I/wIl0qscOj5XJZnR5avriMWXoel4ZrG7fgEZS9nZ1/RuRnum7PSmbdVNz6cZROC
brJ18EtaKq6pZOEQXWLg0fOJPh6MbSCD9CE8U8IA+MUrmg1ZT+gy6uyUCzyfORrr
Xx2ItaguNY8lG0bFI9aTRJFwQTosilgXMZA4AtHMmMRHZhsVTkjgw/GolKHvVU9X
l9R46KNyKpEHtYwm8LNo25YkzDhb8vOtcmhbE73BkgqY9hcJ6du+rgmlWMwVGAx7
2occIh5wbttbusSIPLIngpvZ2Uryy28ZwkC526hwp5qRNqYhH11kBW92jFNlRHOP
5bv64BP+yRqHUtkM0G7RgFtH/OTUznfFfl5tYFc5O40ElFutoKGVFypdgJFEzd0e
ByrU7FJPF7Hq8ymszjHuP2Z5bsrJSkoBZCRMs2ZX1nN3ukqHVswi/sjbPsRVYq59
XBW0ugLmZ+yjaGcIsJmV17Xa2WJW4/qOhRmsF7w5M8+e91CmmGWjWgEIZL6RbqEg
+WLRECQpqvnRnvC2C9WnndETlH9NJUQDS2F0K4i3xffDg1OfQS5ThRWMERYintRA
i9PBP1MDOyotbV/WSRqya69RY8a6uvR2xym7Pyv3wwcj5MpanCzLIwWTEyZMucH7
hhFQy0zgGKlDe9iUvy/J
=bjy9
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Oct_2012_14_07_02_+1100_BPIyOvgS7s8bk4GH--
