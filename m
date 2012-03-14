Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015Ab2CNAl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:41:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59320 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab2CNAl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:41:26 -0400
Date: Wed, 14 Mar 2012 11:41:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>, tony@bakeyournoodle.com
Subject: arm build failures (Was: linux-next: triage for March 13, 2012)
Message-Id: <20120314114115.24e59318bdac705fec61bd89@canb.auug.org.au>
In-Reply-To: <20120313234707.GB7050@windriver.com>
References: <20120313234707.GB7050@windriver.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Mar_2012_11_41_15_+1100_JnO3hluRsRA_3lPc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Mar_2012_11_41_15_+1100_JnO3hluRsRA_3lPc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Mar 2012 19:47:07 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> ARM:netx_defconfig,pnx4008_defconfig=20
> 	when:	Mar 14, 02:43
> 	why:	net/core/pktgen.c: can't find a register in class 'GENERAL_REGS'
> 	status:=09
> 	fix:=09
> 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5869486/

This is this:

net/core/pktgen.c:682:2775: error: can't find a register in class 'GENERAL_=
REGS' while reloading 'asm'
net/core/pktgen.c:682:3153: error: can't find a register in class 'GENERAL_=
REGS' while reloading 'asm'
net/core/pktgen.c:682:2775: error: 'asm' operand has impossible constraints
net/core/pktgen.c:682:3153: error: 'asm' operand has impossible constraints

Which is a do_div() call.  The relevant code does not appear to have
changed, so this may well be a result of our toolchain changing from
"arm-linux-gcc (GCC) 4.4.0, GNU ld (GNU Binutils) 2.19.1" to
"arm-unknown-linux-gnueabi-gcc (GCC) 4.6.3, GNU ld (GNU Binutils) 2.22".

Anyone have any thoughts?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Mar_2012_11_41_15_+1100_JnO3hluRsRA_3lPc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPX+krAAoJEECxmPOUX5FEaFQP/1boh7xygAj7fKtExKPRcnWG
3Hp+6XHOXyvAVVxu6U19vSCnuzTCoi8nnSykT6m8LGGZeNUIzQF2boBUR0XNnyxt
3Exrdfd8hpdrKpaoBvqEpR0FvbrHa5XU9yjkSdX1kMp7jRLs8TWq0dqbkse8VM1o
LuFsXE4sAiNnTLMWF0lpA6oKbrr5Q3eWx5/96UVmObemomPP8Nkel8mbymHlYn7Q
e9HtRIMYlUFJ/NKKCZH+9MYMOCRizg9+il2/4mUQ6mRyWZekktnlvH503XkfGZv2
E8K+P077VavqZZHfiPtsJ0yocHhz94TkbHzt3l9aGh6DbJsG7rti3WiovxstCJsA
g2wltyYLOU1U1KKh8C3bwXDS7F/mXepluRYmrqQdNEiHgsVTK5oQmv8miA56XdYY
B4q4UmBs2ykusbUxd9IEka6o5w7ONp2dy7fdzypqKGqSvscFXSedpckQq8+Ase7K
JEHrBz8c7bbCEBpHfdne97uO7ld/njuxAxjYlXjugy3P5g6rFinpuQiDTjI9K4Hu
uG3Ei7sM8WniOqLhNKZaqNJ0XrCTjTuOLRLm5gH9xE880u9ac3o4PTa+XOd74fBI
YGqD7I1crlb0/D+TwHYrPQzjcSA5P98tUtsDjlHHwpM01KIbfTzA0QIMUqLh6GQq
tu6jGUgpunZOIQcgTvzR
=GcG4
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Mar_2012_11_41_15_+1100_JnO3hluRsRA_3lPc--
