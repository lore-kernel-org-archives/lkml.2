Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1KAN70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:59:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:63344 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab1KAN7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:59:22 -0400
Date: Tue, 1 Nov 2011 16:59:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: wharms@bfs.de, "Mark A. Grondona" <mgrondona@llnl.gov>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] edac: sb_edac: add sanity check to silence static checker
Message-ID: <20111101135945.GA4682@mwanda>
References: <20111101062852.GA19020@elgon.mountain>
 <4EAFE6DF.8030403@bfs.de>
 <4EAFEBBE.3070604@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <4EAFEBBE.3070604@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4EAFFB34.0051,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 01, 2011 at 10:53:18AM -0200, Mauro Carvalho Chehab wrote:
> >> --- a/drivers/edac/sb_edac.c
> >> +++ b/drivers/edac/sb_edac.c
> >> @@ -970,6 +970,12 @@ static int get_memory_error_data(struct mem_ctl_i=
nfo *mci,
> >>  			break;
> >>  		prv =3D limit;
> >>  	}
> >> +	if (n_tads =3D=3D MAX_TAD) {
> >> +		sprintf(msg, "Could not discover the memory channel");
> >=20
> > why the sprintf() ? can you not simply:
> > 	edac_mc_handle_ce_no_info(mci,"Could not discover the memory channel");
>=20
> Yes, please us the edac-specific call. I'm working on some patches that w=
ill
> provide an additional functionality to those edac report calls. So, using
> sprintf() won't do the right thing after applying those patches (likely f=
or
> Kernel v3.3).
>=20

I did use the edac-specific call.  Walter is saying that the
sprintf() is not needed because I could just pass the string
directly.  That's true enough, but I'd prefer to leave it how I wrote
it so it matches everything else in this file.  Also passing it
directly as edac_mc_handle_ce_no_info(mci,"Could not discover the memory ch=
annel");
makes the line too long for the 80 character limit so someone will
complain if I do that.  This isn't a fast path so the sprintf()
doesn't hurt anything.

Also looking at it now, I suspect this patch might be a bug fix
instead of just to silence the warning.  We have a similar check for
the MAX_SAD loop earlier to the check that I added here for MAX_TAD.

regards,
dan carpenter


--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOr/tQAAoJEOnZkXI/YHqR8y8P/0wFwk8/j1xDxtb47yNsBVGB
6DUIA8DebxrcMi59jJIQG30a9IDu4rirGs61xuR9GHcJyp//7MaB/JwvF9GA9p3X
Bd+RdHLvGHaqzbnKaQ18Mz+pGMb4jy3CqhNXCa7C2WIZnSwoUcseDo3O3eDQ63XG
LEDmVS8JZGIMFSHAehneG6MS54kR49yMGUmOAVGYaAxq5wIYjpMNGcYuueovJ+7D
ppzaIDOYSaPiDJIa4dX1fPLVmumqk/xqMhx9O8UY9dBRX8DM8TbH1aERr6XdEbCQ
5rKyfHCOMGRKtX+2JDK1ZcnAaCdPgFGaCcu//ArrFUdEqPU2mXTFqyW0BHJopl82
phZ3XPiSCvQnXWMtAOrn5ddqSG6BZwXwzw0OX2Oj+ZisCYK8lOHsLjiASNU4P1cV
5d6qPj2Xaf1uNyf4ciF41GMdOjshGf2v45zmYedp+unphIY9nWqAPm1XRu5xW99Q
1ECfUhLAhd4tsG4cWo8hM2WOqNPDCmZgeGnfNKZ3kZ78lrlWZNzIrgldZanh4mXX
K5HT9vCsDlQbdUBHmBfRuIofFX7Rz+LyPP4slIh0G/o5PYBX1uNlzndi5y5Rp32J
9GfFFfFUmkdI3VQccfeB32nHbNI/h9E893Ubw9X4XjgeCNNPpvumdQVxlboSM/2w
TOYRim0Im5bhS6Vfok8k
=oZ86
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
