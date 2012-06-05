Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab2FEPfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:35:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50175 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2FEPfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:35:30 -0400
Message-ID: <4FCE273B.50809@nasza-klasa.pl>
Date: Tue, 05 Jun 2012 17:35:23 +0200
From: =?UTF-8?B?TGVzxYJhdyBLb3BlxIc=?= <leslaw.kopec@nasza-klasa.pl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: =?UTF-8?B?QW5kZXJzIEJvc3Ryw7Zt?= <anders@netinsight.net>
CC: dsmythies@telus.net, jrnieder@gmail.com, linux-kernel@vger.kernel.org,
        aman@tmm1.net, a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [3.2.16 -> 3.2.17 regression] High reported CPU load when idle
References: <20120523215359.GA19798@burratino> <20120524214516.GB1158@burratino> <000c01cd3e70$b651dd10$22f59730$@net> <20120530.165426.1421117300206344483.anders@netinsight.net>
In-Reply-To: <20120530.165426.1421117300206344483.anders@netinsight.net>
X-Enigmail-Version: 1.5pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0EF820407E0FDBB2ACF83FD8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0EF820407E0FDBB2ACF83FD8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/30/2012 04:54 PM, Anders Bostr=C3=B6m wrote:

>  DS> This statement: "Starting with 3.2.17-1, the CPU load accounting i=
s broken when the computer is idle. The CPU load is reported as >0.50 whe=
n idle. 3.2.16-1 don't suffer from this problem."
>  DS> In my opinion has the following mistakes:
>  DS> . The computer is not actually idle. If it was actually idle the r=
eported load average would be 0.
>=20
> Well, I tested in single user mode, with very few processes running,
> mostly init, getty, bash and top (+ a lot of kernel threads). And
> 3.2.17 reported a load of >0.5 . Under the same conditions 3.2.16
> typically reports 0.01 or 0.00 .

I've tried to reproduce the problem, but haven't had much luck. I've
tested vanilla and Debian kernels versions 3.2.16 and 3.2.17. Load on an
idle or slightly busy system is the same across all versions.

vanilla 3.2.16		0.15 0.07 0.06
vanilla 3.2.17		0.17 0.11 0.13
Debian 3.2.16-1		0.13 0.07 0.05
Debian 3.2.17-1		0.10 0.09 0.11

When the system is completely idle load drops to 0. I've also tried
3.2.17 with 556061b00c9f, but it makes no difference and in comparison
to plain 3.2.17 load is the same even on a busy system.

I can't explain why we're getting different results on the same kernels.
If you'd like more details just ask.

--=20
Les=C5=82aw Kope=C4=87


--------------enig0EF820407E0FDBB2ACF83FD8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk/OJzsACgkQNZJfI+JDs2Lz8wCffCqIX/xfyjepItgi8yu03QLD
OyYAn05c6laPzMX1CwbfgSQ+gxaotn34
=F1jZ
-----END PGP SIGNATURE-----

--------------enig0EF820407E0FDBB2ACF83FD8--
