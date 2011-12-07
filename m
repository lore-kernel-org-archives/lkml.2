Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab1LGVaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:30:10 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:44732 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758344Ab1LGVaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:30:08 -0500
Date: Wed, 7 Dec 2011 13:30:00 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Charlie Suffin <charlie.suffin@stratus.com>, stable@kernel.org
Subject: Re: [PATCH] pci: Add quirk for still enabled interrupts on Intel
 Sandy Bridge GPUs
Message-ID: <20111207133000.69051c59@jbarnes-desktop>
In-Reply-To: <4EDFD5BB.1050906@intra2net.com>
References: <4EDFD5BB.1050906@intra2net.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0ByMDOVCuVxrmuH.GTdPv1S"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0ByMDOVCuVxrmuH.GTdPv1S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 07 Dec 2011 22:08:11 +0100
Thomas Jarosch <thomas.jarosch@intra2net.com> wrote:
> +#define I915_DEIER_REG 0x4400c
> +static void __devinit disable_igfx_irq(struct pci_dev *dev)
> +{
> +	void __iomem *regs =3D pci_iomap(dev, 0, 0);
> +	if (regs =3D=3D NULL) {
> +		dev_warn(&dev->dev, "igfx quirk: Can't iomap PCI device\n");
> +		return;
> +	}
> +
> +	/* Check if any interrupt line is still enabled */
> +	if (readl(regs + I915_DEIER_REG) !=3D 0) {
> +		dev_warn(&dev->dev, "BIOS left Intel GPU interrupts enabled; "
> +			"disabling\n");
> +
> +		writel(0, regs + I915_DEIER_REG);
> +	}
> +
> +	pci_iounmap(dev, regs);
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0102, disable_igfx_irq);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);
> +
>  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
>  			  struct pci_fixup *end)
>  {

Could really be dev_dbg, I think this will be fairly common.  I think we
also need to ack any outstanding interrupts after disabling them in IER
by writing IIR back on itself. Can you test that?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/0ByMDOVCuVxrmuH.GTdPv1S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO39rYAAoJEIEoDkX4Qk9hg0gP/01oPKIQsSnMCJwpU02fGTQ5
/9PPGsKtzUTMN4KjRP8CHOyTGORHyCaKro9OiIq2ZLptCnCB/FxSd4ltRNxun8PD
eHCigcV5f9p1Ha+8HceFihayNP/GXvGwSYvFT3iUF8Cp+NXTxFbTNfkXefNog+hs
UBLo4ifYT7WYiMeMMqdhTDsoeXE87j9vk4c3wW/a0QJcEF0QOtygRh5FrmQrk4vJ
csWroGhBORP6tF88LaVtes/scBM0XPLMfEQgUJ1aeP3jUizzmc4JzwkOBulsUSuj
kAvzsx42OzDNJMIV0kZnY/5Fpm+tvVPXAcpW+PaLev9U7zZnxdq8NQKjp1i+1/oJ
qzQeUCjTAPokR3PMvSziGOG7tzeir5TQPhlTTPgLbpfxrwSLBpSW+tbtfAyqFaLG
yHDy5XQL8uig8oaWdkCYBoz9o4KyufU3umz3IQ5V7HP2vYnJP984+vnrmHppmKAu
5S7IkwEPahmwXJuEeYMgTfQq+hJzI1clFiTqjPAY0aW4bbP14KnuDMy8Fo6mIoSU
XKyNB4teBIPMxO74NmkoSXScXRnBwsiVZ62JiRgJO5AOPfXm8ySoY3PyYR7IXQd8
aYEHUCsPiDAVZU9LgDvmbAnYpdXBHhAMwGFanUqfNs8wbkdZucPFuBHOTPMvUFgs
PaqPDG3iLrFvYuk8H+vo
=HchF
-----END PGP SIGNATURE-----

--Sig_/0ByMDOVCuVxrmuH.GTdPv1S--
