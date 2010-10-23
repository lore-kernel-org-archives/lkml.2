Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0JWCNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 22:13:44 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54214 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab0JWCNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 22:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Qa3uC4U9jhJpg7h4+r3aTpd+WtLmFxlV5Ni/kxoKJGyq2/X2Itk7lQzF9s1t/cl9NK
         datcNhNHyBG8s6IUzm94XGTHVdETLyzvwTM205VLZJEjNxZaYERfmjBujESm7IZgVkek
         LEDstuVa1J99aLiNckZBJd0nv/g4iMi39GmXM=
Date: Fri, 22 Oct 2010 22:13:38 -0400
From: tmhikaru@gmail.com
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101023021338.GA8205@roll>
References: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com> <1287788622-25860-1-git-send-email-venki@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <1287788622-25860-1-git-send-email-venki@google.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 22, 2010 at 04:03:42PM -0700, Venkatesh Pallipadi wrote:
> (Sorry about the subjectless earlier mail)
>=20
> I started making small changes to the code, but none of the change helped=
 much.
> I think the problem with the current code is that, even though idle CPUs
> update load, the fold only happens when one of the CPU is busy
> and we end up taking its load into global load.
>=20
> So, I tried to simplify things and doing the updates directly from idle l=
oop.
> This is only a test patch, and eventually we need to hook it off somewhere
> else, instead of idle loop and also this is expected work only as x86_64
> right now.
>=20
> Peter: Do you think something like this will work? loadavg went
> quite on two of my test systems after this change (4 cpu and 24 cpu).
>=20
> Thanks,
> Venki

	I'd really like to be able to help test this, but with a 32bit x86
machine I guess this patch won't do anything for me. How hard would it be to
mangle this into working for my machine or should I just wait?

Tim McGrath

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTMJE0pEncCrqzVruAQIdngf9F8v8GocuBmyOr5JK62O/sD516hUzrM8/
s+KLJpGhuANylYkax7ESx3iGci5VvGfEKmH0iDU1mHEs11w3lFD0n392sGbK9mJf
m7YpjAhXtp/phlYFDR7u1D+nrcxegDOET12qm6sXEVzhppdjMQ88AJPi2mAoBMIX
LGw641kDn/BXboSHHhxzRaSIhH2oDVYxB9DgJBtFIx295cU10BBXmw1Fmo1yRUDF
/hwgHdKR3c6sYpPBJGqR0rb1g1uv/rNHkJYOB/DYdyh1cDeMau0aVm6xPxsL2RRO
D9Lcuvi6QWgqY9y7p70D+lu7zmUnjbLonEJTRmjBaimc1X37J2kN4A==
=ApqI
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
