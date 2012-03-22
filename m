Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2CVFyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 01:54:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53830 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab2CVFyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 01:54:04 -0400
Date: Thu, 22 Mar 2012 06:53:54 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Ted Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Message-ID: <20120322055354.GA3942@avionic-0098.mockup.avionic-design.de>
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
 <20120321222357.GB24330@quack.suse.cz>
 <20120321231651.GC32041@thunk.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20120321231651.GC32041@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Nr/6ed25X3EmZCLh5MQRmeWPiy2/EhyFpTX1WrlgTIs
 XoV5/VzCaXw3a4lhY/1g66/tvuLXw0nUmvWjwxiXj7lq+HTSSt
 oLbcjGXp2DhHBqSIT/1GdCqDNgasmGJ8psfwTvpbWzpGr87lRt
 BjminON9FP2LeLrdlySfL3zu0FHvf/Tq4mj3ET3BXy7huR7bpt
 U3m3mkx6DmOvhh7dvygLERgNnuBpgUF5bVFxJxLv0frAZKh3Oq
 6ZXNIYl8bn8uLVy0PQewSewM4VE8alKs2q9xhn/grFR3Lf31Do
 aNoP0UApPhyKCQUOP9G09HGXL7WIF9NkI7PQ9sGgRXFeamnULD
 6MZhAKtLa2F/U84J8nHvzc1kUOPht4mNg7N8BJT0/eUrOx8/3Y
 cMQm2Zmb6sM/dgjitOKB4/+jTpbpvyzqwRPliMTZ+ibQ9KwO8/
 6aQgd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Ted Ts'o wrote:
> On Wed, Mar 21, 2012 at 11:23:57PM +0100, Jan Kara wrote:
> >   Frankly, anybody seriously wanting to do anything with ext[2-4]
> > filesystems should use header files as provided by libext2fs. So I wond=
er
> > if just unexporting the whole file wouldn't be the best solution going
> > forward. Ted, do you have opinion?
>=20
> Agreed, it's been almost 8 years since e2fsprogs used the
> include/linux/ext2_fs.h (the last version that needed it was e2fsprogs
> 1.35, released February 28, 2004).
>=20
> There shouldn't be *anyone* using any of the ext2/3/4 kernel header
> files.  The only program that might be cheating and using kernel
> header files is ext3grep, as the author wasn't willing to fix his
> applications to use libext2fs.  (As a result, it doesn't work on ext4
> file systems, where as properly coded programs that do use libext2fs
> often work just fine on ext4, such as e2tools, which hasn't been
> modified for something like eight years but which works on ext4 just
> fine.)
>=20
> So yeah, I'd just unexport ext2_fs.h, and probably ext3_fs.h as well.

Alright. Do you want me to send a patch to do so?

What's the recommended fix for packages that cannot or will not use
libext2fs, like busybox? Copy the required parts into a private header
and use that instead?

Thierry

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9qvnIACgkQZ+BJyKLjJp+T+wCgjJ+OACZfkbfEvTtshS8OtG2R
poYAoIPdeP6RNGAfU2snxfLTP/sEc75t
=5ML4
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
