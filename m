Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081Ab1LMFDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 00:03:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56059 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786Ab1LMFDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 00:03:02 -0500
Message-ID: <1323752547.2825.101.camel@deadeye>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
From: Ben Hutchings <ben@decadent.org.uk>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 13 Dec 2011 05:02:27 +0000
In-Reply-To: <CAB=NE6Wb9ySk6a1gB-edyF_uRe=-ESehUNbUa+n0g2WYGJXnqw@mail.gmail.com>
References: <1319461948.31243.31.camel@deadeye>
	 <CAB=NE6Vt91tHCBj7sJHjUCaDZZPqox+omcQjsEj54vQAtbY2bw@mail.gmail.com>
	 <20111212215818.GP3366@decadent.org.uk>
	 <CAB=NE6Wb9ySk6a1gB-edyF_uRe=-ESehUNbUa+n0g2WYGJXnqw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-hDNEdfFtxw2LrtxwlOP7"
X-Mailer: Evolution 3.2.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hDNEdfFtxw2LrtxwlOP7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-12-12 at 14:47 -0800, Luis R. Rodriguez wrote:
> On Mon, Dec 12, 2011 at 1:58 PM, Ben Hutchings <ben@decadent.org.uk> wrot=
e:
> > On Mon, Dec 12, 2011 at 01:40:44PM -0800, Luis R. Rodriguez wrote:
[...]
> >> It seems this taint flag will be used for driers backported through
> >> compat-wireless, the compat kernel module or any other backported
> >> driver, even if it is indeed upstream and whereby kernel developer
> >> *do* commit to actually fixing issues. In our experience
> >> compat-wireless bugs *are real bugs*, not backport bugs so we do look
> >> into them. In our latest linux-next.git based release for example
> >> backport code consists only of 1.3804% of the code.
> >
> > Now you can look for (O) after the module name in a BUG/Oops message
> > and you can tell whether the user really had the original or
> > compat-wireless version of the driver.
> >
> > It is really up to each distributor or developer how they treat
> > bug reports with the O taint.  When handling Debian bug reports I
> > won't automatically reject such a tainted kernel but I will look
> > carefully at the module list.
>=20
> I'm working on getting my companies to abandon 802.11 proprietary
> drivers for good. For Station mode of operation this is pretty much
> mission complete. For AP products.. this is work in progress. The out
> of tree flag is a good utility one can use to help justify working
> upstream but if we treat any future-kernel-backported-driver equally
> to any out of tree crap piece of shit driver, it seems to do unjustice
> to the value of a properly upstream backported driver.

Well, it's a warning that not all the kernel code comes from the
original source tree that the version string identifies.  It's not a
value judgement (unlike TAINT_CRAP).

> I will note
> that I put a lot of effort to ensure that the backport effort is
> upstream-centric in an *extremely* upstream-biased way, see how I
> label extra patches for tarballs [1]. If your patches are not upstream
> the only way you get into these tarballs are by providing patches into
> these directories:
>=20
>   * pending-stable/ stable fixes from linux-next.git not yet on a stable =
release
>   * linux-next-cherry-picks/ patches upstream but that won't go to the
> stable release that we want to cherry pick
>   * linux-next-pending/ patches posted on the public development
> mailing list, patch not yet merged due to the maintainer being away on
> vacation or whatever
>   * crap/ patches not even posted publicly yet
>=20
> Each tarball used also gets pegged with a letter if *any* patch from
> any of these directories gets applied. The compat module, upon being
> loaded, will also print the kernel ring buffer the exact release,
> whether extra patches were provided, the upstream git tree used as
> base and so on.

Thanks, I appreciate that.

> So -- although from a technical perspective this may mean Debian /
> other kernel developers may ignore the taint flag for compat-wireless
> it'd sure be nice to avoid it for them all together. Just can't think
> of a way to do it yet... If you agree should we continue to think of a
> way if its possible?

Maybe we should be talking about updating the distribution packages
instead.  For the Debian kernel packages, we backport various drivers to
the stable distribution to add support for new hardware.  Please mail
debian-kernel@lists.debian.org if you would like to work with us on
that.

Ben.

> [1] http://wireless.kernel.org/en/users/Download/stable#Legend
>=20
>   Luis

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-hDNEdfFtxw2LrtxwlOP7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATubcY+e/yOyVhhEJAQqEzBAA1c/LRQgKU9F27UwMIaGRN71K3grh0e+A
S2kjKM6YnahVjaoJYPSI523eNwW6gH7QifFsaxwfCY5oJ4r/UjReSP8W0Vo1kJb3
DmZH81UchfSxXzd1uGxWFyTzg4KHdUfcEAdAc+FbhN2kQHcTHLzQiryQLTmTnNGJ
aSpK8FW10lR5SrgLFOVuvtFSQ6WBb5+Jr2YW2FBAVfleZPC4n/g6hmVQ+u697lnT
5T1TwLWUF0YumW+B1E8cSBbHskLzdawCrxDSq6tcspMoXA3ukXMac5HyNDyhawzJ
sQ4G/xIuTLCcBXGVTdhOxbXOKxocg2Xpz2etdJmt/qNzqnHoY33oCzoI90gXDGqa
/Pg4mDglzBdGjq/3b+ARWAOgIJrpCRkz/jEju16HfZvLLcCYB8mTd845XLQEV8e3
2YciK5k9xhip2P+IXlrSpUO6pb2E/92OAxjQkCvSOfNuMQp79aWc+riZv7uUJDR3
EfKlRCHv2i2pA4EyRIA+JUKsIcqpsfmGw6dPWXnMSvV+HBqtNwaH6a/YJpDzKQ2E
I7jknTWx+svFEyOIwD+w9lskea5ikmYAcSiZpUETct/ZpPnUXnfingqqIsLocUL6
fcR63fbROHe68fGctWEGo3kb/twgHH7BMCxm62rkhDB6H3GROmoWLb8YAssLgjwK
TkMie8h2EfY=
=xGQo
-----END PGP SIGNATURE-----

--=-hDNEdfFtxw2LrtxwlOP7--
