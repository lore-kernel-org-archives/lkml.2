Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab2H3FzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 01:55:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33563 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187Ab2H3FzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 01:55:14 -0400
Message-ID: <1346306092.17040.3.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 05/13] overlayfs: add statfs support
From: Ben Hutchings <ben@decadent.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, goran.cetusic@gmail.com, romain@orebokech.com
Date: Wed, 29 Aug 2012 22:54:52 -0700
In-Reply-To: <87d32971s3.fsf@tucsk.pomaz.szeredi.hu>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
	 <1345045700-9062-6-git-send-email-miklos@szeredi.hu>
	 <20120817182051.GC29217@decadent.org.uk>
	 <87d32971s3.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-AgvoFoIwubN+Yx+faXMV"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 12.105.246.2
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AgvoFoIwubN+Yx+faXMV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-30 at 00:48 +0200, Miklos Szeredi wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
>=20
> > On Wed, Aug 15, 2012 at 05:48:12PM +0200, Miklos Szeredi wrote:
> >> From: Andy Whitcroft <apw@canonical.com>
> >>=20
> >> Add support for statfs to the overlayfs filesystem.  As the upper laye=
r
> >> is the target of all write operations assume that the space in that
> >> filesystem is the space in the overlayfs.  There will be some inaccura=
cy as
> >> overwriting a file will copy it up and consume space we were not expec=
ting,
> >> but it is better than nothing.
> >>=20
> >> Use the upper layer dentry and mount from the overlayfs root inode,
> >> passing the statfs call to that filesystem.
> > [...]=20
> >> +/**
> >> + * ovl_statfs
> >> + * @sb: The overlayfs super block
> >> + * @buf: The struct kstatfs to fill in with stats
> >> + *
> >> + * Get the filesystem statistics.  As writes always target the upper =
layer
> >> + * filesystem pass the statfs to the same filesystem.
> >> + */
> >> +static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
> >> +{
> >> +	struct dentry *root_dentry =3D dentry->d_sb->s_root;
> >> +	struct path path;
> >> +	ovl_path_upper(root_dentry, &path);
> >> +
> >> +	if (!path.dentry->d_sb->s_op->statfs)
> >> +		return -ENOSYS;
> >> +	return path.dentry->d_sb->s_op->statfs(path.dentry, buf);
> >> +}
> > [...]
> >
> > In case f_namelen differs between the upper and lower filesystems, you
> > need to return the greater of the two.
>=20
> Maybe.  I've never seen any app use f_namelen for anything useful.
[...]

If I'm not mistaken, glibc uses it to implement pathconf(_PC_NAME_MAX),
which may be used by applications in conjunction with readdir_r().

Ben.

--=20
Ben Hutchings
Quantity is no substitute for quality, but it's the only one we've got.

--=-AgvoFoIwubN+Yx+faXMV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUD8ALOe/yOyVhhEJAQrZdBAAzDzHq5d0/S4glu2sUbcaZcu9f62QiNkO
dm8HJK9g04a20K8wCI3OPrqZDT655RXZcfTRbLMPaC1Cj/5ZNLGKxU1Pr4QayrwI
QbWxmJ2k8FU5u4o+BH+4PHD7ZZZNyoqHfw9uQsQjntSBaDaZx038SqP/euxqcLo5
0Ap55/HsCKDtjcxI6DqEHKhSIGFYIRfuyhgOLso0wh+TH4fqMqWqlS8UXYmr1MBr
AMqjJoiiboDZw01lFtqJ+Nb7Ljr/1ZKxzvl223dNek0kDkQ7AtdBgiZDwOWeolRZ
XCflj1InNF9jvko3W3OUGD7unyS+wREmJHvltshrd+tFN5GVtIz6/Be926XbjZXV
cdjehGQ7LrXllfL+Q539BGYeu3qrcxONzGiYo+MyO8/P+K/rznHAi7/SSwyG3DrR
+qU+BHEzxy6k94g7nkk9e3cAzphlAUWCZ7kscLo29pTYfn/gs9wXshN3GGdT8xSl
Bwgq+UvCXelDoHs/cUhFR2UTkUmIxLWBV23J53qShjfZGeE+T5SpsKVIn36IAwvz
EAvOGV4zD1cinVxzNriAqveDUSEbjiwRo7YZ60aeYRc5RB1pzfHvNlJe7KUQy0Mt
2JHSOc3cIta+e6i75mytiCuReKREbr9CInmdMxaEICa6YDwFUZ8gmfDFbMfr5pGu
ViqlpEIHUb4=
=FCko
-----END PGP SIGNATURE-----

--=-AgvoFoIwubN+Yx+faXMV--
