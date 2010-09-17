Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab0IQE0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 00:26:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45194 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab0IQE0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 00:26:38 -0400
Date: Fri, 17 Sep 2010 14:26:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warnings in Linus' tree
Message-Id: <20100917142630.b968977c.sfr@canb.auug.org.au>
In-Reply-To: <1283148482.3707.167.camel@rui>
References: <20100817112439.18f9d958.sfr@canb.auug.org.au>
	<20100830114222.3a1f53e6.sfr@canb.auug.org.au>
	<1283148482.3707.167.camel@rui>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Sep_2010_14_26_30_+1000_CUYheE9.on.FSdhn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Sep_2010_14_26_30_+1000_CUYheE9.on.FSdhn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Mon, 30 Aug 2010 14:08:02 +0800 Zhang Rui <rui.zhang@intel.com> wrote:
>
> On Mon, 2010-08-30 at 09:42 +0800, Stephen Rothwell wrote:
> > Hi Len,
> >=20
> > On Tue, 17 Aug 2010 11:24:39 +1000 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
> > >
> > > Today's linux-next build (x86_64 allmodconfig) produced these warning=
s:
> > >=20
> > > drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_old=
_set_param' from incompatible pointer type
> > > include/linux/moduleparam.h:165: note: expected 'int (*)(const char *=
, struct kernel_param *)' but argument is of type 'int (*)(const char *, co=
nst struct kernel_param *)'

[several more elided]

> > > Introduced by commit 1c8fce27e275fd7c6b75bc6455745f02d3903ee6 ("ACPI:
> > > introduce drivers/acpi/sysfs.c") interacting with commit
> > > 9bbb9e5a33109b2832e2e63dcc7a132924ab374b ("param: use ops in struct
> > > kernel_param, rather than get and set fns directly").
> >=20
> > Can we have this fixed, please?
> patch attached. :)
>=20
> Use module_param_cb instead of the obsoleted module_param_call to fix a b=
uild warning.
>=20
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>

Now that this has been in linux-next since Sep 6, can you please send it
to Linus.  It removes quite a few warnings that were introduced during
this merge window - and I think we already have too many warnings.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Sep_2010_14_26_30_+1000_CUYheE9.on.FSdhn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMku32AAoJEDMEi1NhKgbstuAIAI4rOwa4Y4RIjf3FKcbxxM5Y
TwwToNW0lRjb8zaF9zq7wrbD0gDvNFkFV9r7SEf+pDLA4K52sVJPJ/ctxSoR88Oe
P43VuIsiyTucE1e/3tIYdgRzMwZbLi9EJ0I7M3ApROIsTsHehU+Q9d359eT4X1lS
w2YWwfrU5tOb0Kcon16ToOpMWh2mc2D/eosRJm7nBojOjnn8n55DOqeQfuQV2/lb
eXOaMBmPiCM7k/L9efImfm1018TZfG5Re6oDGMYvZX7KtkmQ1SJyTxjIiexBYxIv
ifevxBxYVtggbsS9j8jnrH3NP6z/RDEilu03OYbzdx0U1sOb1F0rO/BqRJAvJzA=
=HPrb
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Sep_2010_14_26_30_+1000_CUYheE9.on.FSdhn--
