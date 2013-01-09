Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab3AIV50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:57:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62532 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3AIV5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:57:18 -0500
Date: Wed, 9 Jan 2013 22:57:09 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Message-ID: <20130109215709.GB13648@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-6-git-send-email-thierry.reding@avionic-design.de>
 <20130109212847.GT3931@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <20130109212847.GT3931@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:M9g3jjBJZN4EnnY/jhZsTsMqWmowbw4vBnfAoanIGXU
 9Qdd+MIR0lfEeskFORHE4XwVe302gJlZJIHAp/j5QTQswc9h7P
 e+3G0z0RwtR3XaZBwMkBnjeWNl9tHjj31cAaNxOOi8gn/d/mEQ
 SlSOli9TkDLr374C4kujy6TL2qGNw0GnyWGoU4VXOg8AvZLwx7
 UNUW4CxGRyrSNTF3teARCqSeveh+FSUfE8rNtn+gE73jbmb9Ae
 IzDb5q29U4wht5LO6VL1C/ZL7UMGugJDJ8o8t2m/LCpyNE2OPw
 pjHgv3ju2UCdPKOGoY6CVsavo2iS8jKd2NG8rGyGDshuoqsAy9
 WZO85q5RoxGi3KHxORs/VOmeMX36/+ICKFZAWY7wAb/Y8kKLPp
 3xniGKKXlOzINXofp/JpuqFyVJ1CdM5Nz0sU/tLzd6kARec2Sz
 LSWxf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 09, 2013 at 09:28:47PM +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 09, 2013 at 09:43:05PM +0100, Thierry Reding wrote:
> > The I/O map cache is used to map large regions of physical memory in
> > smaller chunks to avoid running out of vmalloc()/ioremap() space.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> We already have a means where we record the mappings which ioremap()
> creates.  If you look at /proc/vmallocinfo, you'll notice lines such
> as:
>=20
> 0xf7b72000-0xf7b74000    8192 e1000_probe+0x291/0xa68 [e1000e] phys=3Dfc0=
25000 ioremap
>=20
> which gives you the virtual address range, physical address and type
> of the mapping.  Why do we need a duplicated data structure?
>=20
> Moreover, you seem to suggest that you want to break up a large
> ioremap() mapping into several smaller mappings.  Why?  The idea
> behind ioremap() is that this relationship holds true:
>=20
> 	ptr =3D ioremap(cookie + n, size);
>=20
> For any 'n' in the range 0 .. size, the location shall be accessible
> via ptr + n when using the IO space accessors.  If you're going to
> break up a mapping into several smaller ones, this no longer holds
> true.
>=20
> If the problem is that you're ioremapping huge address ranges because
> you're passing larger-than-required resources to devices, then that's
> part of the problem too.

The resource is not larger than required. It's just that in order to
address the extended configuration space of all PCI devices we require a
full 256 MiB window.

What this patch tries to achieve is allow a driver to take a large
region and ioremap() it page by page on an as needed basis.

Thierry

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7ee1AAoJEN0jrNd/PrOhOR8QALpJ5WTlmh+6oJQPNzCj0qvX
IQ9mDhcWeNfUXC/6qZzZrzQ9fIQl2BalXFnS+baGZ/3e+3+7DPCC+zipFfNb7r1t
2WgZFgHDSwDqFOtHzpEV6Q2sDMchefFqmCXiAY+kg3yfu6jK02NdMigm7Sxi0dwd
j9h4rq+FLZ4HDKBmDOxPlR8Wzgy7raXpKPY07Qi+2jaXQ/pCPxNf7zhi/wRu8GOW
0h5/K6QVs8MvjkAnbMep3SBp4xNCh4NdsB+fTc1q2rO5xXa0+7m4f+/CQ6qqGsOv
NIxTQS9/A16dNYlpdW/VrhjCzcALStwLwqd76y9lFeFiBdjBBLhLbVnrivTZq1sk
wen8pXvPcMNSWMHuaSiQwWOelloI4dYaH4ygE5O5L27t/wrFmhdrQEDV9nuxyQtX
npR9kLQyKSAdlJElLa3icmqwd5rwNHnqEUwG6Kp8HSQ/jTYmICPyj2xuf7HbM7uQ
P7Fh21QQ8mZBu7a1fz5HEiC8Hqx3XHD4VR0cnFdb2P9ai8lknYJg29BbXnXBQ0fq
l4nTVFEsxEEp2UoDPwO22Nk9pOiSGMfB/NdDgtj0lhjpKwpArPzmhekgrQW8kze3
DE57yTPS1KvIRLrnNjrdiM6EEscJV4up8nfNzA07pIn2nlqxRa1blKE6SWYG/7ld
7ogVxXsA3J3RVOEFO4HD
=zQeU
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
