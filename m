Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab1KKR7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:59:17 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:37862 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751092Ab1KKR7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:59:14 -0500
Date: Fri, 11 Nov 2011 09:59:30 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 00/16] PCI: Re-factor PCI's 'latency timer' setup
Message-ID: <20111111095930.22abd773@jbarnes-desktop>
In-Reply-To: <20111028214726.20088.30551.stgit@amt.stowe>
References: <20111028214726.20088.30551.stgit@amt.stowe>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jzaX_Ov.C2e6LC6GO32+y9r"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jzaX_Ov.C2e6LC6GO32+y9r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Oct 2011 15:47:26 -0600
Myron Stowe <myron.stowe@redhat.com> wrote:

> The 'latency timer' of PCI devices, both Type 0 and Type 1,
> is setup in architecture-specific code [see: pcibios_set_master()].
> There are two approaches being taken by all the architectures - check
> if the 'latency timer' is currently set between 16 and 255 and if not
> bring it within bounds, or, do nothing (and then there is the
> gratuitously different parisc implementation).
>=20
> There is nothing architecture-specific about PCI's 'latency timer' so
> this patch pulls the setup functionality up into the PCI core by
> creating a generic 'pcibios_set_master()' function using the '__weak'
> attribute which can be used by all architectures as a default which,
> if necessary, can then be over-ridden by architecture-specific code.

I have acks from Chris, Ralf, and Mike.  Any other arch maintainers
want to ack or nack this before it goes into my -next branch?

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/jzaX_Ov.C2e6LC6GO32+y9r
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOvWKCAAoJEIEoDkX4Qk9hz2YQALHY1AS+YiPeEERuESPfkbzY
MYkg8/d+NP0bMRfwNCJxlIgh5iUy9vlfjyJ4gQkhx9TwTeAbnQ/5SXjP7tXUXAss
ZFY3VaONy93vqgHWB5Jo9RChedSjM9bPF3n58CiVNN/hg4XAd1qXLG/QGauR+Opb
YDpNO3Adk4SrkmgXlJZTQnH8ZS07g2p4TW0JdNg5QeKk16avXpGzvUS30xR0oaDN
3LMFiTdDecU0RuouSpQ/7U/4q/+t2jIRk7OaahXLQhw3JyQB4GppI4cmrrt5Pk4R
fUsX0nuvO1l6KyKOV0O4VLd1INhRW+1kaRShqFrzefEGO/vla3BFM2NyZ1SjtuBQ
pCch97w9uM7h8cP8os82RzScp+GlSv+jvlN5OaCYLzr8S5xjfGWoKB5GWTHQHGr/
wPJ2vS5CG2jonjkxLCabpk0yPLrffmgnoJhDarzXLL1NSOCockuqyX9zIgHCbWFo
a3E75UZQA2XCzX+4XWPNGaV/KlhWSMUCjxS33NCWPR60EVT1wwpMptKlSlJtUkKO
0w9gMMZQ3cEJ4agTyFs/pYX9bTBHmCEUUZCCYcawpgjr4HKUMCL6QsVvEPsfCCbF
1ssuUHolRWiOefOcVCqZCzHUI+WGUeYY9rXG+LDGCV6bQUPHJF/kaozhnhVBuKEN
rA7aryoIdXG+HcE42X/S
=Mu6a
-----END PGP SIGNATURE-----

--Sig_/jzaX_Ov.C2e6LC6GO32+y9r--
