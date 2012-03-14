Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030473Ab2CNCYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:24:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759917Ab2CNCY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:24:29 -0400
Date: Wed, 14 Mar 2012 13:24:22 +1100
From: NeilBrown <neilb@suse.de>
To: Shaohua Li <shli@fusionio.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
Message-ID: <20120314132422.3aeb6d49@notabene.brown>
In-Reply-To: <20120312030412.375458948@fusionio.com>
References: <20120312030412.375458948@fusionio.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tu/q2Z4LK.W.Sq1CIinhKF8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tu/q2Z4LK.W.Sq1CIinhKF8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Mar 2012 11:04:12 +0800 Shaohua Li <shli@fusionio.com> wrote:

> The patches add TRIM support for raid linear/0/1/10. I'll add TRIM suppor=
t for
> raid 4/5/6 later. The implementation is pretty straightforward and
> self-explained.
>=20
> Thanks,
> Shaohua

Thanks.
They look mostly OK.

In raid0.c, I think you'll need to change

		/* Sanity check -- queue functions should prevent this happening */
		if (bio->bi_vcnt !=3D 1 ||
		    bio->bi_idx !=3D 0)
			goto bad_map;

to also allow for 'bi_vcnt =3D=3D 0' like you did in bio_split.

Also I wonder about handling failure in RAID1.
I think the code will currently treat it like a write error, and
maybe record a bad block (then fail the device is writing the badblock
record fails). Is that what were want?

And of course resync/recovery will mess up the discarded sector information,
so this isn't a complete solution for RAID1.  But  it is a reasonable start.

Thanks,
NeilBrown

--Sig_/tu/q2Z4LK.W.Sq1CIinhKF8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2ABVjnsnt1WYoG5AQIoqg//YD2vcO/hSxuXV/iklDCPwJB9h5WsPPVH
ELBbD3OUP/zyXXHtekAfWHN1VTzOggTMWb+mMyPq/KQf/xyPBmOLMN89M6OuLlh4
DfLpGji0IuD7uKxVBTyjCCoj4N8AAbYS+1zy8C80xGn5abMc1JrXqKQARUMl4bhi
D+poaoav2K5DYuX9+7pbsSZ57mZYJb9T9pmSah+BRfzF8mVIiCs8C+1Y3GryqPgY
+TxXxn13A0RdazcjA1hergvBmAaGajPIq0RADEFqY6b4TU1iBu4g/NfFJY2V6iBM
ylL4FvAO2WBniqie4Zlp/0XmJNTzdnjQUoH/4h8HWl3NH9zD59C7jZrlvV8KYfT1
+EmjGczp4KETOZCab7W+u2mZhoFU0HudDA0FtxNoRnZydN/fpGRlE55YHNGf7iKy
705aVdB/3+/34zs0j6Pwu1Q8vkHGhOFyER/bBkkJvASEGWyaHRgYIY4DCxrM19X5
8bTGqlYotZgNx0Eqj1wd3cnjF8i6ePB2mCvlLEAiVjtlXxmizsflFZp5zHuSYLav
v2JLOKXOHclQJQtnoZDc0YXde4YzNZv3UPZX2BwAEB5sjMhmCHO+7or/0EBu6xxV
vcvJ7+X6Y0mRrg9IJvYFmYeahsTv6cogCKNBdRnFHlvqFLHjJFXEATU+uvT1DXqg
GSMgGhuEVu8=
=hZUN
-----END PGP SIGNATURE-----

--Sig_/tu/q2Z4LK.W.Sq1CIinhKF8--
