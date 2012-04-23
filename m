Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2DWQUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:20:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37461 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab2DWQUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:20:32 -0400
Message-ID: <4F958141.2000505@nasza-klasa.pl>
Date: Mon, 23 Apr 2012 18:20:17 +0200
From: =?UTF-8?B?TGVzxYJhdyBLb3BlxIc=?= <leslaw.kopec@nasza-klasa.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Aman Gupta <aman@tmm1.net>,
        linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>,
        Damien Wyart <damien.wyart@free.fr>, Kyle McMartin <kyle@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Doug Smythies <dsmythies@telus.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inconsistent load average on tickless kernels
References: <4F465F6E.9070605@nasza-klasa.pl> <1330517195.11248.148.camel@twins> <1330532667.11248.153.camel@twins> <1330534998.11248.158.camel@twins> <4F551ABE.5080605@nasza-klasa.pl> <CAK=uwuxvzGwes4ffy9EXVReG95U3HQaKmPPKgFnHzo_MwaO_NA@mail.gmail.com> <1330989903.11248.261.camel@twins> <1330990360.11248.264.camel@twins> <1330990413.11248.265.camel@twins> <4F8D678C.6050104@nasza-klasa.pl> <20120417153032.GB21534@burratino>
In-Reply-To: <20120417153032.GB21534@burratino>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig304664AF2F9108198CDD441A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig304664AF2F9108198CDD441A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/17/2012 05:30 PM, Jonathan Nieder wrote:

>> Looking at results for 2.6.32.55 branch it seems that we're back at
>> 74f5187ac8 patch - the values are almost the same. The difference
>> between NO_HZ and HZ versions is noticeable.
>=20
> How does 3.0.y + c308b56b53 do?  (I ask because the usual flow of
> fixes is mainline -> 3.3.y -> 3.2.y -> 3.0.y -> 2.6.32.y with the
> first three steps happening pretty quickly, so it we can get this
> working on 3.0.y then that would be progress.  Also because, like
> 2.6.32.y, 3.0.y is longterm maintained, so it might be useful in the
> meantime.)

It seems that load reported by 3.0.28 with and without c308b56b53 patch
is almost identical to 3.2.12. This might be more clearly visible on a
comparison chart. [1]

2.6.32.55-hz-0f004f5a69			9.88
2.6.32.55-no-hz-74f5187ac8		2.48
2.6.32.55-no-hz-c308b56b53		2.22
3.0.28-hz				10.66
3.0.28-no-hz				0.60
3.0.28-no-hz-c308b56b53			4.09
3.0.28-no-hz-c308b56b53 nohz=3Doff	6.78
3.2.12-hz				10.16
3.2.12-no-hz				0.66
3.2.12-no-hz-c308b56b53			4.36

What's worth noting is that I haven't seen any nasty side effects of the
latest patch on all kernel versions that I've tested. Hope that helps.


[1] http://img855.imageshack.us/img855/2204/kernelload.png

--=20
Les=C5=82aw Kope=C4=87


--------------enig304664AF2F9108198CDD441A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+VgUIACgkQNZJfI+JDs2KUVgCgjoFizlcQxCGKGM8vMJ9lMS53
oI0AoIp22+KnHvw+WZbJmLt1PJNw7r/u
=01Qc
-----END PGP SIGNATURE-----

--------------enig304664AF2F9108198CDD441A--
