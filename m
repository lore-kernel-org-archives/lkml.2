Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1EKC1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 22:27:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44488 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab1EKC1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 22:27:48 -0400
Date: Wed, 11 May 2011 12:27:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: linux-next: build failure after merge of the voltage tree
Message-Id: <20110511122738.93d239cb.sfr@canb.auug.org.au>
In-Reply-To: <6B0D58A8-B278-49D6-835F-C38E7517FCD5@slimlogic.co.uk>
References: <20110510124434.b30a7631.sfr@canb.auug.org.au>
	<1305016712.3206.2.camel@odin>
	<6B0D58A8-B278-49D6-835F-C38E7517FCD5@slimlogic.co.uk>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_May_2011_12_27_38_+1000_sSqZUiikFuRIm8n="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_May_2011_12_27_38_+1000_sSqZUiikFuRIm8n=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jorge,

On Tue, 10 May 2011 12:30:36 -0500 Jorge Eduardo Candelaria <jedu@slimlogic=
.co.uk> wrote:
>
> On May 10, 2011, at 3:38 AM, Liam Girdwood wrote:
>=20
> > On Tue, 2011-05-10 at 12:44 +1000, Stephen Rothwell wrote:
> >> Hi Liam,
> >>=20
> >> After merging the voltage tree, today's linux-next build (x86_64
> >> allmodconfig) failed like this:
> >>=20
> >> ERROR: "tps65910_gpio_init" [drivers/mfd/tps65910.ko] undefined!
> >> ERROR: "tps65910_irq_init" [drivers/mfd/tps65910.ko] undefined!
> >> ERROR: "irq_modify_status" [drivers/mfd/tps65910-irq.ko] undefined!
> >> ERROR: "irq_set_chip_and_handler_name" [drivers/mfd/tps65910-irq.ko] u=
ndefined!
> >> ERROR: "handle_edge_irq" [drivers/mfd/tps65910-irq.ko] undefined!
> >>=20
> >> I have used the voltage tree from next-20110509 for today.
> >=20
> > Jorge, could you send a fix for this today.
>=20
> The following patch should solve this:
>=20
> From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> MFD: Fix TPS65910 build
>=20
> Support for tps65910 as a module is not available. The driver can
> only be compiled as built-in. OTOH, the regulator driver can still
> be built as module without breaking the compilation.
>=20
> Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>

Today (even with the above patch included) I got these errors from the
x86_64 allmodconfig build:

tps65910.c:(.text+0xf4140): undefined reference to `i2c_master_send'
drivers/built-in.o: In function `tps65910_i2c_read':
tps65910.c:(.text+0xf41d2): undefined reference to `i2c_transfer'
drivers/built-in.o: In function `tps65910_i2c_init':
tps65910.c:(.init.text+0xcb83): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `tps65910_i2c_exit':
tps65910.c:(.exit.text+0x6e0): undefined reference to `i2c_del_driver'

I have used the voltage tree from next-20110509 again today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_May_2011_12_27_38_+1000_sSqZUiikFuRIm8n=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNyfQaAAoJEDMEi1NhKgbs3UYH/1f8QV+OL2HUxCgRp4vHuQHi
pY3xLe7nfEr1Jd2aGr+9laEo56dbl88Cvm3yEyc5gsWrR5QCE5iS1SZZ/4DQkoNk
4z0QCbXxQo7LxPE21S2ueFeKRxvP9Pj//4jryxZCbE/jW2reujuteTkO382T7u6G
eP/uwR3w/zd7TXZf96X2suvgHeSg+FzdDXYcL9APmfFo/FRotNxYGjgCtRA+IBiT
emG7qvCrsReU2rpNyfGvdo2vF1UKEsW8Ajgrp7sSI+EQPPlY6mnzKsLnPEJ70vue
u0M6+yXpB/R8dxrlMSvj7z3+ePTBUPyVtVdrs0Keu6n+zW2fZDS4SdNjxDuU7Ks=
=k1Ex
-----END PGP SIGNATURE-----

--Signature=_Wed__11_May_2011_12_27_38_+1000_sSqZUiikFuRIm8n=--
