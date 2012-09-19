Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab2ISWiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 18:38:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43071 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab2ISWiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 18:38:08 -0400
Date: Thu, 20 Sep 2012 08:37:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Chris Zankel <chris@zankel.net>, Greg Ungerer <gerg@uclinux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 2/2] PCI: Provide a default pcibios_update_irq()
Message-Id: <20120920083731.b99255eb8fdeea908d34ed2f@canb.auug.org.au>
In-Reply-To: <1347880974-13615-2-git-send-email-thierry.reding@avionic-design.de>
References: <1347880974-13615-1-git-send-email-thierry.reding@avionic-design.de>
	<1347880974-13615-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Sep_2012_08_37_31_+1000_w3NxfdoHc7EAjbxm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Sep_2012_08_37_31_+1000_w3NxfdoHc7EAjbxm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 17 Sep 2012 13:22:54 +0200 Thierry Reding <thierry.reding@avionic-d=
esign.de> wrote:
>
> diff --git a/drivers/pci/setup-irq.c b/drivers/pci/setup-irq.c
> index 270ae7b..3d61ce3 100644
> --- a/drivers/pci/setup-irq.c
> +++ b/drivers/pci/setup-irq.c
> @@ -17,6 +17,11 @@
>  #include <linux/ioport.h>
>  #include <linux/cache.h>
> =20
> +void __weak pcibios_update_irq(struct pci_dev *dev, int irq)
> +{
> +	dev_dbg(&dev->dev, "Assigning IRQ %02d\n", irq);
> +	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
> +}
> =20
>  static void
>  pdev_fixup_irq(struct pci_dev *dev,

Didn't we have a problem with some compiler versions when the weak
definition was in the same file as the call (there is a call to this
function in drivers/pci/setup-irq.c)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__20_Sep_2012_08_37_31_+1000_w3NxfdoHc7EAjbxm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQWkkrAAoJEECxmPOUX5FEW9wP/RZUlNoHKF/hdMIqgBXmqu9j
ziwT/7xAnOx2PyPXzlr360bi/PMcjIv3oqf4DHv1tBxYe7tzxS9j1M2Moq8UHiWW
1wOj+EXsgex73bIKtudojQojTpY9lZML9cdD5ki6zxvIEZTynAH4dSdomk2knPxw
er3HuNnawQIA4iad+FF4IFp9ojKsduCCRHEGzgC0sfLm1zT/pKgT/jQjZYjdWtKy
cTujkETaHoMG6rZdnUwmmZryGHWtPUAlWVyg9BDebJfIL32zzU66lQlpIFREyTnI
zmOrfeJ4Ypw/B0NRUvEMQbUZJtRk7L/ovddItq9NNWHgYn5pznuJOlTaPQb9owOd
i4oOZguBUyIQL92SrzMMXjxkx5RaBf8dtgGwvdvvCGv5F48Cnr3eCbQN5YQL08xQ
fek/sjc5izX0MbNjKYw4twCrOwYVpd6Hj7W8L0lhZ0NgFZIoXQi8zTmEjDtf5cHw
heVKZnH2zdtboYaiIB6utdl1/20mrq6YUd4yuQxwGpc9LveCkPxpPZ1fwTYJj6Fq
sjabH0KJVKmHTKr3LJg6xFKNh98p+Z3PlVAz4Ac6JTfCWLroBb9df9XAbHZ5kUZd
Q8RvTloTEYY6hiYKVUn7QF6iO7fUxYuY8/7s8HBhGEyJrwCrVJTpFCOgm7ySBwO5
fqCAlk6bhtq1THZ3WZZh
=VZA6
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Sep_2012_08_37_31_+1000_w3NxfdoHc7EAjbxm--
