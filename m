Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab1JDHDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:03:44 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:33444 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab1JDHDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:03:42 -0400
Date: Tue, 4 Oct 2011 18:03:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20111004180333.44f741dc08063a918c9b581f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Oct_2011_18_03_33_+1100_WU1CQ9q/fwc4eM/f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Oct_2011_18_03_33_+1100_WU1CQ9q/fwc4eM/f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/wireless/ath/ath6kl/debug.c:237:11: error: 'THIS_MODULE' undecl=
ared here (not in a function)

Caused by commit 9a7308341b71 ("ath6kl: silence "invalid rate" warning")
from the wireless tree interacting with the module.h split.

I added this patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 4 Oct 2011 18:01:03 +1100
Subject: [PATCH] ath6kl: THIS_MODULES needs export.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless=
/ath/ath6kl/debug.c
index ba3f23d..7879b53 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -19,6 +19,7 @@
 #include <linux/circ_buf.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
+#include <linux/export.h>
=20
 #include "debug.h"
 #include "target.h"
--=20
1.7.6.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Oct_2011_18_03_33_+1100_WU1CQ9q/fwc4eM/f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOiq/FAAoJEECxmPOUX5FExJcQAJAtsW8Cax0YZRhVnjvtDWtR
24XFScXrAzUTiHhL7TDKocl2ulhpLTIB5KpFXWr6BdwslgELEKkX0qtg+2xuWvZB
7O44kBEJQBi2uTUalsfJV8OVRzGNta0wSfBpAxQn34Jarmp9jIL1mIuTFk9GCGfK
gk6UPvxlL1of9svAGWgzfsgPAJlMzWlJ8JonvsuL2KHEeR/3YaD5MAFWrDcncS3b
jb+EBEMBslIEix4Y4Ysjbaum/GxkfmO6WmZ0a1uExak2nE3BVw7ODr4H6IQVSU4D
eWbdrpkL+ziip+Egoavr6GYQFQ2j4Vs0XmhSm+341jFrg0rKDCANq5rXGdI+dUpZ
u12cFVNQpOQr0IUHohTsv3iHzFnGyE6rcnm3crMVFU6akUsmtZ4NHfyRQP9EjocM
TTFwSvC5U0ZsZVYbsRJoCRTzucOasCZnfdTqMjFwGIwQfzYlTcsUGV6CILO8Gcn1
WETPFLIyUSj1R6smNNBomllCtSwrrodRzVw6i2MTnq8DPuujudPoJ08FWOJHN0xh
IkAYDnc/NXC3sJh0zXJMyNjU8uZ/lv6QPWAfQyrjV+YDq2D6FfAya3hAb7tzs8mj
5JAfZRn4uDR6JHO1IxvP3CBPTV/8GXVbS5f7uCv403JjvSxnjagMclSDvkKAMv/9
9df8zgSHzOdt6vghjS1Y
=Hk5u
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Oct_2011_18_03_33_+1100_WU1CQ9q/fwc4eM/f--
