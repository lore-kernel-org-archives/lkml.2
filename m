Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1LLAbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 19:31:46 -0500
Received: from ozlabs.org ([203.10.76.45]:59420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1LLAbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 19:31:44 -0500
Date: Mon, 12 Dec 2011 11:31:40 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next bad Kconfig for drivers/hid
Message-ID: <20111212003140.GA16353@thor.bakeyournoodle.com>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
	Linux Kernel ML <linux-kernel@vger.kernel.org>
References: <20111209012746.GC20353@thor.bakeyournoodle.com>
 <4EE19DA0.5010705@goop.org>
 <alpine.LNX.2.00.1112120020330.21970@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1112120020330.21970@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 12, 2011 at 12:21:16AM +0100, Jiri Kosina wrote:
> On Thu, 8 Dec 2011, Jeremy Fitzhardinge wrote:
> >=20
> > Hm.  How about making it "depends on HID && POWER_SUPPLY"?  I think that
> > would needlessly disable it if HID is also modular, but I'm not sure how
> > to fix that.  "depends on HID && POWER_SUPPLY && HID =3D=3D POWER_SUPPL=
Y"?

That would work, but I think technically I think you could end up with
HID=3Dm and POWER_SUPPLY=3Dm which would still allow HID_BATTERY_STRENGTH=
=3Dy
which is the same problem.

I don't know what kind of .config contortions you'd need to do to get
there.
=20
> How about making it 'default POWER_SUPPLY' instead?

By itself that wont help as POWER_SUPPLY=3Dm statisfies.

So it looks like we have Jeremy's:
	HID && POWER_SUPPLY && HID =3D=3D POWER_SUPPLY
or my:
	POWER_SUPPLY=3Dy

Yours Tony

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO5UtsAAoJEEsCiJRY75GKpeMP/3Li/WZwB3bWj04BJCKVCvdl
hicwQO9xnYL2ckqkU4Fnd+VZbCsD231rk6IpKTk0fhSPXB6eWHTDa2+wO7BekS4o
6rYBw/KIWEhGnLKfIaIisbZnsG5rLU3R8biI3gL12FqrCfmkMVr7RSW21VAHgrED
g2BLeC+Jp+YLBQmXIC9pSpOxOGbJt/qtlO42gkWivUa918r29W/B8NlPSTuwZHnL
a2syvVFEkWSmSEGKVIJctsKEVRku9QcZ1vk7VlpRvq46giANs8qto+xE60WuJQnA
+l4rlnQK3lUlSP6hZRS0jM+0+T2oirGk0vH2i7AtPuObJM3kdN8nwD9ZxinhBgd/
28vJPUrdCtuMFLxO9ak5MJj2FZ8Qn5BmqOPtYabsoiRyjlRZM3eCOZ5rc0eg9ViK
1yPt/oSPhor9vf/Z/iFkUgjp6PxfBIF7hROUCgE0OzmhuC3usIqQlE7vZs32snrq
dKUQO9a2tZP3tDhpS1Bsn5O1QvnEM10QlIwo8+vueMwKZlZzxbH2Lt71kLDQdxa8
1chdbsdZkJDI7svinzjJqJddVrmqrtxfNcFht9BZblriCSWL9vGxKqK33bUAH7g5
b/AneCeF+yw6Yh4MblSubA3sBFMj1agDWfhItDWigBspF+1Wxrh7FjQXo4BRPSvA
1XCyRy7+/JEOsc1V/dBd
=cVmy
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
