Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1EXOKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:10:03 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47115 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932326Ab1EXOKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:10:00 -0400
X-Sasl-enc: Peg+O6qgPEwIYjByEfeuOkGXwWvgeLO3ky2DFqLfcI1J 1306246199
Message-ID: <4DDBBC35.4010605@imap.cc>
Date: Tue, 24 May 2011 16:09:57 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Florian Fainelli <ffainelli@freebox.fr>
CC: Greg KH <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] TTY: export NR_LDISC and N_* line discipline numbers
 to user-space
References: <201105241043.03347.ffainelli@freebox.fr> <20110524124044.GD31517@suse.de> <201105241517.23166.ffainelli@freebox.fr>
In-Reply-To: <201105241517.23166.ffainelli@freebox.fr>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1A0D1E3D93FDA1D4178862FE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1A0D1E3D93FDA1D4178862FE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 24.05.2011 15:17 schrieb Florian Fainelli:
> On Tuesday 24 May 2011 14:40:44 Greg KH wrote:
>> On Tue, May 24, 2011 at 10:43:03AM +0200, Florian Fainelli wrote:
>>> From: Florian Fainelli <ffainelli@freebox.fr>
>>>
>>> Since commit (4564f9e5: consolidate line discipline number definition=
s)
>>> the patch moved all line discipline number from a per-architecture
>>> termios.h to a shared one: tty.h. However, prior to this consolidatio=
n
>>> work, the line discipline numbers were outside of an ifdef
>>> __KERNEL__/endif block so these numbers used to be exported to
>>> user-space.
>>>
>>> Since such numbers are kernel ABI anyway, and tty.h is already includ=
ed
>>> for user- space header processing, just move these relevant defines
>>> outside of the ifdef __KERNEL__/endif block in include/linux/tty.h.
[...]
>> Meaning, why has it taken this long for anyone to notice?
>=20
> - long standing user-space applications such as pppd got their N_PPP lo=
ng ago,=20
> and do not have to worry about N_PPP being renumbered so they can just =
define=20
> it in pppd's sources it won't break

Also, I just checked on openSUSE 11.2, which comes with kernel
release is 2.6.27, and it still defines the LD numbers in
/usr/include/bits/ioctl-types.h (included from sys/ioctl.h).
I guess other distributions are doing the same, so their users
wouldn't notice the change.

Anyway, the patch is fine by me. Feel free to add:

Acked-by: Tilman Schmidt <tilman@imap.cc>

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enig1A0D1E3D93FDA1D4178862FE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk3bvDUACgkQQ3+did9BuFt3jgCgiSr9CUUz03fevgcfsYqkDtyw
icYAnjwHVLMwtT0W+AE3cqbov8GQmX+Q
=AMO1
-----END PGP SIGNATURE-----

--------------enig1A0D1E3D93FDA1D4178862FE--
