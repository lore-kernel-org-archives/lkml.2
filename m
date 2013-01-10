Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab3AJGzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 01:55:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64472 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3AJGzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 01:55:47 -0500
Date: Thu, 10 Jan 2013 07:55:37 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 00/14] Rewrite Tegra PCIe driver
Message-ID: <20130110065537.GC15212@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130109222517.3c590553@skate>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <20130109222517.3c590553@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:MP0cjk2FYHlCmz0+3duc9pOR12XTultm4IqnekurLi5
 dP8xS0NO8ARUeHcPCRsihnW/I0QeWVB07ViM9uNcYSNRI3Y8sH
 2tYLZRUImWySbG6XtkNBZ0KYFGZEiE5JJb5cSbQKICUOTmuQiv
 VKfqHMh8AgTBmjKFQ/VJBoh/8aLJjAWShJyfEqr8QjH9OAHE3g
 CFruJDU5pUqhs+ZE2l7TsiCW+gO1TtxKNqNdKN/GYwBaGL34E3
 +6RW2ianAHbxBo0sjTzNn6aIxeTP9939HKCa4y8uR52mVqKTi7
 8V/Hx+73PVEwdJROjB9ACQW5cF7EPG6+/wbuX5KINPglEfJ12x
 S3R53lYlUrn7VgZfkLYcxJazTK0ipz6Kh1kC1naRlV375f/yq2
 suM6X2cjADNIsadAI8YWLYgLOYARJxCpQU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 09, 2013 at 10:25:17PM +0100, Thomas Petazzoni wrote:
> Dear Thierry Reding,
>=20
> On Wed,  9 Jan 2013 21:43:00 +0100, Thierry Reding wrote:
> > This patch series contains an almost complete rewrite of the Tegra PCIe
> > driver. The code is moved to the drivers/pci/host directory and turned
> > into a proper platform driver, adding MSI and DT support while at it.
> > Other PCI host controller drivers can be added to that directory in an
> > attempt to make it easier to factor out common code.
>=20
> Thanks!
>=20
> I have started basing the Marvell PCIe code on some of your earlier
> versions. But apparently in this final version, you no longer have the
> emulated Host bridge. Why so?

The reason is that with the latest bindings the matching of root ports
to device tree nodes works as-is and nothing else indicates that the
emulated host bridge is actually required to make any of this work. So
in order not to introduce unneeded code I've left it out for now. If
somebody decides that we actually need this host bridge (for standards
compliance or whatnot) it could easily be added back.

However, before the emulated bridge implementation can be merged I think
the PCI ID issue needs to be resolved.

> For the Marvell PCIe code, I've used your emulated Host bridge, and
> added an emulated PCI-to-PCI bridge implementation, in order to get the
> following hierarchy:
>=20
>  + Host Bridge
>    + PCI-to-PCI bridge
>      + PCI Device
>    + PCI-to-PCI bridge
>      + PCI device
>=20
> So, I instantiate one unique emulated Host Bridge, and then one
> emulated PCI-to-PCI Bridge for each PCIe interface that I have.

Oh dear, that's even worse than on Tegra. The Marvell hardware doesn't
even expose the root ports as PCI devices on the bus?

> The nice thing about that is that I can then read the configuration
> space of the PCI-to-PCI bridge to find out how much I/O space and
> memory space is needed for the device connected to this interface, and
> at which address is has been mapped. This greatly helps my "address
> decoding" problem, and removes the ad-hoc virtual space allocator I had
> written.
>=20
> Is there a reason for having given up on this idea? Is there still a
> hope for a different PCIe implementation to use this idea?

I suppose that in your case it really makes sense because you already
need the emulated PCI-to-PCI bridges and therefore adding an emulated
host bridge doesn't add much. As I said, for Tegra everything still
works without, so I didn't see a reason to add needless code.

Thierry

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7mXpAAoJEN0jrNd/PrOhlVsP/jcXpyH5rON/7kzJSE1glNvK
jFGOLe3BWaBkZyDyQ9XtsJ5xOgci8I0D4iVXJgY5jcJeS+fwNMwwPSXx3HlsM5v9
bka1yhkobFAJRO1wsEC5sCa+FBq6QkbrvC32fUZiNpfC1tq5Rpc0HvkHcKefxaAP
Jw3xuJOgS4B/W9VWahtgtXZUFyRik7w4yGkHJFT/25EtbP1AiqGPxJNc+PVaQgq+
bXqh489xB6phdZT/04IvDijaVleoMJ/DOb1HE4VT6unM/blCkmccM+TpuQQsFPm/
QGvtaSyePTI4ks8f3QIB98MC/2arTYSkeJdgLBhZuEZh93zXW0hn8yT4ZDVGYSNX
kGSIaEwThR3OjwtFti8lucIFjB1akAO5dSf57rU9KbbnH9ahh/pmb1aR7mmTrdNi
XArGZ8SucR2b28gLNZRV4CcmQfg0pA/sfiPLDKAutZy/JHsWgUJ3ZtU3P7mswUSu
blnuyTe1dO9lSt5lLQ3KkOImWta4TO7+EVxzz9lQ4s17aXJsXl0AZAx6xPkEeutU
9qymt/qkiGufU0d40uSMIZHF9k2jx39MrzU5WKbEJF4q0BrywJUt5SxhL8xM5+KZ
hmqbXvWSqk+p/ezzL55oC99EYZKnHuuxRXOYzrMRH7qJA+nSoXVuBamOt7NP5QC+
rNG12Dyn9WobzrH25JQ3
=VwsQ
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
