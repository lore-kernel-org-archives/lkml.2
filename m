Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2HST3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 15:29:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52659 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab2HST3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 15:29:37 -0400
Message-ID: <1345404573.1930.9.camel@kyv>
Subject: Re: [PATCH 1/8] arm: sam9_l9260_defconfig: adjust UBI bad
 eraseblocks limit
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Sun, 19 Aug 2012 22:29:33 +0300
In-Reply-To: <1345404079.1930.7.camel@kyv>
References: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
	 <1345214124-5478-2-git-send-email-richard.genoud@gmail.com>
	 <1345404079.1930.7.camel@kyv>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Iyp+NC1k9+XSivPnwoYi"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Iyp+NC1k9+XSivPnwoYi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-08-19 at 22:21 +0300, Artem Bityutskiy wrote:
> I'll just remove this from from the defconfig and make it use the
> default, which is more sensible for this device, as your research
> showed.

Actually, pushed this patch to l2-mtd.git:


From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Sun, 19 Aug 2012 22:22:23 +0300
Subject: [PATCH] arm: sam9_l9260_defconfig: correct CONFIG_MTD_UBI_BEB_LIMI=
T

UBI has changed the MTD_UBI_BEB_LIMIT semantics. It used to be a percent of
total amount of eraseblock in the partition, and now it is the maximum
amount of bad eraseblocks on the entire devise per 1024 eraseblocks. So not
only the units changed, but also the meaning.

Richard Genoud <richard.genoud@gmail.com> says:

"I found the board:
https://www.olimex.com/dev/sam9-L9260.html
and the nand datasheet:
http://www.rockbox.org/wiki/pub/Main/LyrePrototype/K9xxG08UXM.pdf
page 11, we can see that the max_bad_bebper1024 is 25 (100 for 4096)"

Thus, use "25" for sam9.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 arch/arm/configs/sam9_l9260_defconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/configs/sam9_l9260_defconfig b/arch/arm/configs/sam9_=
l9260_defconfig
index da276f9..b4384af 100644
--- a/arch/arm/configs/sam9_l9260_defconfig
+++ b/arch/arm/configs/sam9_l9260_defconfig
@@ -39,7 +39,7 @@ CONFIG_MTD_NAND=3Dy
 CONFIG_MTD_NAND_ATMEL=3Dy
 CONFIG_MTD_NAND_PLATFORM=3Dy
 CONFIG_MTD_UBI=3Dy
-CONFIG_MTD_UBI_BEB_LIMIT=3D3
+CONFIG_MTD_UBI_BEB_LIMIT=3D25
 CONFIG_MTD_UBI_GLUEBI=3Dy
 CONFIG_BLK_DEV_LOOP=3Dy
 CONFIG_BLK_DEV_RAM=3Dy
--=20
1.7.11.2

--=20
Best Regards,
Artem Bityutskiy

--=-Iyp+NC1k9+XSivPnwoYi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQMT6dAAoJECmIfjd9wqK0MRIP/juPHYiUHZuwmEYSYJ3jUJTu
RQqPMpAvWLPizjFMNC1zNY93RRms4CZ1wwCfcpNB3m7r3meN+0f+WnpGSjeswuvd
EqmiXETDIDVBIt1iNiX6VjWSbhVF49R8a72fNG9MVHv2CQ88yuoGMgns6CCehKb+
5YSIi06hbPC8gtdpmV440meVo1PwQdjHc52OvixMkXmTsU7+f5ydnyPq8WzqRagN
VZYyc2Wq4IrtnUNGc38Ape7ULhlY/OontfVYkCLKqwrzOPJAzrWS27MdwnbO9koo
F+A6FPf1pkLehIVkmkNfCOQ9DTc/uZkoemvsNkqrDfVjJpvaFTnmJGKznqzvM5RI
lmeb8ReO9DSBrffUs5bGQmDQt6Boj4EXc3zA9FP+xVtg1vAd5KivGknzQ0xMCHGb
8BGGU3TO89VtDO+RAxe48eeJQPe9NgQ0QwE9Udbbvocg0EUzMowBcKtyjRn4gSjI
V3tAQ1wLNBo16mndzpxgL1Ht+ISrnZ6U/6fHWoiG7Zgp1AqvPG0kqHaSxIXyYz83
kzhTX52tHZekWXZS9RQXqhz/KY1Zug+ZQXY2RqCsDArtUCrmPDt6c066EiyLP6p0
K65SUo/wwCiFWRxjIJU8cenAtJsUDI5hbi3DarQ7JRk1vvlFTynhYfXGrKMZkPO3
UCC1yXYV9ghjiDVM90TM
=LvP1
-----END PGP SIGNATURE-----

--=-Iyp+NC1k9+XSivPnwoYi--

