Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1BUC1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 21:27:22 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54606 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab1BUC1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 21:27:16 -0500
Date: Mon, 21 Feb 2011 13:27:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the workqueues tree
Message-Id: <20110221132708.e9ed5f8f.sfr@canb.auug.org.au>
In-Reply-To: <20110218145747.f4b26b91.sfr@canb.auug.org.au>
References: <20110218145747.f4b26b91.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__21_Feb_2011_13_27_08_+1100_=qC9pLU/gywR+E.o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Feb_2011_13_27_08_+1100_=qC9pLU/gywR+E.o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

On Fri, 18 Feb 2011 14:57:47 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the workqueues tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/input/input-polldev.c: In function 'input_polldev_init':
> drivers/input/input-polldev.c:259: error: 'WQ_FREEZEABLE' undeclared (fir=
st use in this function)
>=20
> Caused by commit 58a69cb47ec6991bf006a3e5d202e8571b0327a4 ("workqueue,
> freezer: unify spelling of 'freeze' + 'able' to 'freezable'") interacting
> with commit 8fb3f6f6bf6e17e97712d216f230ba05f2e88ed8 ("Input:
> input-polldev - create workqueue upfront") from the input tree.
>=20
> I applied the following fix up patch (and can carry it as necessary):

This patch is now applicable after the input tree merge as the workqueues
patch has been merged into Linus' tree.  So, Dmitry, if you merge Linus'
tree sometime, you should apply this merge fixup.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 18 Feb 2011 14:50:46 +1100
> Subject: [PATCH] input: update for FREEZEABLE -> FREEZABLE change
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/input/input-polldev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/input/input-polldev.c b/drivers/input/input-polldev.c
> index 0a5304c..d89e9a9 100644
> --- a/drivers/input/input-polldev.c
> +++ b/drivers/input/input-polldev.c
> @@ -257,7 +257,7 @@ static int __init input_polldev_init(void)
>  	 * system goes into sleep mode.
>  	 */
>  	polldev_wq =3D alloc_workqueue("ipolldev_wq",
> -				     WQ_FREEZEABLE | WQ_UNBOUND, 0);
> +				     WQ_FREEZABLE | WQ_UNBOUND, 0);
>  	if (!polldev_wq) {
>  		pr_err("failed to create ipolldev_wq workqueue\n");
>  		return -ENOMEM;
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Feb_2011_13_27_08_+1100_=qC9pLU/gywR+E.o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNYc18AAoJEDMEi1NhKgbsjMsIAKCXPBF0suEAMaYbYFqLOjT6
cUHe1VqT11abprZvdXDvKwqBYa7CV8GMvgUlCj8kKRPB8szFX93UxgbmJU3UdifB
NFs71MI5W1fdA/ushJMBZ2lFOfNW8tvu6Wggfkaf2Jif5lzkT19XVfaq7Vrr+1lv
SYV7G1+gdeZQhbDU4zoNvpVU+gUe8BG5y6pMr/hy4lVBbtBt0hnfF0yLm5MUqWVv
4oAfUAn7e1D0orIq06GTDHq51+CoL9Qfb1YRbflDa3p4AqL85G/Iv3JmlWlSBYO0
tly8gIzAM17zXTx6SEFLTtLzD0UC4zWHFs9PpXaQIFCaDnEoO4dq2bLF1U3svmM=
=HD5a
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Feb_2011_13_27_08_+1100_=qC9pLU/gywR+E.o--
