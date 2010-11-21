Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0KUBFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 20:05:53 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:33675 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab0KUBFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 20:05:49 -0500
X-Spam-ASN: 
Date: Sun, 21 Nov 2010 04:05:31 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv4 13/17] ntp: add hardpps implementation
Message-ID: <20101121040531.5c7ba047@apollo.gnet>
In-Reply-To: <20101120162718.GF13356@enneenne.com>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	<2783e9e632882e211abde03e9b4ad89a336fd167.1290087480.git.lasaine@lvk.cs.msu.su>
	<20101120162718.GF13356@enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/UBBg+sCib6A9H/W64mL+0OT"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UBBg+sCib6A9H/W64mL+0OT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Sat, 20 Nov 2010 17:27:18 +0100
Rodolfo Giometti <giometti@enneenne.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Thu, Nov 18, 2010 at 07:01:06PM +0300, Alexander Gordeev wrote:
> > This commit adds hardpps() implementation based upon the original one
> > from the NTPv4 reference kernel code from David Mills. However, it is
> > highly optimized towards very fast syncronization and maximum stickness
> > to PPS signal. The typical error is less then a microsecond.
> > To make it sync faster I had to throw away exponential phase filter so
> > that the full phase offset is corrected immediately. Then I also had to
> > throw away median phase filter because it gives a bigger error itself
> > if used without exponential filter.
> > Maybe we will find an appropriate filtering scheme in the future but
> > it's not necessary if the signal quality is ok.
>=20
> This patch (and follows) adds a new functionality to PPS subsystem, so
> let me suggest to you splitting in two parts this patch set: a first
> patch set who fixes up the current PPS implementation, and a second
> patch set who adds kernel consumer (and follows).

But the patches that add hardpps and parport client+generator depend on
the previous ones because the latter change lots of things in PPS
subsystem. I don't want to maintain them separately because we use all
of them in the production.

However I can tell here that it'll be ok for me if not all the patches
enter mainline at the same time. For example, patches 1-3 are already
ACKed and are actually bugfixes (patch 2 is trivial and patch 3 depends
on it) so I think they could be merged in the next rc. I placed them
in the beginning exactly for this reason. Whom should I mail them?

Same thing with other patches. Smaller patchset -> me (and probably
users) more happy. :)

--=20
  Alexander

--Sig_/UBBg+sCib6A9H/W64mL+0OT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJM6HBbAAoJEElrwznyooJbSlkH/jrljGE55aDULgacVSRmFa39
xjZmP4LB39SZ5t+WEHTKHHjNhSKICtfDAvKSUXAem9f48ho0NQ/A27Uul0qVH8bJ
F0TgTacyzQhKfeanTjeAGeDwWU/zbuhbMFtgVgm5rTkefx1N/pFaAnZ729eGYCAh
nPXKuGmg/D7aRHVRneeupm+YqIn4MHIumtdIQ//tNn0lQB9jH6Ola40XnzQlAMjB
ss54mAUusuQ+8hkm3map1wYXLAqg/9MVb1QkkfQlWEa7M9TANpOoWawSi0Z7H8nA
ddjt2T/Krt37+fGnjQDg2mY8gzigMv0RUFxbHvJKB08+XulKEXPL31ACEtEk0Gk=
=aOR8
-----END PGP SIGNATURE-----

--Sig_/UBBg+sCib6A9H/W64mL+0OT--
