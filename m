Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab2IRSeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:34:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57432 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2IRSed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:34:33 -0400
Date: Tue, 18 Sep 2012 20:34:28 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: pci: Allow passing per-controller private data
Message-ID: <20120918183428.GC29360@avionic-0098.mockup.avionic-design.de>
References: <1347657078-32230-1-git-send-email-thierry.reding@avionic-design.de>
 <1347657078-32230-3-git-send-email-thierry.reding@avionic-design.de>
 <CAErSpo754W2TKr46V5FKwX43eusoOVjxkAWJ=kkB0BvRt_bJBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
In-Reply-To: <CAErSpo754W2TKr46V5FKwX43eusoOVjxkAWJ=kkB0BvRt_bJBw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ik/bhGYp6O1w5AKZUptYqaGISky524YropnqdVeZtKA
 bRM+Q+sVYdciLdmbs3qJIGYBL8EBdY/UzaWM9UguOZ488JmOpy
 re4djquRvuLA1OtKwoPkI67RNCJVkrybUXqW2ljsrDFw874H/b
 Mv8XK4PJIeTkjU7l9ayqX0xV7iiOtnkf1wVrnDKPQJxf3M5ioH
 qGrgW/mFzhXrDKZ8fJWqz/gvarL1iIzavq9n/zycNbN9vXBZrD
 IQInR8rBWwi2KYdyBqHP6BvAQsLGbaJ4Q0gBvMUIuNsUCrWzCt
 ambYYFCsUmniyXJBssV5YfCw1YjzofXjKAmt6jfD5TFXirpuwe
 XNuAYjTz/nlG9FZDdvEzpR4HWFhAdH2WyGnf6o5IBsminIZCTU
 btEWKnRoena/2SBoQ6YmA1syxmswSRIQTY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 18, 2012 at 11:21:21AM -0600, Bjorn Helgaas wrote:
> On Fri, Sep 14, 2012 at 3:11 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > In order to allow drivers to specify private data for each controller,
> > this commit adds a private_data field to the struct hw_pci. This field
> > is an array of nr_controllers pointers that will be used to initialize
> > the private_data field of the corresponding controller's pci_sys_data
> > structure.
>=20
> I guess you aren't changing the design here because struct hw_pci
> already includes "nr_controllers," but having nr_controllers and a
> private_data[] array sounds like something that might make it hard to
> hot-add a host bridge after boot.

What I do in the Tegra PCIe driver is to pass each of the root ports to
pci_common_init() individually because they can be enabled or disabled
by device tree data. I suppose to some degree you can consider that hot-
adding. Not that Tegra is likely to ever need to support that. I don't
know how likely it is for any ARM platform to ever need support for hot-
adding a host bridge.

Eventually I think it would be advantageous for this to be generalized
further such that PCI initialization can be shared across architectures.
That's probably not an easy task so I was going to start by making
incremental changes that enable the Tegra code to work and, if time
allows, help further with subsequent improvements.

It also seems that parts of the PCI core aren't ready yet for hot-adding
host bridges. One thing I came across while working on the Tegra code is
that MSI setup and teardown needs to be done by the arch_setup_msi_irq()
and arch_teardown_msi_irq() respectively, which are expected to be
builtin. That was also the last issue that keeps the Tegra PCIe driver
=66rom being built as a module. I think that will also make it impossible
to hot-add host bridges. On x86 this seems to be handled by platform
code, but on Tegra for example MSI setup and teardown is tightly coupled
to the PCIe controller. That was one of the things I thought I could
take a look at eventually, but getting Tegra support cleaned up is
higher priority right now.

Thierry

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWL60AAoJEN0jrNd/PrOhijAQAIXY0m+vI/d0rLF+VUr80XED
zSOb+7RHCOHUtff00YQ9Rhp3pjHBQv4nzQ93f6WGVNburzrPh+FZBtdjV2Gb1EdQ
fhIwcd1VyhG6TsDGg8V6mTsv4OcU08g9YDaXXFR2YKg6LaDlt11sZfTL8Fe73oJx
rajE4d+vcBpDewUFrt0qGN5Gy5ONZS8SBXiakUrAhefjyMPoBqDDs0tbQXGh1sCQ
HapD4g3Z/3CzERkIcjur1JjiJiVs0MOJoPUtEjRKt7+RFE70sPQRax+2XEjjdDHC
CJAmzKgWufeUu3Whn2lS8kb+QNnB5OCsn9HzbeSYwvJb3DhWGelNsEIfc7hvXmpk
Sk2IMbOFPX5JvZLdErKTy6ZvCWVfzPlAJuGIkhIun05Hgqg1bDAbI39s3A8W7VHz
XvbdmSor0yezvagy9FfQeEZGKTM5ndzYoRG4RBbEnZgpKq59CLH3PAvGfLBS2wfL
5MM+dqyLirEFv3d2CFUSHWcd69rS2nm2mg11+Mu28yPhVCKVjhmWLlF7NO9mG1ot
xAZekNZHlBCnBirx9/HQ5D43mHgcfNZTGZQ/WTo+UBcs3qVhVYgD2vNrkfXCbrvk
xh7yC6LiegvlDn1KkBLcgBCmytJ99tbXn90sCsbPEiAgO3p6HGKPodFmr+cPl0ug
WQq3wiZbBUSCRepnwF6j
=qwWu
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
