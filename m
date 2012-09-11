Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab2IKFXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 01:23:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab2IKFXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 01:23:06 -0400
Date: Tue, 11 Sep 2012 15:22:56 +1000
From: NeilBrown <neilb@suse.de>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, tj@kernel.org
Subject: Re: [PATCH v2 00/26] Prep work for immutable bio vecs
Message-ID: <20120911152256.74cb184f@notabene.brown>
In-Reply-To: <1347322957-25260-1-git-send-email-koverstreet@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6vrj0jrTvFhDGbTB1jVmyqi"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6vrj0jrTvFhDGbTB1jVmyqi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Sep 2012 17:22:11 -0700 Kent Overstreet <koverstreet@google.com>
wrote:

> Random assortment of refactoring and trivial cleanups;
>=20
> Immutable bio vecs and efficient bio splitting require auditing and
> removing pretty much all bi_idx uses, among other things.
>=20
> The reason is that with immutable bio vecs we can't use the bvec array
> directly; if we have a partially completed bvec, that'll be indicated
> with a field in struct bvec_iter (which gets embedded in struct bio) -
> bi_bvec_done.
>=20
> bio_for_each_segments() will handle this transparently, so code needs to
> be converted to use it or some other generic accessor.
>=20
> Also, bio splitting means that when a driver gets a bio, bi_idx and
> bi_bvec_done may both be nonzero. Again, just need to use generic
> accessors.
>=20
> v2: Patch series now has all the prep work to be done before abstracting
> out the bio iterator, I think.

Hi Kent,
 this looks pretty good to me.  I've only really looked closely at the md
 bits, but they all seem to make sense (with the minor issues that I report=
ed
 separately).

 If/when there is another posting I'll try to allocate some time to testing
 them and looking more closely.

thanks!

NeilBrown


--Sig_/6vrj0jrTvFhDGbTB1jVmyqi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE7KsDnsnt1WYoG5AQLWtw//Z7btOAU20pywaejQ5GY7uxagQKVyIXYd
3fnU399mkuAtqTcUyKkh6sZVyAoactue/9YtDLTSeNm+oJMLDpltH8+yaoT9cCsi
TkGs72jtlJZs8Doh2Yl0esRWPEan6fb3VqPJAcwLUI0QU0PAive4sxneNiB5h5hp
L9fbJvzyvV71AaasKT1f4S5MSXkBv8XNcEjrmYF9sx98UmOeCYo/PTfxNiR1y5YV
6+zxEA8sMpLmgdr8uezV1OWn54/+5cW4qrsQVr5J00fDrhb3L/A98nYAhEfcWv63
ayXnsv+InMliQkG6LQMOIiKVVNk6hdFnYzeYKQpdCRKvcJihIWIp81gT9ETdqbDS
6aEZptdQ3naYeMUlEMQquEo3HekD/bO43MNRrMDyntn22kahzHwJDqgp0d1eFhSk
fRcRUK/JD1+QZMP6ZlOoDY8gsGm6GmIAOc4/DdrxmPXI4I408p0whqPfPq2KcN/U
QYMxRQMCrwGFrwetPVr6SLDzafYbtx/5owWnM3c+teuLgi/hhbF1goNYPVPD1ZQN
gUjSGgpPJJwDT99jQxOFKa7u3rLq0NnzONYxOi2OH/h3AP2pBXnIN0vMjpPsLOyU
kQ7MELW13JZcs1dEdPzFtatmPebJ674q+RtbXwUQYgcNhjURMxqvpt7K9AIZkgft
npQP1Eh2T24=
=TsPP
-----END PGP SIGNATURE-----

--Sig_/6vrj0jrTvFhDGbTB1jVmyqi--
