Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2BQDmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:42:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55783 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2BQDmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:42:19 -0500
Date: Thu, 16 Feb 2012 21:42:12 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Josh Boyer <jwboyer@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: hugetlbfs lockdep spew revisited.
Message-ID: <20120217034211.GA24135@boyd>
References: <20120217000856.GA13112@redhat.com>
 <20120217001634.GH23550@zod.bos.redhat.com>
 <20120217003848.GB20071@boyd>
 <20120217004922.GN23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <20120217004922.GN23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-02-17 00:49:22, Al Viro wrote:
> On Thu, Feb 16, 2012 at 06:38:49PM -0600, Tyler Hicks wrote:
> > On 2012-02-16 19:16:34, Josh Boyer wrote:
> > > On Thu, Feb 16, 2012 at 07:08:57PM -0500, Dave Jones wrote:
> > > > Remember this ? https://lkml.org/lkml/2011/4/15/272
> > > > Josh took a stab at fixing it in e096d0c7e2e4e5893792db865dd065ac73=
cf1f00,
> > > > but it seems to still be there.
> > >=20
> > > I think Tyler Hicks actually noticed this a while ago, but his patch =
has
> > > been waiting on comment from Al and Christoph:
> > >=20
> > > http://thread.gmane.org/gmane.linux.file-systems/58795/focus=3D59565
> > >=20
> > > I've been hesitant to comment because I obviously screwed up once
> > > already.  We could try this patch in Fedora for a while if Al and
> > > company don't speak up soon.
> >=20
> > I'm pretty confident that my patch that Josh linked to would "fix" the
> > lockdep warning below. According to the backtrace, it is barking about a
> > directory inode and a regular inode having a circular locking
> > dependency, so deadlock is not possible in this case.
>=20
> Sigh...  That patch is correct, but it has nothing to do with the locking
> order violation that really *is* there.  The only benefit would be to
> get rid of the "deadlock is not possible" nonsense, since you would see
> read/write vs. mmap instead of readdir vs. mmap in the traces.  Locking
> order is the *same* for directories and nondirectories; both can have
> pagefaults under ->i_mutex on their respective inodes.  And while mmap
> cannot happen for directories, it certainly can happen for regular files,
> so taking ->i_mutex in ->mmap() is a plain and simple bug.  Should never
> be done; in particular, hugetlbfs has ->i_mutex held in read() around
> pagefaults, which gives you an obvious deadlock with its ->mmap().
>=20
> Folks, this is not a false positive and it has nothing to do with misanno=
tation
> for directories.  Deadlock is real; I have no idea WTF do we what ->i_mut=
ex
> held over that area in hugetlbfs ->mmap(), but doing that is really, real=
ly
> wrong, whatever the reason.

Thanks for clearing that up, Al. I only knew that the inodes were being
incorrectly annotated, but I wasn't sure about the correct locking order.

Tyler


--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPPcyTAAoJENaSAD2qAscKTBMQAKnJc6fIs3eU5a3MHH9eqHXL
PVUXWNWxyuulBquLj7vyIKNwacghrqidW9s/hoIHRbkgZI3ukt+izhuCANGvH6NB
v8iGg086dqtDvCDDrHvzVoOUNeepp/npjSbHCjmHfIdSrBq9A/owGsrDhchA3nIH
38fP3MS3EgmnB1lCtDswXfW5NowLINp9479YB/vDslmVey5e6tIf64/nvYGrUXzP
laRqD4jCQ35H7BOVKJvU7gDePNzeyp+UcdwT9ktT3CxxRnEIwqlaGXt2gTmxFaoW
cCq172SVfWxMzuGYB0UyKbvtrGLcBWRH3NNk0zTJGu5jjLnq9bY36OkNvvzdS2iM
W2amrttMmzQSa+xgwg9e504WVGRSOzFwAeIWBtiWf7DbDS0cD03hcWq7xND8Sme2
6AO7jTEV/iVfWBpjCnLllRjv2qk0rhtMd9BUA+dKGcuEEMKB/rRP5iaZ2ojrwrAm
p0MmQxj9/KjZ4ljIC8bMzYwKx8jV5rE2+m3sqFelh6Qk6Z+TfyRd9F4V+V2ygJu9
CCeZ+hDi/vGm2VrTAgiGvEo2sNjt+n9EjnbP+ggDx5QaGRDhFncNtTd719hktN23
Yho7f6alRNCnW6AGQ9lSTXk7FO3kXxRZMufNKU43Gs5RIWLLuMBYu5UBHe04cgE7
2QuM7CAgPSccA8U6Lhnl
=3CMt
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
