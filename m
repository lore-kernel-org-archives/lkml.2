Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab1JLGaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 02:30:24 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:34034 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1JLGaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 02:30:21 -0400
Date: Wed, 12 Oct 2011 17:30:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: build warnings after merge of the moduleh tree
Message-Id: <20111012173019.37dbde1f6797be48f8ad7c62@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Oct_2011_17_30_19_+1100_RwSsvp=ToqC4mCP0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Oct_2011_17_30_19_+1100_RwSsvp=ToqC4mCP0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

drivers/net/wireless/brcm80211/brcmutil/wifi.c:43:1: warning: data definiti=
on has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/wifi.c:43:1: warning: type defaults=
 to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/wifi.c:43:1: warning: parameter nam=
es (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/wifi.c:79:1: warning: data definiti=
on has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/wifi.c:79:1: warning: type defaults=
 to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/wifi.c:79:1: warning: parameter nam=
es (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/wifi.c:136:1: warning: data definit=
ion has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmutil/wifi.c:136:1: warning: type default=
s to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmutil/wifi.c:136:1: warning: parameter na=
mes (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:348:1: warning: data defin=
ition has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:348:1: warning: type defau=
lts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:348:1: warning: parameter =
names (without types) in function declaration [enabled by default]
drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:363:1: warning: data defin=
ition has no type or storage class [enabled by default]
drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:363:1: warning: type defau=
lts to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:363:1: warning: parameter =
names (without types) in function declaration [enabled by default]

Caused by commit 5b435de0d786 ("net: wireless: add brcm80211 drivers")
from the wireless tree interacting with the module.h split up.

I have added the following patch:

=46rom 9ea7a8cb92322497a92d464e6e40cd1da20fbcde Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 12 Oct 2011 17:22:53 +1100
Subject: [PATCH] net: wireless; brcm80211: add export.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |    1 +
 drivers/net/wireless/brcm80211/brcmutil/wifi.c   |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net=
/wireless/brcm80211/brcmfmac/bcmsdh.c
index bff9dcd..76c78fd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -21,6 +21,7 @@
 #include <linux/pci_ids.h>
 #include <linux/sched.h>
 #include <linux/completion.h>
+#include <linux/export.h>
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
diff --git a/drivers/net/wireless/brcm80211/brcmutil/wifi.c b/drivers/net/w=
ireless/brcm80211/brcmutil/wifi.c
index 509e25c..5616fa8 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/wifi.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/wifi.c
@@ -13,6 +13,8 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
+#include <linux/export.h>
+
 #include <brcmu_wifi.h>
=20
 /*
--=20
1.7.6.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__12_Oct_2011_17_30_19_+1100_RwSsvp=ToqC4mCP0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlTP7AAoJEECxmPOUX5FEjJAP/Rp7hd5wEMpR7WvKV7TL+SyR
S8WfNAoZvwAWzNkXZQSno4PZFEX5CcMM8kkOGt0RggyRF2IoUn/Cd60ZKUuwN20u
BT69bYo8JKGY0iQakw9Gbk+BkgTvaxd8KAz9vJpltdG3wcfQhuvHJO1k6jaXU+5Y
5ASkammQLamVwZ2Y3qFjxs+LhlEifQ9W2mv5UvLueQdlY3sgzM4A1fcGvsd2FJmA
8NeF/GAKWWQDDvwNHr1PFh7X1S3c1nOHLk8xDqb/naxnbJBW43LwF7Jutjlip7pd
D1fDyGkT5P9ZhgxOAOg6dedXOuWmXxZbvqgkiQ5VL91tYAUNsaSHgmkDwV5KPiaK
9xU9DfS3UAHkvXHSvBRgStrn/ZhFscLSLzX4CijxtR0UNSPazuXpMftsk6PIz8br
O4wifj8qF0FHP6gqLKuf/di2u7EnqUMY61QNMGNqzE4pjRnr4/HUzdazm1f5icsu
t0W6jS90Vahc45AOf6cmOr9fpv6slCRRHcwS88kDCmdjOSkECwXZ6AGvP6MeBof9
2sS/8XrM2lP91ekE2SK/L/cLQyfDKqBImhJdqORzz5McknYLqNv3OCkqpCM1qEUg
/XOYF5hkLYi/yTn/SM5B6OULM/NcrQgsIWUJ241IAH8xTxb3kizaqkD+MG4q17p6
5pIVHnavy2JnjRRFlbP+
=hVC8
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Oct_2011_17_30_19_+1100_RwSsvp=ToqC4mCP0--
