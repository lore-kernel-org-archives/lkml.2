Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2IRSxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:53:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58090 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab2IRSx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:53:26 -0400
Date: Tue, 18 Sep 2012 20:53:22 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: pci: Allow passing per-controller private data
Message-ID: <20120918185322.GE29360@avionic-0098.mockup.avionic-design.de>
References: <1347657078-32230-1-git-send-email-thierry.reding@avionic-design.de>
 <1347657078-32230-3-git-send-email-thierry.reding@avionic-design.de>
 <CAErSpo754W2TKr46V5FKwX43eusoOVjxkAWJ=kkB0BvRt_bJBw@mail.gmail.com>
 <20120918183428.GC29360@avionic-0098.mockup.avionic-design.de>
 <CAErSpo591Ybuf95nU-O38=PrqtuJHWkWcce+5Owbc8YAprAUBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uwl7UQhJk99r8jnw"
Content-Disposition: inline
In-Reply-To: <CAErSpo591Ybuf95nU-O38=PrqtuJHWkWcce+5Owbc8YAprAUBw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:2CM7bTRi8ZXB5WLj0KdXBCRHMUOADOnZN/Jt6Aj6uE/
 nSZSOc750mrWBNUWtksz7T37FoFQ7wrzV7x8yYbwiGlyhGl+H4
 DQBjWyxPyrzc+Z3WKe/WrU4id/w/imVn3R4djgA/AAcolrzNbh
 7PdYa/IUYWHcx3tXwHFvUjRFZlU5LO+UUj/xYorlezXLdVRq1t
 7eEmSICEuqDm4+HO5qBvcG7Wdy5u+/AixQJ70f/Hef2jeVGCcD
 kmx0QJ42Le5KYSgk4rGKAhTmgWkqIKGyvBUtb+NDY4mGa8Cjs9
 H9M5OkVLcALrNEoQx1JNfPfc7dyVdIrJfYch8p8N7rCs6Ud9MK
 q1a1CqrTghkDwZwOgI4H9ppk+/Qi6v2qiIPG7YLlvXPS/yFhoc
 P5CP+fy13xo28RTsYiQ4TWlq5NBXPnll1VTGxfYu6sSqf6LlAH
 CnSh7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Uwl7UQhJk99r8jnw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 18, 2012 at 12:38:53PM -0600, Bjorn Helgaas wrote:
> On Tue, Sep 18, 2012 at 12:34 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > On Tue, Sep 18, 2012 at 11:21:21AM -0600, Bjorn Helgaas wrote:
> >> On Fri, Sep 14, 2012 at 3:11 PM, Thierry Reding
> >> <thierry.reding@avionic-design.de> wrote:
> >> > In order to allow drivers to specify private data for each controlle=
r,
> >> > this commit adds a private_data field to the struct hw_pci. This fie=
ld
> >> > is an array of nr_controllers pointers that will be used to initiali=
ze
> >> > the private_data field of the corresponding controller's pci_sys_data
> >> > structure.
> >>
> >> I guess you aren't changing the design here because struct hw_pci
> >> already includes "nr_controllers," but having nr_controllers and a
> >> private_data[] array sounds like something that might make it hard to
> >> hot-add a host bridge after boot.
> >
> > What I do in the Tegra PCIe driver is to pass each of the root ports to
> > pci_common_init() individually because they can be enabled or disabled
> > by device tree data. I suppose to some degree you can consider that hot-
> > adding. Not that Tegra is likely to ever need to support that. I don't
> > know how likely it is for any ARM platform to ever need support for hot-
> > adding a host bridge.
> >
> > Eventually I think it would be advantageous for this to be generalized
> > further such that PCI initialization can be shared across architectures.
> > That's probably not an easy task so I was going to start by making
> > incremental changes that enable the Tegra code to work and, if time
> > allows, help further with subsequent improvements.
> >
> > It also seems that parts of the PCI core aren't ready yet for hot-adding
> > host bridges. One thing I came across while working on the Tegra code is
> > that MSI setup and teardown needs to be done by the arch_setup_msi_irq()
> > and arch_teardown_msi_irq() respectively, which are expected to be
> > builtin. That was also the last issue that keeps the Tegra PCIe driver
> > from being built as a module. I think that will also make it impossible
> > to hot-add host bridges. On x86 this seems to be handled by platform
> > code, but on Tegra for example MSI setup and teardown is tightly coupled
> > to the PCIe controller. That was one of the things I thought I could
> > take a look at eventually, but getting Tegra support cleaned up is
> > higher priority right now.
>=20
> The PCI core doesn't support hot-add of host bridges yet, but there's
> a lot of work in that area right now, which is why it's on my mind :)
> I'm not suggesting you change anything here; just keep it in the back
> of your mind for the future.  Thanks for the arch_setup_msi_irq() tip;
> I'll look into that.

I think it wouldn't even be that hard to implement. When I last looked
at this it seemed like a simple registration mechanism in the core
should work. That is the core would keep a list of registered host
bridges, each of which would implement setup_msi() and teardown_msi()
operations. Then, whenever an MSI is requested, the core would look up
the corresponding host bridge and call the associated setup_msi()
callback. Perhaps these could go into struct pci_ops. It already has
pointers for configuration space access, which is also controller-
specific.

Thierry

--Uwl7UQhJk99r8jnw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWMMiAAoJEN0jrNd/PrOhpnAQAIdhoyxhVvDD2AM9w9urVBFr
X6OzWfdq68GklEdbATAn1shKZRcotmHjJZRz5Wv3dmNJuqJpvT9MPgn+vl0GCjgv
FP/F0Gb2zo4sd3jkamyt4WCCJ9df71aNWSD3Nvgzm7AugfRzaljTgujMDI3J6zgn
hLRmLxLVtywgPhKewQTbR9neWrVQv2Q+2oGRthy/Q8Eme9c3MOKN/7D7pFJqqCh3
of126ChIFg93zghOZfI2FMLdfOYhUKpwcNDSSTc99qkJ2l3/BgDWM4XlsN5FIn7F
wJWDrYbg6rHgnWPOdpgiTB3KQOzwo6SNatm9lz7xinIE49U1aJ4hQ6A01kMslhPm
k+BYhoVdTURkTQpjHpcsclw6sJT95IMJSNgmXKAnBnlACJoPmEyK15TsVpLV7CNd
LZcpwF68C/tIziRZwR8NM3AVr6YMAJH7DLmN6tFZBpmQUCvCap4V6WbhoYfYZytB
dSlTrFRBSLau5q/wpbpGhClMOUxwjcLhENPFroWidggOfF81XJnQEXsUST3mg1KE
ZG9DCi3hxxp1CwUmDgF1dYf0zRvaKWpE0SWpZb22s7tfvPn1pftdMVnqiuk8beRY
ocNgsnHsSW6HUPrnX2vBB8Ilc0753BnRwf06dAxNvY7kVHSnbXEuaJhN2b50HJth
ZYH/4MF/jIjTbpYQisIw
=x6x1
-----END PGP SIGNATURE-----

--Uwl7UQhJk99r8jnw--
