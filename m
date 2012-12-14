Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab2LNKeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 05:34:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:49858 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab2LNKeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 05:34:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,279,1355126400"; 
   d="asc'?scan'208";a="263933714"
Date: Fri, 14 Dec 2012 12:34:33 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Amos Kong <kongjianjun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] PCI Hotplug: workaround for Thunderbolt on Intel
 DZ77RE-75K motherboard
Message-ID: <20121214103433.GA15240@otc-wbsnb-06>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1355412708-20046-4-git-send-email-kirill.shutemov@linux.intel.com>
 <20121213184820.GC12105@kroah.com>
 <20121213200857.GA24939@otc-wbsnb-06>
 <CAE9FiQUMSnCPwgbupZ5cFWLMiVxA4FQ2dNWNk+XYhvtEn+F3Ag@mail.gmail.com>
 <CA+55aFwxmhcgORCnDKwcp5EuzvC0iz02O4QR3H_stTXDbprYSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <CA+55aFwxmhcgORCnDKwcp5EuzvC0iz02O4QR3H_stTXDbprYSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 13, 2012 at 12:30:04PM -0800, Linus Torvalds wrote:
> On Thu, Dec 13, 2012 at 12:25 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >
> > Linus will not be happy with those kind of delay.
>=20
> Indeed. And the DMI check is bogus too, since the "there can be
> delays" is apparently part of the pcie hotplug spec.
>=20
> So do the sane thing. Retry a few times, with increasingly long delays
> (ie something like start with 10ms, then double the delay until you
> hit 1s, and then just give up: end result, ~2s total wait, but 10ms
> for any sane device that doesn't suck).
>=20
> No DMI checks, no hacks, not insane default delays.

I've realized that there's no strong criteria of hotplug success in ACPI
PCI Hotplug. We can't know when we should stop retrying.

In Thunderbolt case before any devices hotplugged you only see a root
port. Thunderbolt host controller is powered off and kernel can't see it.

On hotplug BIOS enables the host controller, initialize it and notify OS
about hotplug.

Normally kernel will enumerate 6 ports on Thunderbolt host controller, 2
ports on device Thunderbolt controller and target device itself. All this
for simple non-chained case. With device chaining the hierarchy is even
more complex.

On DZ77RE-75K motherboard without the workaround kernel will discover only
ports on host controller, but not device ports or device.

So kernel will find devices on broken implementation, not all of them.

Even worse: there's no way to distinguish between plug and unplug events
and kernel uses the same code path for both cases.

--=20
 Kirill A. Shutemov

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQywC5AAoJEAd+omnVudOMikoP/3CbwzREtxykZ82Rn+MfSYK7
PklbiRzYWGKlWa9va6o8WKsFHNjlWtCedLkI8o7sl3ThwYU14j+Lu1wJUMe24r6A
gUGC4IZDM35t8+zAR/BFtZ59B3hgEzuUqN9HLA+IcaeSd5IBkA36g6rlW3iUZGiC
IPLx0Trx8utRRQgruDjjUA0BJbdtJhgHsAHt4eVSwHh9tNh5Bzi0AfEXOTe2M61E
zqOwUo9qiOIpbdA7/YtNL0q27AuFgIrVGcJq4F7mvIbxx++CJ6QGxlu7seIX1w5e
1ASho2vJAs8g3plXoCUkkQpntl/XONfv35wG+yHyaJ0mn/G1twaWeRvSE8/2sPGn
K0h63rvBh5R4iTXRiiiRZ9QpNnr9MNLcVjnUNVKSG82lareec+o2MolEaITdkILT
ATaIhgzSVoSYlJ5b++boPQrFvQu0tdX6g2H/haIrK0LHI0LhOiMpuxDLFg8xBhLN
rkTf/aC8JO0dsn+YNCgOX34qkIgkTAhvwVQZdVmLCCPTBtI1WyrBNHqM+MVylX5A
wTu1CtODieuC0qCmjr/M85PMQo0xgQ48ZkCLjQEXh2r/Y7txcIRFg1Ld64hdlhdt
92w5QnGw0WkImm6IxgdCeeoxJ9c/tUoO7TlFEGQS0bpxTLoAKJ4y5kfoh4ct5g0c
7RFBnsCajEySL/vawBc8
=T3rD
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
