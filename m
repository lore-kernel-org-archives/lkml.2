Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab2BMCVf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 21:21:35 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58391 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2BMCVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 21:21:34 -0500
Date: Mon, 13 Feb 2012 13:21:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>
Subject: linux-next: build failure after merge of the pci tree
Message-Id: <20120213132125.a292c8832d031d5694b62a8c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Feb_2012_13_21_25_+1100_CHsT7JKMtz5nodMf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Feb_2012_13_21_25_+1100_CHsT7JKMtz5nodMf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

After merging the pci tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/pci/quirks.c: In function 'do_one_fixup_debug':
drivers/pci/quirks.c:2915:2: error: implicit declaration of function 'task_=
pid_nr' [-Werror=3Dimplicit-function-declaration]
drivers/pci/quirks.c:2916:2: error: implicit declaration of function 'ktime=
_get' [-Werror=3Dimplicit-function-declaration]
drivers/pci/quirks.c:2916:11: error: incompatible types when assigning to t=
ype 'ktime_t' from type 'int'
drivers/pci/quirks.c:2918:10: error: incompatible types when assigning to t=
ype 'ktime_t' from type 'int'

Caused by commit 49107584a885 ("PCI: Annotate PCI quirks in
initcall_debug style"). Some missing include files ...

I have used the pci tree from next-20120210 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__13_Feb_2012_13_21_25_+1100_CHsT7JKMtz5nodMf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOHOlAAoJEECxmPOUX5FE4+oP/igB4iDjCxqo8lMLTuuoTPQT
GheQh0zChu8msyuPGJqA9VnO8nGAbjrP+j+aJMI8MBkJGXp3/NGLv74yrRhHI4Tm
0+GIsZY6zeNGXWyovgGCMlTrGLG7/omOf9+8Tts0qokSs9YUE0L/1HuP9Rd98fsh
A4sqvXyAWtoO5EauhnfQe1JBG5aITnrviGlHh8zwua2V3wmHo3U1m8xOfaJImcSt
SKzoNRGadx56IWmOmFye1ImPt1f1MGbfzDoffOQqXAWtpxBntyHIqhUDyja3rRKc
RZDZoo3h6xOQO8asuJDx/szhNcJeMURSO4bzCg7Wfw+CPrYBalpmxbIkrMehpuOf
xp7V5TbFj1ulRX7zip2yyVEuVAaio26kT8CSgQc8lppSSHzbOdq1z1RfFa8GXA/L
UuHHjFxPrV1hyNDkvG3v/h6jDw6MjN/C/ar42ulQKeUlXJU4uZE2XBmpZ7VP3V4G
OIc2QA20e7WT/1CWhZeM4mbili3pekN0wbz7DIg4A5sDrcCbToFASHHfXvvnp9OQ
/jDEUPd61WSnFdpmmQbWAdSCA4mmEBJdZBC9TNMvLENq/eRS9QVCNmdQReI3y0tZ
nBLogg3R43O8JDsxRWCMBGdzG99r/wrlLjIfVH3UkyQchhp1fwPE2toowKmGyt4v
fiL+pmmIIl81H1udTVhS
=sPY1
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Feb_2012_13_21_25_+1100_CHsT7JKMtz5nodMf--
