Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab1JEVS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:18:58 -0400
Received: from 74-92-214-37-Colorado.hfc.comcastbusiness.net ([74.92.214.37]:36974
	"EHLO zlynx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1JEVS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:18:57 -0400
Subject: Re: Samsung Series 9 won't resume
From: Zan Lynx <zlynx@acm.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 05 Oct 2011 15:19:50 -0600
In-Reply-To: <4E895EC3.3050800@linux.vnet.ibm.com>
References: <1317329529.3151.10.camel@knife> <1317413360.2629.2.camel@knife>
	 <4E895EC3.3050800@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-AkcoBYU5YCsh31qug3qr"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1317849598.549.11.camel@knife>
Mime-Version: 1.0
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20111005/1RBYrU-0005d8-Pd-linux-kernel@vger.kernel.org:zlynx@acm.org:74.92.214.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AkcoBYU5YCsh31qug3qr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-10-03 at 12:35 +0530, Srivatsa S. Bhat wrote:
> On 10/01/2011 01:39 AM, Zan Lynx wrote:
[snip]
> > Instead it seems to involve reboots, which is crazy. From a cold
> > power-on start, suspend resume will always fail. But if the laptop is
> > rebooted first, suspend and resume appear to work. What the heck? I hav=
e
> > no clue how to debug this.
>=20
> Could you provide any error logs you found? That could give us a clue as =
to
> what is going wrong...

Sorry for the delayed response.

No, there were no error logs. I even tried the suspend debugging which
is supposed to write into the clock registers. =20

The symptom is that suspend appears to work correctly. Everything powers
down and the power light slowly flashes on and off. When the power
button is pressed to trigger resume, the fans come on, the power light
comes on full, but there is no hard drive activity and the screen does
nothing.

After forcing a power-off and rebooting, when using the "echo 1
> /sys/power/pm_trace" trick, the system has nothing in the dmesg about
resume failures. I have to wonder if it even started executing the
resume.

Other interesting info is that I have the laptop using UEFI and the
default reboot causes a kernel panic, so I have the kernel option
"reboot=3Dk" set.

I just thought of this, could the EFI services be messing up the RTC
programming that pm_trace uses?

I suppose that I should also test suspend resume without UEFI, in BIOS
mode. Such a pain.
--=20
Knowledge Is Power
Power Corrupts
Study Hard
Be Evil

--=-AkcoBYU5YCsh31qug3qr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk6MyfYACgkQ1IRuMHS+h7HgIQCghOxOTGLRNdx0AIc51Lgfl6D7
LWcAn1sE9QTmT2PO8GgUHfP5FovBBtZ8
=6jmI
-----END PGP SIGNATURE-----

--=-AkcoBYU5YCsh31qug3qr--

