Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab2LMUtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 15:49:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:64410 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867Ab2LMUtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 15:49:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,276,1355126400"; 
   d="asc'?scan'208";a="261839593"
Date: Thu, 13 Dec 2012 22:49:53 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Amos Kong <kongjianjun@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] PCI Hotplug: workaround for Thunderbolt on Intel
 DZ77RE-75K motherboard
Message-ID: <20121213204953.GA25085@otc-wbsnb-06>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1355412708-20046-4-git-send-email-kirill.shutemov@linux.intel.com>
 <20121213184820.GC12105@kroah.com>
 <20121213200857.GA24939@otc-wbsnb-06>
 <CAE9FiQUMSnCPwgbupZ5cFWLMiVxA4FQ2dNWNk+XYhvtEn+F3Ag@mail.gmail.com>
 <CA+55aFwxmhcgORCnDKwcp5EuzvC0iz02O4QR3H_stTXDbprYSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <CA+55aFwxmhcgORCnDKwcp5EuzvC0iz02O4QR3H_stTXDbprYSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
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

It's ACPI PCI hotplug, not PCIe native hotplug. PCIe hotplug spec is not
relevant.

IIUC, in ACPI case devices should be ready to be enumerated, before you
get notification. Rafael, is it correct?

> So do the sane thing. Retry a few times, with increasingly long delays
> (ie something like start with 10ms, then double the delay until you
> hit 1s, and then just give up: end result, ~2s total wait, but 10ms
> for any sane device that doesn't suck).

PCI rescan is expensive and generate noise in dmesg. We'll end up with
tons of useless messages.

--=20
 Kirill A. Shutemov

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQyj9xAAoJEAd+omnVudOM3D4P/2SYoaZ/PObQ6X5Bsq9j0bZ+
48Et6ZcuF4KTfJTykS8o4HymRxr1x8lqbIfhK9SPQms7jfVPirQ5t0ayMBwU01qI
FNkmh5DvbRwliTpfKUSz+ut/FCyGE2CmCdV/H6DTDp+8zMHHEpp3jlmTv+JNBt58
dcYvpGxspQSlbNFzd75u7hbcPg0LSl6K4IUxhZ8Iv8mP2tYkmmocXLqM/aly3zUE
9IO9gWy2Vy3w32FWmGr1JQoP8OniATvZLve5L6Pea4Hc9UKLYx1EzTjWXxsJtEcI
E93ZN+ntAyU0/z9qH5ytMqgR6JOyfdveaw3wY4opIwMhj2V+fyzEBOheJKnYb6Uf
1+4iqcgEa+6G8gntfLKfCT6jnojfEyVgjGzu4Gt0bcnqRQ22qtKRMnZMxVFWPpf2
xo11Vn+2yG7FuXs4mOrUMC6mYwuYJZeYz7H+JIuiY4iSbbVVI14LLhnnkR9pyvPH
YrHYr6I9zqbQJQRjE3DlUCnqK5b/URbEYsB0AeQFrrZP5/L/q1pzd7blogGgCP1M
96iFeb0XwOsE2D/3xZ3gIbTli+gaEsBxWALCVjpM90Po/VxRXyIKcd/ymok30LrP
pKknFVA4rdsoiRTWBbJ4gsrE9FUygXtmlNrt067KvzkSBwEE7/Aovx42c1lkVcsM
KL6fICjVLnDGLzz0DWn/
=unEd
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
