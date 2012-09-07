Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2IGGsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:48:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2IGGso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:48:44 -0400
Date: Fri, 7 Sep 2012 16:48:33 +1000
From: NeilBrown <neilb@suse.de>
To: clplayer <cl.player@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Content Of Files May Be Changed After One Disk Is Failed In
 RAID5
Message-ID: <20120907164833.540cf96d@notabene.brown>
In-Reply-To: <CAOHz195Bhfs5Rx-qd2BmO8N4cqrdjCXDuXwF5QjNf6mVSS9Y8g@mail.gmail.com>
References: <CAOHz1948UduxDDvpA33T9BaM4QoMpwF1wAQKjY3UgSSOOy6k8g@mail.gmail.com>
	<20120907123348.798dfc28@notabene.brown>
	<CAOHz195Bhfs5Rx-qd2BmO8N4cqrdjCXDuXwF5QjNf6mVSS9Y8g@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4/2zygM/uEO5PM_V1IBf6ug"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4/2zygM/uEO5PM_V1IBf6ug
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Sep 2012 14:30:56 +0800 clplayer <cl.player@gmail.com> wrote:

> > --assume-clean is not safe with RAID5 unless the array actually is clea=
n.
> > It is safe with RAID1 and RAID6 due to details of the specific implemen=
tation.
> > So I suspect that is the cause of the corruption.
> >
> > NeilBrown
> >
>=20
> Thank you for the information.
>=20
> I have removed --assume-clean in the script and executed the stress
> after that raid5 completed resync.
>=20
> The files are all consistent in the rest tests.
>=20
> I am now wondering, what's different between the implementation of
> raid5 algorithm and of raid6 algorithm?
>=20
> Would you please suggest some hints in the implementation?
>=20
> Thank you,
> Peng.

RAID5 will sometimes update the parity block by=20
  read old parity and data blocks
  subtract old data block from parity block
  add new data block to parity block
  write new data and parity.

When it does this, if the parity was wrong before, it will still be wrong
afterwards.

RAID6 doesn't do that, because 'subtracting' old data from the 'Q' parity
block is complicated and hasn't been implemented.  So RAID6 always calculat=
es
the 2 parity blocks from the actual data.  So every time you write a parity
block you can be sure it is correct.

NeilBrown

--Sig_/4/2zygM/uEO5PM_V1IBf6ug
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUEmYwTnsnt1WYoG5AQJWCRAAmeGpquRKG46Mj4lG2zOlswxvO8m6idna
VlhEifHmNaaKgoWOl6VvBK5IjgDD7sUS7k92hRVcQa3PTbbVi480NWhVdPYSalmW
mse0t2yQ8BqYz/gA4aZRf1eVPL44DhTgtWGsG4wNqbrPrHaEaTVPizsEOL6qX8Z6
Pk0vyAE5Er4X1bZBkFl+zl0eNY2AbVmii8DNZZVacptys8Aylq8xwhS2zGrbd48h
F5vQSUyY68VDmxe/HQf9KtrAosvjdneIspya2HZ1jXbNJnhK48BqxctUsnwAXuso
ACFTfgqeySFmeRmRE0vAIz4Av6xRBTzwPty2/wbJUtjWhrMdvSE35KXaPd+qgZ+J
XNQ9zVk1QJY5aFzeBVjMelJNeatBvrjTgmUbqVwcR4/+rml2QHUTkIDeUMVng3fu
MBbjzxJPzXTORnuINi1h+33UtBxVQtRsMTUOmR3Rd8zCa0/13JeC4s0Obs+3R5aF
vPBybEFSlURt4w3TEiGryreR3Vpi3sWy+7LqZEmplU/fXBPt7ocpTSpLU9Mmt1iK
60r4cXQp+ZsrHvZpImkHDc7MwaqBXolO4jggrWmogQ9nkkcjKyFeV6yF+LAROj01
yHfGpTHU5t4KhwFOPuHALpw6EZoOG65F0Dc8CmIZBO1HkrGe10a6rmAcjtrKZQ2i
+NaoypO7URk=
=VqcU
-----END PGP SIGNATURE-----

--Sig_/4/2zygM/uEO5PM_V1IBf6ug--
