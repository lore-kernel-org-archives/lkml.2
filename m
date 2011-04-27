Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab1D0Byc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 21:54:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53144 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab1D0Bya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 21:54:30 -0400
Date: Wed, 27 Apr 2011 11:54:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the cpufreq tree
Message-Id: <20110427115427.f5a4fac7.sfr@canb.auug.org.au>
In-Reply-To: <20110427013217.GA30804@redhat.com>
References: <20110427111024.eb26b6f5.sfr@canb.auug.org.au>
	<20110427013217.GA30804@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Apr_2011_11_54_27_+1000_Seg0fGATmifh/1xR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Apr_2011_11_54_27_+1000_Seg0fGATmifh/1xR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 26 Apr 2011 21:32:17 -0400 Dave Jones <davej@redhat.com> wrote:
>
> As the commit message suggests, per-arch cpufreq drivers are moving to dr=
ivers/cpufreq/
> So far, I've only moved the x86 ones.  As a side-effect of this, the=20
> source "drivers/cpufreq/Kconfig" is no longer a per-arch thing, as it now=
 gets
> included from kernel/power/Kconfig.
>=20
> I suspect the warnings are happening because on the unconverted archs, dr=
ivers/cpufreq/Kconfig
> is now getting included twice.  If you kill the 'source' line in kernel/p=
ower/Kconfig,
> does this make things go back to normal ?  (Check that cpufreq still show=
s up in
> the resulting config afterwards)

Removing the source line in kernel/power/Kconfig makes the warnings go
away and the only change in the generated config file is this:

@@ -465,10 +465,6 @@
 # CONFIG_PM_RUNTIME is not set
 CONFIG_PM=3Dy
 # CONFIG_PM_DEBUG is not set
-
-#
-# CPU Frequency scaling
-#
 CONFIG_SECCOMP=3Dy
 CONFIG_ISA_DMA_API=3Dy

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__27_Apr_2011_11_54_27_+1000_Seg0fGATmifh/1xR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNt3dUAAoJEDMEi1NhKgbsIaAH/3zSj/ZBH8QMKuJXntW09CoV
oMZWInTZbeS7ehxoVQKnrjPyfAZGHbbTAydehLnDlAFYu88uuvkm154OytczFots
ALVeMSovY9eV6vyf69JISd6NQj7CtIElaQ0/NHJidNgmKiWsP+amJygfWSo2WO2r
aJ/QuItDFJGq4fF6g6e01du2OArwpeVsnuZzMMhaf/pUnl/Q1TTNWI90tE8l8McD
foScVgy6W2Rjz6yShiBPNvqu+o9R+K099uVy9i3iUg03AyoM3Yi6ZJYTpqQT9gO+
VwlBfPrMVPPrNk7wqOqQtzQhmcoqfpJdzcQX/Cy3uF1ZskVh1hoZRJg9KDPUI/M=
=YuAM
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Apr_2011_11_54_27_+1000_Seg0fGATmifh/1xR--
