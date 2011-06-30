Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab1F3Nkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:40:32 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:36936
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974Ab1F3Nk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:40:26 -0400
Message-ID: <4E0C7C95.4070803@akkadia.org>
Date: Thu, 30 Jun 2011 09:39:33 -0400
From: Ulrich Drepper <drepper@akkadia.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        viro@zeniv.linux.org.uk, wilsons@start.ca
Subject: Re: [PATCH] Add cloexec information to fdinfo
References: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com> <BANLkTin7wm6m5bN4CfQzhJZuhy3bUrS80A@mail.gmail.com> <4E0ADF27.5070805@akkadia.org> <BANLkTi=dQRi82gkDwtR3Kh2R7f0uGu7HpQ@mail.gmail.com> <BANLkTi=pUZnhBa9W0eobQ_RWQGtMZ3u6Eg@mail.gmail.com> <4E0BE6A9.3040708@akkadia.org>
In-Reply-To: <4E0BE6A9.3040708@akkadia.org>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2FC9E39817A14CB54FBA2EEC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2FC9E39817A14CB54FBA2EEC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/29/2011 10:59 PM, Ulrich Drepper wrote:
> It provides the information, yes, but it also hides some information.
> If you do it this way we cannot distinguish code which uses O_CLOEXEC a=
t
> open-time from uses of fcntl(FD_CLOEXEC).

One more reason to at least not use the patch as you have it right now.
 If a file descriptor was opened with O_CLOEXEC but subsequently the bit
has been reset using fcntl() the f_flags value would still have the
O_CLOEXEC bit set.

If you don't like the separate cloexec line, at least reset the
O_CLOEXEC bit in the f_flags output if the FD_ISSET() test returns zero.


--------------enig2FC9E39817A14CB54FBA2EEC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk4MfJUACgkQ2ijCOnn/RHQ6+wCeIbTGJMsCdZMmgoTcoA4zJ7OV
jO8AnjCG10sjrlVGSnXNO4qeCdDf23B9
=cwn2
-----END PGP SIGNATURE-----

--------------enig2FC9E39817A14CB54FBA2EEC--
