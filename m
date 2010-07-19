Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab0GSF5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 01:57:48 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:48336 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab0GSF5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 01:57:47 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] pci: Allow read/write access to I/O port resources
Date: Mon, 19 Jul 2010 07:56:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.93; i686; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, chrisw@redhat.com,
        ddutile@redhat.com, bjorn.helgaas@hp.com
References: <20100719031148.13524.25354.stgit@localhost6.localdomain6>
In-Reply-To: <20100719031148.13524.25354.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2093424.vZ60GcRIoV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201007190756.38412.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2093424.vZ60GcRIoV
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Alex Williamson wrote:
> PCI sysfs resource files currently only allow mmap'ing, which doesn't
> work on all architectures, particularly x86.  Add read/write to
> allow access to these device regions using sysfs.

I think you should update that description a bit. It took me some time to f=
ind=20
out you are not talking about mmap() on PCI resource files in general, but=
=20
those that are backed by I/O BARs. The other ones work fine on x86 with mma=
p().

> +static ssize_t
> +pci_resource_io(struct file *filp, struct kobject *kobj,
> +               struct bin_attribute *attr, char *buf,
> +               loff_t off, size_t count, int write)
> +{

The "write" can be bool.

> +       struct pci_dev *pdev =3D to_pci_dev(container_of(kobj,
> +                                                      struct device,=20
kobj));
> +       struct resource *res =3D (struct resource *)attr->private;

No need to cast here, private is void* anyway.

Eike

--nextPart2093424.vZ60GcRIoV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkxD6RYACgkQXKSJPmm5/E7P/QCgl1q8YL3pxO2hWxKgQ2sD4Uq7
RPkAnRGLSAYYgUJVMBdpsLkqerhf333s
=2K/U
-----END PGP SIGNATURE-----

--nextPart2093424.vZ60GcRIoV--
