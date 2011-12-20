Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1LTDRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:17:39 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37743 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1LTDRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:17:36 -0500
Date: Tue, 20 Dec 2011 14:17:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@st.com>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20111220141731.04efb8c1b002e3a313076378@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Dec_2011_14_17_31_+1100_gdjoyRnlr6+XXf1r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Dec_2011_14_17_31_+1100_gdjoyRnlr6+XXf1r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/built-in.o: In function `i2c_block_write':
stmpe-i2c.c:(.text+0xf4553): undefined reference to `i2c_smbus_write_i2c_bl=
ock_data'
drivers/built-in.o: In function `i2c_block_read':
stmpe-i2c.c:(.text+0xf457f): undefined reference to `i2c_smbus_read_i2c_blo=
ck_data'
drivers/built-in.o: In function `i2c_reg_write':
stmpe-i2c.c:(.text+0xf45ab): undefined reference to `i2c_smbus_write_byte_d=
ata'
drivers/built-in.o: In function `i2c_reg_read':
stmpe-i2c.c:(.text+0xf45d4): undefined reference to `i2c_smbus_read_byte_da=
ta'
drivers/built-in.o: In function `stmpe_init':
stmpe-i2c.c:(.init.text+0xaf22): undefined reference to `i2c_register_drive=
r'
drivers/built-in.o: In function `stmpe_exit':
stmpe-i2c.c:(.exit.text+0x5e5): undefined reference to `i2c_del_driver'

Caused by commit b25a31a3b4d3 ("mfd: Separate out STMPE controller and
interface specific code").

I have used the mfd tree from next-20111219 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Dec_2011_14_17_31_+1100_gdjoyRnlr6+XXf1r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7/5LAAoJEECxmPOUX5FE4skP/RJevMmB9UCCBOBXy6EZn9Mt
qJKe3eJetTVzN6KbB6QP6A2VhpvGQJV0IA1cZvEtlaF3gLgdq9NGhk4YE6F/zsHa
v2vNtC/XkDiihBZqLGtTY7uFDE85djTDq/5pJ1zHFKFC/9u4NpowKboEvxwbIMrb
k2IQygQBub7G4EALkYdA5OEzHRx2q46rDp4vIwewypE91q84Hw3b5HmT146gZFU/
GxEk6t7gD7Ms4R1AFXEeXOtnCQL8epjtFWQdvyEYGrTsWcofupE2IQMSAPcrjJky
z0CMqQtEz1OOoh2q1ySx88Xu2AFG9a6pQ3DuYoLZ92tKXBa7F7Dp2Y7dx9sqUhAg
6eg6qBnb/WsyYa64TlTBLmQUutvL62VqZrKOWHShns9RmeT9iUtzZWj/LyKj1JQ+
DDm3yfswmBaTsMLRCfD4oLW7GVKWv/NyILVMFAuhWr57H8TrirzlZAj3DnFbUqKr
zJgQhVpHV4JlUTm1wkuOidGuL27ryvntR+1LeExNCJz8n2v7f0eWBFgt+PBiBf8P
qvPliL2KYR+RGFdItAfVfJEaGE2n1RYw3OfLczp0dHwZ4A1W7vnkZBv9pt4FThuO
9vgpvBbJnF64iMtWCbYAeBiHgcEecvNG6UtknxUim/rKm3eNS+OJCTNTn2E5kiH0
s5uiag95LFXNfk9e3FRD
=ahLh
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Dec_2011_14_17_31_+1100_gdjoyRnlr6+XXf1r--
