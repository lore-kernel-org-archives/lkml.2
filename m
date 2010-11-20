Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab0KTCQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 21:16:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40537 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756303Ab0KTCQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 21:16:21 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Ingo Molnar <mingo@elte.hu>, kexec@lists.infradead.org,
        Cliff Wickman <cpw@sgi.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <20101119214410.087440440@clark.site>
References: <20101119214410.087440440@clark.site>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xspl/jbONpB3o2YLR3IV"
Date: Sat, 20 Nov 2010 02:16:12 +0000
Message-ID: <1290219372.3818.113.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [08/45] mm, x86: Saving vmcore with non-lazy
 freeing of vmas
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xspl/jbONpB3o2YLR3IV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-19 at 13:42 -0800, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>=20
> From: Cliff Wickman <cpw@sgi.com>
>=20
> commit 3ee48b6af49cf534ca2f481ecc484b156a41451d upstream.
>=20
> During the reading of /proc/vmcore the kernel is doing
> ioremap()/iounmap() repeatedly. And the buildup of un-flushed
> vm_area_struct's is causing a great deal of overhead. (rb_next()
> is chewing up most of that time).
>=20
> This solution is to provide function set_iounmap_nonlazy(). It
> causes a subsequent call to iounmap() to immediately purge the
> vma area (with try_purge_vmap_area_lazy()).
>=20
> With this patch we have seen the time for writing a 250MB
> compressed dump drop from 71 seconds to 44 seconds.
[...]

Useful, but it doesn't seem to meet the criteria for stable updates.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-xspl/jbONpB3o2YLR3IV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATOcvX+e/yOyVhhEJAQLBBw//dsjK9xRK3e58u8WqfSuyof+7PsXrJ/93
peiH+cwN8TDjap8Sy6mL8NT6X93JIbpugcKmW5s7UxFcU8L2y3P3D7INPcQWtIJE
hiv9qPp8432ccQT4bhV2g2Uk6tQ2hyr59TZHh3gvoCRCnlD6Mr1x1ZyGNbxNGJtZ
5BhPLOrJ85ghp4ok8b9CAhdpEDvbIUM4rbIf8qCf7yM8rtn6+uhO0NxlbdmQ8dfT
kOte1EyUkL8/88FbVxSnbwSWTtDRdSR5XISh+MPUxZqRrjthuPvLtMVLUNnl8f3T
zY2yHC2vZ71cOoysv8bOBm9cmYewB5KN8nYh6xL6EDIR5Albb2Uek1YtPDOnZ6nD
iPzYxi1uOV96o09eztpkjXietRkyPzgkc+eAKA1OkxyX+87OWgWJA6lsq4dCR7TD
wUE06Hjr7/2dWlerK6ZuRbl2Zf54CteuVYO38Ro1VbmFa6PfMTIiGJciMln0Hw84
u/y6C3ImwaNdVO6s1e0PHLQknDg8CjMpQfPxD/N6apckFIfLijNR0MLwNnKF32ZB
QdUQizx6JLiSBYXgxYkjHyXeOMvhMA049BgAdPi0CSsz66uy3gBozBTLiVy7pAmZ
FSHhIqlN6CrGWj8kUggWjqSP+g+0SY9ua9QmFnzZ5UdK4R+i20MWJzNBtXwKJBe2
jqk10YKfsYg=
=72pV
-----END PGP SIGNATURE-----

--=-xspl/jbONpB3o2YLR3IV--
