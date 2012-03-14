Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030548Ab2CNCfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:35:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030499Ab2CNCfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:35:11 -0400
Date: Wed, 14 Mar 2012 13:35:01 +1100
From: NeilBrown <neilb@suse.de>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: qing gu <qing.gu@oracle.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH]: md: Initialize ctl_name field of table
 raid_root_table/raid_dir_table to avoid dump_trace info in debug kernel
Message-ID: <20120314133501.14c6f7e9@notabene.brown>
In-Reply-To: <m14ntsc4k2.fsf@fess.ebiederm.org>
References: <4F5D747D.9060508@oracle.com>
	<20120314125720.1bb87546@notabene.brown>
	<m14ntsc4k2.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TCYezhBqY.Bs82vnX.u+sMj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TCYezhBqY.Bs82vnX.u+sMj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Mar 2012 19:14:05 -0700 ebiederm@xmission.com (Eric W. Biederman)
wrote:

> NeilBrown <neilb@suse.de> writes:
>=20
> > On Mon, 12 Mar 2012 11:58:53 +0800 qing gu <qing.gu@oracle.com> wrote:
> >
> >> This patch is used to dispense trace info when system boots with debug=
=20
> >> kernel. I have verified it on RHEL6.2 & SLES11.2. Both work fine.
> >> In the failure case, system logs that:
> >>=20
> >>     /Feb 21 19:33:55 nsgbj-216-137 kernel: sysctl_check_dir: failed: /=
dev  ref: /dev .7

.....

> > These lines were removed in November 2009 by Eric Biederman in
> > commit 894d2491153a9f8270dbed21175d06fde4eba6c7
> >
> > So I'm not keen on adding them back without understanding the history.
> >
> > Eric:  Do we need these after all?
>=20
> For the main trunk no.  The .ctl_name field no longer exists.
>=20
> kernel/binary_sysctl.c is used to provide backwards compatibility with
> the old binary names.
>=20
> There might be a point for doing something in -stable or someone's
> enterprise kernel if some messed up set of backports were merged.
>=20
> Eric

Thanks for the quick response Eric!!

Qing: It looks like this is not an issue in mainline.
  If you want to get something fixed in SLES or RHEL, I suggest you log an
  issue in the relevant bugzillas (though I just checked SLES11-SP2, and
  it doesn't mention sysctl_check_dir at all).

NeilBrown

--Sig_/TCYezhBqY.Bs82vnX.u+sMj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2AD1Tnsnt1WYoG5AQIegw/+LbdG6n6ixk54T444J2myyv6Zf9v4Xkg5
+gsD9wy9wJHBXSkF+bHr1m1eyl1US4K7cO8eDFpo7ahN9G8cqlb/Am+LuOPcyiVt
RA1YhnPTzZFACFmg3ULmYnlQgfOA9uByCd1RsQh5hyKqLyHEVmlb/yGmcBSm8BDx
Qv08DZiqy/6Xff9EEyRU5uCXDIOhXs56LALnmQ7J5gW/ysrNtrAhlYpj1eZJl0Uc
C1ECzil3PLyIB9mWObi8bX5mkrZddotOVulo4yu88XwP4802FuEDBSaYGiDFj1Z1
9X4kH6+mui+SoTmTh0yROQ3uB+hFwDqYYxENxU/KiVjc3SrFz1hC+7wsnJp1JShQ
SIArBIKpEcYcGxSaAGHlHjzjI5wtUKG9Yz1GFlFYC8MeTgZPhbNhLTUg/laRhrPo
LKFlhR37ersKzJvae1UX7lsO09j3ngzJM69E1ICOF5K+RqTE9m4k9Zpg1Xf6sWx5
MAGQip1bjt1G/Pu/aJtBw8qRoaDoQ9brBoY6h7CHislns8Ao1/5VJxf2mQ9BIqbb
g5YVhYhC9YaazCFJneRB5jH8kK6sZvoHXETHmdAROP+NUF81v/HmRSckO2LvJaT4
iMOP1zlZ5pU7Kzd/ylQreHRmTYyALudT+ROh/wve537/PnKvnZehN0eHCTIKaaEn
nrFtldlEmcw=
=57R2
-----END PGP SIGNATURE-----

--Sig_/TCYezhBqY.Bs82vnX.u+sMj--
