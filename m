Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1JDHLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:11:25 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:37550 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab1JDHLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:11:24 -0400
Date: Tue, 4 Oct 2011 18:11:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20111004181110.bf890fe2c8a87dee048bcee4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Oct_2011_18_11_10_+1100_qKxIT=nomBfFstRd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Oct_2011_18_11_10_+1100_qKxIT=nomBfFstRd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/wireless/ath/ath6kl/cfg80211.c:25:26: error: expected ')' befor=
e 'uint'

Caused by commit 6bbc7c35ed0f ("ath6kl: Allow enabling of P2P support")
from the wireless tree interacting with the module.h split.

I added the following patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 4 Oct 2011 18:07:51 +1100
Subject: [PATCH] ath6kl: module_param needs the inclusion of moduleparam.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wirel=
ess/ath/ath6kl/cfg80211.c
index 8d9fbd4..c201445 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -14,6 +14,8 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
=20
+#include <linux/moduleparam.h>
+
 #include "core.h"
 #include "cfg80211.h"
 #include "debug.h"
--=20
1.7.6.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Oct_2011_18_11_10_+1100_qKxIT=nomBfFstRd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOirGOAAoJEECxmPOUX5FEXzsP/igjOsVViZifEsWlSH+IkCZ/
18f7R6gK/MuFeHTkC4HTq8EcCYAr0rYPx+th0n4yxcDICPzyz90yxE5/BfEjukIa
W6W1ZxONoJVvJkErCcdz41F9XqfSL5xgPfMDxIaazSom+DD1E5+QycIdQNpkURDm
EQi5mm0Ds1zcsaRKXaMBYFzvKOf1vWE8sApXIBJLO0BBB8oghbLrX2X6wetFrDfw
n8nn7+q4WgTSy0MrrrahKLGd6qgmVU1QmLFVSMW8E5nd1SxLO6xqQeiWhIi90AzW
QGPgDzmudauYPDTt5M+cDoWLbPmICjAXeuUgl4hvA2PsM2faOE8NoQuZtJ62K1Jx
KHX+czAy879Ab09E7sd01dxrMjpD8DOnm8zHexTw4PZ4X3gW8q/FuU11xhuuxQvQ
YBuNbgYLMWJlQ8n6ftQUIbZCkSt1lDREKvx7LvHrIsF2/6jYd5Ab/sQ8CpFEl8iM
yPslniM3DSvv8QCKCL8NLI0lUbBTuiDP0xa+MlC7gdv6+E2x/r2GU77JvuW+PAjB
d+qPW67TcmpYeJDhiwOGB1FP/GVdJRQ3GGCKUIWPb2RnajKwpL6GU+qR/dVvgNy8
RjQqE9gqkg7uFHl6xvss5pr1gQUrgDshDLfL/xEct/fXadThUyfo6lGzjGenJZzy
XQZEXCyeDUa6aVT8RlU/
=q4vu
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Oct_2011_18_11_10_+1100_qKxIT=nomBfFstRd--
