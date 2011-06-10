Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab1FJGJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 02:09:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33081 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab1FJGJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 02:09:44 -0400
Date: Fri, 10 Jun 2011 16:09:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: brudley@broadcom.com, henryp@broadcom.com, rvossen@broadcom.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (staging related)
Message-Id: <20110610160938.cd01c408.sfr@canb.auug.org.au>
In-Reply-To: <20110610160548.529797c7.sfr@canb.auug.org.au>
References: <20110609172745.dfd3a298.sfr@canb.auug.org.au>
	<20110609184127.GA2760@kroah.com>
	<20110609192243.GA3980@kroah.com>
	<20110610160548.529797c7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__10_Jun_2011_16_09_38_+1000_kha_PEFd1SqmUJNf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Jun_2011_16_09_38_+1000_kha_PEFd1SqmUJNf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Fri, 10 Jun 2011 16:05:48 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> No, I still get these:
>=20
> In file included from drivers/staging/comedi/drivers/addi_apci_035.c:7:0:
> drivers/staging/comedi/drivers/addi-data/addi_common.c: In function 'i_AD=
DI_Attach':
> drivers/staging/comedi/drivers/addi-data/addi_common.c:2765:7: error: imp=
licit declaration of function 'virt_to_bus'
>=20
> virt_to_bus is only defined for 32 bit powerpc (not 64 bit) (and maybe
> not at all on some architectures e.g. sparc).
>=20
> From Documentation/DMA-API-HOWTO.txt:
> "All drivers should be using these interfaces with no exceptions.  It
> is planned to completely remove virt_to_bus() and bus_to_virt() as
> they are entirely deprecated.  Some ports already do not provide these
> as it is impossible to correctly support them."

Drivers that use virt_to_bus should Kconfig depend on VIRT_TO_BUS.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__10_Jun_2011_16_09_38_+1000_kha_PEFd1SqmUJNf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8bUiAAoJEDMEi1NhKgbsE2UIAKAjetzG4qTmge+axcpxmYqp
16R1qsbjB/36AycJjWGkh1YQj6NGrSrr1mIAvE72t+drVxHs5HDyjGR06MqgYpVk
x/lJXdBLVNEm/FCxhPgcSUMbYwuhEfrXQyWR//5sX89vMuDe6eIdV1qkL2OcNud0
+Yaor17YFxac2YJw7J90BNIF6YBpTAuiHBuEor3OwZ6XnfGlt68wQFhbwPx/Huqj
Dsh0+e+eIT9YjB9Pwc0mLZAuGZlFDzE/cYtM6JUO3NYlN2cKI6whPDXuUwNoyZlY
F3VmuKc/uK/864TgR3UhJqPEEG0gPgxvXPIbtzXWDJ95blk/bnwk1NA6v0Ca/5k=
=zl8R
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Jun_2011_16_09_38_+1000_kha_PEFd1SqmUJNf--
