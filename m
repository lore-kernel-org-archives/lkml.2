Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3AGW6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:58:06 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58429 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab3AGW6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:58:03 -0500
Date: Tue, 8 Jan 2013 09:57:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: linux-next: comment in commit in the slave-dma tree (dmaengine:
 dw_dmac: Enhance device tree support)
Message-Id: <20130108095752.9e1529a2d32d0635490cd16e@canb.auug.org.au>
In-Reply-To: <20130107224308.GB27477@kroah.com>
References: <20130108093557.8a29d4a04b95702fc59790ff@canb.auug.org.au>
	<20130107224308.GB27477@kroah.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Jan_2013_09_57_52_+1100_ifdJAzjh5p2/3eG2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Jan_2013_09_57_52_+1100_ifdJAzjh5p2/3eG2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 7 Jan 2013 14:43:08 -0800 Greg Kroah-Hartman <gregkh@linuxfoundatio=
n.org> wrote:
>
> That brings up something I wanted to ask you.
>=20
> I'd like to send a patch to Linus to just delete __devinit and friends
> entirely from init.h, but that will break the linux-next tree from
> building in places (like this one, and in a few others.)
>=20
> Is that ok?  That should finally get everyone's attention and keep them
> from the cargo-cult programming mode of using these attributes :)

I guess I can apply fixup patches that just remove any instances that
turn up ... and you and the tree owner will get copies of those.

So, if Linus takes it, I will cope.

This is what "git grep -E '__dev(init|exit)'" returns for next-20130107:

arch/ia64/kernel/iosapic.c: *				__init/__devinit attributes.
drivers/dma/dw_dmac.c:__devinit dw_dma_parse_dt(struct platform_device *pde=
v)
drivers/media/platform/sh_veu.c:static int __devinit sh_veu_probe(struct pl=
atform_device *pdev)
drivers/media/platform/sh_veu.c:static int __devexit sh_veu_remove(struct p=
latform_device *pdev)
drivers/media/platform/sh_veu.c:	.remove		=3D __devexit_p(sh_veu_remove),
drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c:static int __devinit
drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c:static void __devexit qlcn=
ic_remove(struct pci_dev *pdev)
drivers/power/reset/restart-poweroff.c:static int __devinit restart_powerof=
f_probe(struct platform_device *pdev)
drivers/power/reset/restart-poweroff.c:static int __devexit restart_powerof=
f_remove(struct platform_device *pdev)
drivers/power/reset/restart-poweroff.c:	.remove =3D __devexit_p(restart_pow=
eroff_remove),
drivers/regulator/lp8755.c:	.remove =3D __devexit_p(lp8755_remove),
drivers/scsi/ipr.c:static int __devinit ipr_enable_msix(struct ipr_ioa_cfg =
*ioa_cfg)
drivers/scsi/ipr.c:static int __devinit ipr_enable_msi(struct ipr_ioa_cfg *=
ioa_cfg)
drivers/scsi/ipr.c:static void __devinit name_msi_vectors(struct ipr_ioa_cf=
g *ioa_cfg)
drivers/scsi/ipr.c:static int __devinit ipr_request_other_msi_irqs(struct i=
pr_ioa_cfg *ioa_cfg)
drivers/scsi/ips.c:/* 5.30.00  - use __devexit_p()                         =
                     */
scripts/tags.sh:	-I __initdata,__exitdata,__initconst,__devinitdata	\
scripts/tags.sh:	-I __devinitconst,__cpuinitdata,__initdata_memblock	\
sound/oss/swarm_cs4297a.c:* 11/10/00 bkz - added __devinit to cs4297a_hw_in=
it()

so there are just a few left.

BTW, I am *not* reporting merge fixes I am doing due to your tree wide
removal of __dev*, but they are still turning up :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Jan_2013_09_57_52_+1100_ifdJAzjh5p2/3eG2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ61LwAAoJEECxmPOUX5FEw0IP/3Iq8veeLvSwuKE+g8mRIOc5
969W1F5ZgxX/MQEiSxw21VywoxZnaa4aFY6tpZG4JumcAQKvEpvKweNFzXx0LgF+
46D4r1gQTppmGxT/S0xvgVRQU+88doGZALKz7T1a3WSnJFsCW2+ftjTTt2KBrt0O
WK3iABHLUsjkHmPEp7QfJqupFDixqewVkmKvOLTPE3C/7nNA1z9zg6S62EvSOKZN
KChTz6GJynJ9i4YMsFdNY2MpGD+bYvppbikdc2WX0aYDhWqGezxBgbKSSLwt/SYv
bZETollC0vnSL66Ka0asbg4PMVEUlsBb63H/Bm66sF+9eflSXaOsSdTgQz0018uH
kdXEz5gTFBOysWO+f8ccnv82sk4Upnx54rB+2FqpX+BG3xIiOL7ozqHNbyUiNyk5
QOqKVlEcgwMDftswIBY+KWPbD63tfi+Slv2IDpF7FratkdRm8iAvRKQYEGlaL2yV
Aem5MF/4Q4EdI5JSs28uZcuQR3QPhuXBlXsx2jEPUBMeOM9q2dJC0kG7Ip+seY7b
Qow3rIrPwa5X+1VYhUt0Yg7Ke5NcpS8q85wsOR03g5SSJkkxQEKGIvWTW/DeXbw+
4Kr/XQL+IwQIb2wIKJTMvEVe9Ld/PQOXjyWhUmy0jdz1QV3PBtQVsqFp7hwtH7OX
eR8zuCdVL98UqB+HbvM1
=MyJ2
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Jan_2013_09_57_52_+1100_ifdJAzjh5p2/3eG2--
