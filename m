Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2KZEK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 23:10:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49125 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2KZEK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 23:10:56 -0500
Date: Mon, 26 Nov 2012 15:10:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: build failure after merge of the modules tree
Message-Id: <20121126151046.1b5b09762b8361b1f202c6e2@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_15_10_46_+1100_fKwgeo4LVmX30_8/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_15_10_46_+1100_fKwgeo4LVmX30_8/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the modules tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/wireless/iwlwifi/iwl-drv.c:1196:1: error: invalid suffix "n_dis=
abletype__8" on integer constant
drivers/net/wireless/iwlwifi/iwl-drv.c:1196:1: error: expected identifier o=
r '(' before numeric constant
drivers/net/wireless/iwlwifi/iwl-drv.c:1198:1: error: invalid suffix "n_dis=
able__9" on integer constant
drivers/net/wireless/iwlwifi/iwl-drv.c:1198:1: error: expected identifier o=
r '(' before numeric constant
drivers/net/wireless/iwlwifi/iwl-drv.c:1263:1: error: invalid suffix "ghz_d=
isabletype__32" on integer constant
drivers/net/wireless/iwlwifi/iwl-drv.c:1263:1: error: expected identifier o=
r '(' before numeric constant
drivers/net/wireless/iwlwifi/iwl-drv.c:1264:1: error: invalid suffix "ghz_d=
isable__33" on integer constant
drivers/net/wireless/iwlwifi/iwl-drv.c:1264:1: error: expected identifier o=
r '(' before numeric constant
drivers/net/wireless/iwlegacy/4965-mac.c:6825:1: error: invalid suffix "n_d=
isabletype__11" on integer constant
drivers/net/wireless/iwlegacy/4965-mac.c:6825:1: error: expected identifier=
 or '(' before numeric constant
drivers/net/wireless/iwlegacy/4965-mac.c:6826:1: error: invalid suffix "n_d=
isable__12" on integer constant
drivers/net/wireless/iwlegacy/4965-mac.c:6826:1: error: expected identifier=
 or '(' before numeric constant

Presumably caused by commit 58876af0436e ("moduleparam: use __UNIQUE_ID
()").  This commit removed the "__mod_" prefix that used to be added to
the front of the "name" passed to module_param_named().  Admittedly, the
documentation says that "name" must be "a valid C identifier which is the
parameter name", but the (ab)usage here used to work (the name starts
with a number).

I have used the modules tree from 20121115 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__26_Nov_2012_15_10_46_+1100_fKwgeo4LVmX30_8/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQsuvGAAoJEECxmPOUX5FESGcP/0z+Ym2MFd8xVDW/fuGpLCQS
/toaNAeHyz82sVK6TRcDoZ5WmqCXvDBlkNZRSaETjx6eV2yMk4fFjXiMeS6bF50i
KkjUt2IScKreW5tnc/Hn3ukFUngoOQgniF4XgvUl/KpXFoQsCkQO64NNiSQX0cVa
QnTZWD1g5AUMUZqMiTLzTXMcS0aRH5okKFTcKAzS/YJCu236xXCikeXAXqloD0sU
pfv55Wx/bDr9V97e1zCfYDZdT6H8wHeFOCWV4aUF/fW+z1FvweqZZL6VVTlPFI0O
PbAgrpU+jB0IBoL+CtB+sIP5sIsXIB4DvXivFltXMy42jGpVtQuxzJ0bSTNLxTpn
dzanYlppVnFxQZWu+ZFAOAp/UUEb75BcvG13jRjCuOhSi+UeUILGejgVK2ZYJJgD
LqJ60dwVjo5++gl1jJvJgCxItBJRRZXxda4kAOoGtbGLNr5YxrHkb72ZVPwBS1r7
FOz0p2q8jgDqxX81aefk3hPaGgm7pjzHLwbu3iC5xDSHknflIPEZ+wYCXJn+CdC3
TDz3TYNE2U2ko9bIkoTXKSriaX0zZgtlG7gAj8yLU85lSgf5C6lLWy0LC3X+0FbQ
XOqwB+VVeCh00qLX7jq/F/1UXIEeq+/YlYPR2PMgo3+eNkH12RA6o8qwwhlgnEBM
ESxuK1WPkThqSBRQgQCC
=pH8Z
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_15_10_46_+1100_fKwgeo4LVmX30_8/--
