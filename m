Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab0CXE7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 00:59:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57951 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab0CXE7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 00:59:39 -0400
Date: Wed, 24 Mar 2010 15:59:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sujith <Sujith.Manoharan@atheros.com>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>,
       Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: linux-next: build failure after merge of the final tree (wireless
 tree related)
Message-Id: <20100324155930.1fa3367b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Mar_2010_15_59_30_+1100_VNm63cm8..Ev+Qtx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Mar_2010_15_59_30_+1100_VNm63cm8..Ev+Qtx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/wireless/ath/ath9k/ath9k_htc.o: In function `.ath9k_debug_remov=
e_root':
(.text+0xc1cc): multiple definition of `.ath9k_debug_remove_root'
drivers/net/wireless/ath/ath9k/ath9k.o:(.text+0x1b7ec): first defined here
drivers/net/wireless/ath/ath9k/ath9k_htc.o: In function `ath9k_debug_remove=
_root':
(.opd+0x9c0): multiple definition of `ath9k_debug_remove_root'
drivers/net/wireless/ath/ath9k/ath9k.o:(.opd+0x12d8): first defined here
drivers/net/wireless/ath/ath9k/ath9k_htc.o: In function `ath9k_init_debug':
(.opd+0xa08): multiple definition of `ath9k_init_debug'
drivers/net/wireless/ath/ath9k/ath9k.o:(.opd+0x1320): first defined here
drivers/net/wireless/ath/ath9k/ath9k_htc.o: In function `ath_txq_update':
(.opd+0x630): multiple definition of `ath_txq_update'
drivers/net/wireless/ath/ath9k/ath9k.o:(.opd+0xcc0): first defined here
drivers/net/wireless/ath/ath9k/ath9k_htc.o: In function `.ath9k_debug_creat=
e_root':
(.text+0xc310): multiple definition of `.ath9k_debug_create_root'
drivers/net/wireless/ath/ath9k/ath9k.o:(.text+0x1b990): first defined here
drivers/net/wireless/ath/ath9k/ath9k_htc.o: In function `.ath9k_exit_debug':
(.text+0xc24c): multiple definition of `.ath9k_exit_debug'
drivers/net/wireless/ath/ath9k/ath9k.o:(.text+0x1b86c): first defined here
drivers/net/wireless/ath/ath9k/ath9k_htc.o: In function `.ath9k_init_debug':
(.text+0xc3a8): multiple definition of `.ath9k_init_debug'
drivers/net/wireless/ath/ath9k/ath9k.o:(.text+0x1ba28): first defined here
drivers/net/wireless/ath/ath9k/ath9k_htc.o: In function `ath9k_exit_debug':
(.opd+0x9d8): multiple definition of `ath9k_exit_debug'
drivers/net/wireless/ath/ath9k/ath9k.o:(.opd+0x12f0): first defined here
drivers/net/wireless/ath/ath9k/ath9k_htc.o: In function `.ath_txq_update':
(.text+0x7cdc): multiple definition of `.ath_txq_update'
drivers/net/wireless/ath/ath9k/ath9k.o:(.text+0x13e4c): first defined here
drivers/net/wireless/ath/ath9k/ath9k_htc.o: In function `ath9k_debug_create=
_root':
(.opd+0x9f0): multiple definition of `ath9k_debug_create_root'
drivers/net/wireless/ath/ath9k/ath9k.o:(.opd+0x1308): first defined here
drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.bss+0x3980): multiple definiti=
on of `modparam_nohwcrypt'
drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x14e8): first defined here

Cause by commit fb9987d0f748c983bb795a86f47522313f701a08 ("Sujith <Sujith.M=
anoharan@atheros.com>") from the wireless tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Mar_2010_15_59_30_+1100_VNm63cm8..Ev+Qtx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkupnDIACgkQjjKRsyhoI8za8wCdFlhuZ6UPiXgTVp+HRtJeMaLO
FN0AoLoDiysu5EUzaSxGBMnWGovJmG+C
=w4jf
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Mar_2010_15_59_30_+1100_VNm63cm8..Ev+Qtx--
