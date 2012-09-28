Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab2I1KcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 06:32:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59902 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab2I1KcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 06:32:14 -0400
Date: Fri, 28 Sep 2012 12:32:07 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: CMA broken in next-20120926
Message-ID: <20120928103207.GA22811@avionic-0098.mockup.avionic-design.de>
References: <20120927112911.GA25959@avionic-0098.mockup.avionic-design.de>
 <20120927151159.4427fc8f.akpm@linux-foundation.org>
 <20120928054330.GA27594@bbox>
 <20120928083722.GM3429@suse.de>
 <50656459.70309@ti.com>
 <20120928102728.GN3429@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <20120928102728.GN3429@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:xarvXUeAUvZbpokBPj1O7m9DI7oXCo1pL5zydeXFgUh
 27cvnihQCFdcEPW6d3lmKeUAImpV10zenjZEHKuMH9os7c0Rp+
 HpwOWxIDtqWW0mFRKFy6kzBrycT+FRzJOamEWSq1mdEnGnYIQT
 MsSWw6S28lXAa6/gZADGJnYzQ8/S/hl54nclbzflFvwqa5eYWd
 x0oGYWOA7v77XtC9NS4Uto+Uol0wwozmxYq4W5XTjdLpWRHl2r
 OYtthYRgpoYhYN+cUuXPDPl1ZQ6lsR7cshqYmvgnkFfLHe0Jd+
 HTAjVwh/b2Wdk/sFVHKLwz/9TO5JZDLnouetulyJ6SiKQujWRy
 lZYFfnXojmQUgkuY1hLw6gyhaKIHHyjHUCOd5EAEq+vJ6wb7gO
 qheLIlisGyQ2+NjutV51eDiEzjqlJ7SvZhObNX9228jwG94J0U
 FheKi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 28, 2012 at 11:27:28AM +0100, Mel Gorman wrote:
> On Fri, Sep 28, 2012 at 11:48:25AM +0300, Peter Ujfalusi wrote:
> > Hi,
> >=20
> > On 09/28/2012 11:37 AM, Mel Gorman wrote:
> > >> I hope this patch fixes the bug. If this patch fixes the problem
> > >> but has some problem about description or someone has better idea,
> > >> feel free to modify and resend to akpm, Please.
> > >>
> > >=20
> > > A full revert is overkill. Can the following patch be tested as a
> > > potential replacement please?
> > >=20
> > > ---8<---
> > > mm: compaction: Iron out isolate_freepages_block() and isolate_freepa=
ges_range() -fix1
> > >=20
> > > CMA is reported to be broken in next-20120926. Minchan Kim pointed out
> > > that this was due to nr_scanned !=3D total_isolated in the case of CMA
> > > because PageBuddy pages are one scan but many isolations in CMA. This
> > > patch should address the problem.
> > >=20
> > > This patch is a fix for
> > > mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2.patch
> > >=20
> > > Signed-off-by: Mel Gorman <mgorman@suse.de>
> >=20
> > linux-next + this patch alone also works for me.
> >=20
> > Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>=20
> Thanks Peter. I expect it also works for Thierry as I expect you were
> suffering the same problem but obviously confirmation of that would be ni=
ce.

I've been running a few tests and indeed this solves the obvious problem
that the coherent pool cannot be created at boot (which in turn caused
the ethernet adapter to fail on Tegra).

However I've been working on the Tegra DRM driver, which uses CMA to
allocate large chunks of framebuffer memory and these are now failing.
I'll need to check if Minchan's patch solves that problem as well.

Thierry

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQZXynAAoJEN0jrNd/PrOh8pwP/1hNys2zUbTUAMg0bltfzAZy
OIHQ5Z6dFXc0V3ZgEO6DfpDmgBBDYEXvhRm2fjq1kQrX52WPce8+BeSTwVQPeoiU
dUYT6h1c7t1BCzievrlC+pZJfcSK3oKWLQCMRpVhvf20NAqQWKmoVNYAQ7eqmjaK
rTF7Y/ZR1tEp8exVmlcJ1Y+7lTMpU7hAHy+Jtlal/1IbUo2X5GAxiW0yx6gW1CNs
Zgamep0+WpX1I5gqRekN3HLldZcEcnFzpax4rKuQjTSgTfYindq9pqUKQZ0S/tLc
ZjqyjoGqIxDiJ5FK1uLt5SMqNh1C4hUQLzXFDMgx/lxBJTDPbeABBpTkRvnn4InS
nC//fK6+QJKAlIx6RatGJ3F/WT2hNOLDhNN5CM4Jo/PQol2TeCFHwy/KFTRwsu7G
O8xva7/hA1WKCjUU9yaaiflIe/YjbnF+fW/96N38l88xqoq9pCu8uKYIbGeRNs5h
5RR2EvZuXGzgM13uZMb+sFQNObSokUU/Z4CmM+kUMTC3xxXRGTDOb4TnQVvmH8VE
GhRb6tP7dnVLhOh6F+zMCqTmT4bWB1kFlMEPMhNXc5fqhZFTx+qW2g/oxt5P9Zap
BWQAhWabfqMZYq7Dur8oFdislb0Vk6v2AYj+PVb4/hdJKYXeI3tEWXa0nlOXahBw
1VUSjPJuORfP0/4jK7E5
=9sTR
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
