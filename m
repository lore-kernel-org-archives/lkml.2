Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1KUSvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:51:02 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:60637 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab1KUSvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:51:00 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH RFC 1/5] scripts: Add sortextable to sort the kernel's exception table.
Date: Mon, 21 Nov 2011 13:50:56 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.1; KDE/4.6.5; x86_64; ; )
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-embedded@vger.kernel.org, x86@kernel.org,
        David Daney <david.daney@cavium.com>
References: <1321645068-20475-1-git-send-email-ddaney.cavm@gmail.com> <201111201822.13614.vapier@gentoo.org> <4ECA97A0.3090005@gmail.com>
In-Reply-To: <4ECA97A0.3090005@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart18916016.1oOC3NTRBy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111211350.58916.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart18916016.1oOC3NTRBy
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 21 November 2011 13:25:36 David Daney wrote:
> On 11/20/2011 03:22 PM, Mike Frysinger wrote:
> > On Friday 18 November 2011 14:37:44 David Daney wrote:
> >> +	switch (w2(ehdr->e_machine)) {
> >> +	default:
> >> +		fprintf(stderr, "unrecognized e_machine %d %s\n",
> >> +			w2(ehdr->e_machine), fname);
> >> +		fail_file();
> >> +		break;
> >> +	case EM_386:
> >> +	case EM_MIPS:
> >> +	case EM_X86_64:
> >> +		break;
> >> +	}  /* end switch */
> >=20
> > unlike recordmcount, this file doesn't do anything arch specific.  so
> > let's just delete this and be done.
>=20
> Not really true at this point.  We don't know the size or layout of the
> architecture specific exception table entries, likewise for
> CONFIG_ARCH_HAS_SORT_EXTABLE, we don't even know how to do the comparison.

all of your code that i could see is based on "is it 32bit or is it 64bit".=
 =20
there is no code that says "if it's x86, we need to do XXX".

when i look in the kernel, we have common code behind ARCH_HAS_SORT_EXTABLE=
=2E =20
so you could easily do the same thing:

scripts/sortextable.c:
	#ifdef ARCH_HAS_SORT_EXTABLE
		switch (w2(ehdr->e_machine)) {
		default:
			fprintf(stderr, "unrecognized e_machine %d %s\n",
				w2(ehdr->e_machine), fname);
			... return a unique exit code like 77 ...
			break;
		/* add arch sorting info here */
		}  /* end switch */
	#endif

kernel/extable.c:
	#if defined(ARCH_HAS_SORT_EXTABLE) && !defined(ARCH_HAS_SORTED_EXTABLE)
	void __init sort_main_extable(void)
	{
		sort_extable(__start___ex_table, __stop___ex_table);
	}
	#endif

this way all the people not doing unique stuff work out of the box.  only t=
he=20
people who are doing funky stuff need to extend things.
=2Dmike

--nextPart18916016.1oOC3NTRBy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOyp2SAAoJEEFjO5/oN/WBZg8QAMH4S+K1gxcWKe89lRRxspfJ
MSXIss+znaNDBr+NoA9eIiO8Q4TpmrL1bCaH1UVwVEqjcMJY7IG4igEnP46Gfn0f
aI+D6caMRgQLrgM1Peq5XiWU1MTBrz6NnJN/3lbhlugmg+s+xtn/nFIrlutGRmfR
V/GOVG9jLWiw+qEQ2GphyYd4ggvTigNNKzhqZRN7pC3XOAUBraMnOhxzooMkSW6h
Q3h3+p0taGrtLHB+T5SYo8MG13PLbH6GFaYJjvVOsQSmdFxPEf1acpb8vaD0orPa
Rd+d6q2VRJm4zL/WUB0SGxySPmUFPaTLuWqc8PflHeB0MltDxJL4pgFuxuWem8L2
b1fncRuyFgZPBe60tn84yXJMgbzjKmFFjcBjiHqCElT3kGRcXPIReKY3/TnJUxny
D0f8VAhPYfLdlhmIALq9fcwrpHHbV8S++8XiNQsXT0hzSn6nm7mcbw9t+v5UJ0he
W1fZjyjEyL+dAwhWxMzTb/9aHE5t+7GJFEKw0gfbfpjMCdZOhaEOfYnh28FL3T1I
W+WiCPRo0Nz180xlZy9ia1ac+wm6iLUTzlzmTL9lAXRQMVyydHisbfuJGfNso4aa
6XL1/Vrgq2kSKMfd2WVhgTc8laxJCTkcNhwclBOPuFbaTZPCadUZjxvPsAEgw04L
aTty9vZcJoLu1punJLBl
=ElBK
-----END PGP SIGNATURE-----

--nextPart18916016.1oOC3NTRBy--
