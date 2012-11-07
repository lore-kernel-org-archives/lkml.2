Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2KGAGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 19:06:10 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60088 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2KGAGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 19:06:08 -0500
Date: Wed, 7 Nov 2012 11:05:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20121107110559.862517a9ca96383d0ea8f308@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Nov_2012_11_05_59_+1100_Bq7qJ=eiT.5MqdzR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Nov_2012_11_05_59_+1100_Bq7qJ=eiT.5MqdzR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/built-in.o: In function `sms_ir_event':
(.text+0x129b95): undefined reference to `ir_raw_event_store'
drivers/built-in.o: In function `sms_ir_event':
(.text+0x129bb4): undefined reference to `ir_raw_event_handle'
drivers/built-in.o: In function `sms_ir_init':
(.text+0x129bec): undefined reference to `smscore_get_board_id'
drivers/built-in.o: In function `sms_ir_init':
(.text+0x129c17): undefined reference to `rc_allocate_device'
drivers/built-in.o: In function `sms_ir_init':
(.text+0x129cac): undefined reference to `sms_get_board'
drivers/built-in.o: In function `sms_ir_init':
(.text+0x129d41): undefined reference to `sms_get_board'
drivers/built-in.o: In function `sms_ir_init':
(.text+0x129d8c): undefined reference to `rc_register_device'
drivers/built-in.o: In function `sms_ir_init':
(.text+0x129dc3): undefined reference to `rc_free_device'
drivers/built-in.o: In function `sms_ir_exit':
(.text+0x129e15): undefined reference to `rc_unregister_device'

Caused (I think) by commit fdd1eeb49d36 ("[media] siano: allow compiling
it without RC support").  In this build, CONFIG_SMS_SIANO_RC=3Dy and
CONFIG_RC_CORE=3Dm .

I have used the v4l-dvb tree from next-20121026 again today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__7_Nov_2012_11_05_59_+1100_Bq7qJ=eiT.5MqdzR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQmaXnAAoJEECxmPOUX5FEo0IP/ijZdKJfHWqrPd/QMt5gamaF
WE/UiqWdK6yqEbpZzXgH49is5EGN6U1obC99CoTVPhiQVECNZQaxvXMOUBvz3JrD
tfl4AaqSrRQ0He/0AlscRovQN4JyEa4sUzZP30DQqRDp5G4CR+pbRqyH2L4Nf7ta
84rXL91JY0A4tnfd5SaB1cOs7L7vuNNfG7F7fAiVMr+OmSADbctoeGRYs5pqzflV
Ye6lG/Bf+VaiR3xMkt37S/rqmhFG6G/MGEUOPG6/ZxhrF+K6onO5qtA7sUY2Nl7r
D44gW9IcOHvS36zMgm2ifYqauGY4rIQsCouYLsMbwsc1D//GjqNF/jPctyM+RfdQ
FY98FFW4+6dETc6GVcxRkSvPnM80aELqRpdsOnodCdfIPj0gIATiqVpfxzdX6jI8
YDqibFtjWexJ/ZjJgYGs8Nj6mRAfWNsa1xPwkIUEQwPjR4BQIP/Mn/WBKS9jos1x
WFeemGUz8SFUrtUw1RybvQAUhVPwB768QH5ZuzLPAwNyDCaXYG6QCl69KWu9cwSG
oz5iBbHwQwbfQpw4y+I8TW6kSS2zd5buSZXTqcBdJCG9dHysmId/mCUAJq9aYzPh
3PSVG+KGEHQDNH8ZEqoJ1j514c6vOFEbN38krZRGEdPv/F22k22TvcL/VEHzDmmu
624i5taH9wXAPBbnZj82
=y9A4
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Nov_2012_11_05_59_+1100_Bq7qJ=eiT.5MqdzR--
