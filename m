Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab1IJIRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 04:17:49 -0400
Received: from swan.madduck.net ([80.68.90.58]:48406 "EHLO swan.madduck.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758479Ab1IJIRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 04:17:46 -0400
Date: Sat, 10 Sep 2011 10:17:40 +0200
From: martin f krafft <madduck@madduck.net>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Seed /proc nodes before they are created
Message-ID: <20110910081740.GA6242@albatross.gern.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux wheezy/sid kernel 3.0.0-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear kernel people,

I've been trying to come up with sensible ways to control the
settings exposed via procfs for years. I have tried everything
between sysctl, systune, writing values directly wit hooks, and even
using puppet to manage the "content" of the procfs "files".

Unfortunately, none of the solutions are satisfactory, really. If
I run sysctl during boot, it either runs too early (some modules not
yet loaded, or some interfaces not yet available) or too late
(networking already set up). Using hooks and manually writing procfs
nodes just feels like a hack and it's prone to errors, and puppet
is a nightmare =E2=80=94 and only runs at intervals, so it leaves periods of
time in which the system might be in indeterminate states.

It occured to me that there might be a very simple solution to the
problem: couldn't I "pre-write" procfs (and sysfs) nodes, i.e.
create the nodes and write a value to them, and then, as soon as the
kernel learns about a setting, it uses the pre-written value to
initialise its internal representation of the value?

With this in place,

  - I could enable forwarding on certain interfaces long before they
    are brought up;

  - I could set RTC parameters before the module is loaded on
    demand;

  - I could disable rp_filter and enable e.g. IPv6 autoconf on my
    PPP interface before I start pppd;

etc.

Obviously, I could also abuse this to store arbitrary content in the
kernel memory space, but a creative root can do that anyway, and
a size limitation on individual nodes would limit this.

The implementation is probably not even too hard, since I am
assuming (but I do not know), that procfs nodes are somehow
centrally managed in the kernel.

What do people think about his idea?

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"menschen, welche rasch feuer fangen,
 werden schnell kalt und sind daher im ganzen unzuverl=C3=A4ssig."
                                                 - friedrich nietzsche
=20
spamtraps: madduck.bogus@madduck.net

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQLvBAEBCgDZBQJOax0dwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xHZl
EADKNepb8bkH1VBgPlXUEtXh57MqSmXBat76hehNx1mWIk6BTM14MhYUij6emklN
I/xNVVCsVQqeN0HRF02FOGRMtwNu7xX08uFFix/1OBcVYQRW4vUFDNnRxvJPmCMm
vGZhcijMeiCAjVZHktK5a041rLDqDlk6DpyJLT6Czfqz+g+1GmCyNdbLs2bUhOOD
w1wmGWAASjw1vk6Cz5WYY6MClJ71d94aCp4vAYwJE08rHGrcTcNDiS0e+kb/RLNg
/5uCN55lt8NjNxMeaS3/knzM6vBZtYETv1cjI0bWTJp+8N5y0DZYvNCitn5WXdtl
66Wld1ISiU0hdy++7UFv3kJ9QiGeqoOjRCzk2CBQbOAf5I3zHDDM7bPu7/Kj0vRo
aSpg5VZSvwl4UzBBdGNm2A/CN3POiqlTnNP8nNr2O6mUC/hRF1fjfzRnF+j+DrU4
/VsDcdWb6wJ2bbBitqCZiebeEK3BgplK4CsLhz4DWWYDaaNWykqqA/dXytabfphS
IkSzmIQIkSV8tZUALe3575AdKySZ35fRYE+lt2Yp2uRvOMZSgTwGPYjSrjvUFA6+
V2dKwc5s1pWAGCBpSMS/5V7l4ZToneEywJY3Tas5osFuahSDn+lkFjnc3gT9ZARE
ZnftPvsjYGXbJJu10uMuTrzVxE2GXcYFbPh3du6j1rYLWQ==
=EOxM
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--

