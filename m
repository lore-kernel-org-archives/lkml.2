Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab1KHXpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:45:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1KHXpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:45:15 -0500
Date: Tue, 8 Nov 2011 17:44:52 -0600
From: Clark Williams <williams@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>
Subject: Re: [ANNOUNCE] 3.0.8-rt22
Message-ID: <20111108174452.497da95f@redhat.com>
In-Reply-To: <alpine.LFD.2.02.1111082150490.2694@ionos>
References: <alpine.LFD.2.02.1111072225340.2694@ionos>
	<20111108105019.794045fa@redhat.com>
	<alpine.LFD.2.02.1111082150490.2694@ionos>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Jr+9lwRJKc5COU_yOeJpTU/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Jr+9lwRJKc5COU_yOeJpTU/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Nov 2011 22:02:32 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 8 Nov 2011, Clark Williams wrote:
> > Got the following splat on boot (f15 64-bit laptop, quad-core i7):
> >=20
> > [  146.609030]=20
> > [  146.609031] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [  146.609033] [ INFO: possible circular locking dependency detected ]
> > [  146.609035] 3.0.8-rt22+ #27
> > [  146.609036] -------------------------------------------------------
> > [  146.609038] dconf-service/9046 is trying to acquire lock:
> > [  146.609040]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81=
1adcc4>] ext4_evict_inode+0x44/0x26f
> > [  146.609047]=20
> > [  146.609048] but task is already holding lock:
> > [  146.609049]  (&mm->mmap_sem){++++++}, at: [<ffffffff81108ee6>] sys_m=
unmap+0x36/0x5b
> > [  146.609053]=20
>=20
> That's an upstream problem which got pulled into 3.0 stable via commit
> 2526f36894 (upstream 2581fdc810) but lacks the followup upstream fix
>  .  The latter unfortunately has no Cc: stable tag ....
>=20
> Ted?
>=20
> Thanks,
>=20
> 	tglx


Thanks Thomas. I cherry-picked 8c0bec2, rebuilt with the same config
and have booted the resulting kernel with no lockdep splats.

Clark

--Sig_/Jr+9lwRJKc5COU_yOeJpTU/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk65vvQACgkQHyuj/+TTEp2brwCg0tHi/k5Tb0aBtGOVud857iPV
PrQAn3ReXAaztY/7hQpJdy+qtZPx2zrv
=G+kg
-----END PGP SIGNATURE-----

--Sig_/Jr+9lwRJKc5COU_yOeJpTU/--
