Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab1AKXMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:12:36 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48562 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1AKXMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:12:32 -0500
Date: Wed, 12 Jan 2011 10:12:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <Narendra_K@Dell.com>
Cc: <jbarnes@virtuousgeek.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Jordan_Hargrave@Dell.com>,
        <Matt_Domsch@Dell.com>
Subject: Re: linux-next: build failure after merge of the pci tree
Message-Id: <20110112101225.e5a96937.sfr@canb.auug.org.au>
In-Reply-To: <20110111154214.GA16157@fedora14-r610.oslab.blr.amer.dell.com>
References: <20110110125411.2f45fd2f.sfr@canb.auug.org.au>
	<20110111154214.GA16157@fedora14-r610.oslab.blr.amer.dell.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Jan_2011_10_12_25_+1100_XV8d4+kX6.cgmS=y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Jan_2011_10_12_25_+1100_XV8d4+kX6.cgmS=y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Narendra,

On Tue, 11 Jan 2011 20:48:21 +0530 <Narendra_K@Dell.com> wrote:
>
> On Mon, Jan 10, 2011 at 07:24:11AM +0530, Stephen Rothwell wrote:
> >=20
> > After merging the pci tree, today's linux-next build (x86_64 allmodconf=
ig)
> > failed like this:
> >=20
> > drivers/built-in.o: In function `T.647':
> > pci-label.c:(.text+0x28514): undefined reference to `utf16s_to_utf8s'
> >=20
> > Caused by commit a6247cd4be20cb5439db5cb7b0b6cc67fdc8e2a2 ("PCI: export
> > ACPI _DSM provided firmware instance number and string to sysfs").
> >=20
> > I have used the pci tree from next-20110107 for today.
>=20
> I did a git pull of linux-next-20110110 (topmost commit is=20
> 4c897f27ad2668534f719202a3b88abe8ec31011) and applied the patch. With=20
> CONFIG_DMI and CONFIG_ACPI both set, I did not encounter this build failu=
re.=20
> The definition for `utf16s_to_utf8s' is available in 'include/linux/nls.h=
'=20
> which is included in 'drivers/pci/pci-label.c' and the build succeeded. S=
orry=20
> if I am missing something here.

I did an x86_64 allmodconfig build (see above) which has CONFIG_NLS=3Dm and
so utf16s_to_utf8s is not available to built in code ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__12_Jan_2011_10_12_25_+1100_XV8d4+kX6.cgmS=y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNLOPZAAoJEDMEi1NhKgbs+pMH/Rq8qrEuWh7bf5HyzIxc/75K
DMVHwiGOdQ1QYvFTqolaV4/uNwu/46me8aYEgFfCRINynZaTLbg/tYQDPgeh4kaH
D18zkyZQO2JqjDWM1XIOQ0fBNK9RxgHOQ0w2o85FDGUzuy4WoUzJHMlf+UBgGGwm
Ynf5DleqQfH5fULq6u89605DJiRYooudml9I7ZsSmIVCGnVxWxe/MOO/Vei5osvk
qZxXeTl11ISRM8xMzVRi+MXWNWytIJ2b8lxBdpMorAqNCvqFxkwYt7/PeLcXzvwO
sbNRCdlqwoSuw8p/kZ+yqiee/8rm2z9tPM8VWCp+CjY/bUBn5Y5JToxAKPQHYn8=
=mzDD
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Jan_2011_10_12_25_+1100_XV8d4+kX6.cgmS=y--
