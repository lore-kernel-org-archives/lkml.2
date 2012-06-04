Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab2FDDZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 23:25:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40832 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab2FDDZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 23:25:13 -0400
Date: Mon, 4 Jun 2012 13:25:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20120604132500.56c579be8e468d9c20fc0b28@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Jun_2012_13_25_00_+1000_84Ajv7CkpOx85IaV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Jun_2012_13_25_00_+1000_84Ajv7CkpOx85IaV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "clk_enable" [sound/soc/snd-soc-core.ko] undefined!
ERROR: "clk_disable" [sound/soc/snd-soc-core.ko] undefined!
ERROR: "clk_get" [sound/soc/snd-soc-core.ko] undefined!

Caused by commit d7e7eb91551a ("ASoC: core: Add widget
SND_SOC_DAPM_CLOCK_SUPPLY").  This build does not have CONFIG_COMMON_CLK
set.  Probably missing select or dependency.

I have used the sound-asoc tree from next-20120601 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Signature=_Mon__4_Jun_2012_13_25_00_+1000_84Ajv7CkpOx85IaV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPzCqMAAoJEECxmPOUX5FEZiQP/1YjeWDkHW+3GUpLJMv34moI
NveySdio20lADIdxHfUhzFzvibnZ0NgML/+RCP2m9+x8XY/xVssS3BZjL8VAFzBh
rKfGXBPI8NFxw1/+hBgjTKGsAZIzsYAKHNeoJwjjxcpxAbmRLNUB+awcGtthkw5M
oW75hUq7eY64JcMLHDm0BV01rHdU6jjMPb7eMsey+CDXEW+RO2t2NT7908NE0WYE
Ng3Kk5jwSzQHFjCOsS83HSrrJQwsWaRbciMsPuDZJoMUkR8wp6u0+ebhcJzyltdX
qH5wTTx3s9TTO4QyOZP97IWpXcdMDxtCWUTSOkb/hRC0hjZHOot7ebq6q2mxfH/R
CwyY4XCxyTbpw5dYYO0LZ5x4gqDnycTxdRe/Wk02BRujZLx+Bu57qqg0aHafARnV
7BCZm9wxg41WERCmNSjSTMRXCaso/a7DIz80+VgO6mAjS0lx+oIl1ynbmEv2Zawe
L2qLQB9+OOOlDhfNknCMSc6EyyJZ1e+a05KfvAJKW5tZF0xYmfUcyIkO5s6lWaWr
w2iy88aqu//C+hShu+qqNBLFN0ZTMz7vwXNFGutjgYZbe9rtZCH4qgWChthn77U5
LxaGYSraARjAXbFXNLarOs0nx3mkSEM40Zc2qixpkYrZHo6RMq3K/tp3NpgV4qAU
tr9HoMQuDPXETtcrHIK0
=G11P
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Jun_2012_13_25_00_+1000_84Ajv7CkpOx85IaV--
