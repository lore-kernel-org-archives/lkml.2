Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab0HBRAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:00:37 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:36416 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab0HBRAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:00:36 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/1] staging: hv: Fix missing functions for net_device_ops
Thread-Topic: [PATCH 1/1] staging: hv: Fix missing functions for
 net_device_ops
Thread-Index: AQHLMmQ5BGry+QOh3EmRF27A66ZhHg==
Date: Mon, 2 Aug 2010 17:00:33 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7280E8547C@TK5EX14MBXC121.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: multipart/mixed;
	boundary="_002_1FB5E1D5CA062146B38059374562DF7280E8547CTK5EX14MBXC121r_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_1FB5E1D5CA062146B38059374562DF7280E8547CTK5EX14MBXC121r_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Haiyang Zhang <haiyangz@microsoft.com>

Subject: staging: hv: Fix missing functions for net_device_ops
  Unlike in older kernels, ether_setup() no longer sets default
functions. We need to put them into net_device_ops. For example,
eth_change_mtu prevents setting MTU beyond 1500. This is necessary
because we don't support jumbo frame at this time.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/netvsc_drv.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_dr=
v.c
index 56e1157..64a0114 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -327,6 +327,9 @@ static const struct net_device_ops device_ops =3D {
 	.ndo_stop =3D			netvsc_close,
 	.ndo_start_xmit =3D		netvsc_start_xmit,
 	.ndo_set_multicast_list =3D	netvsc_set_multicast_list,
+	.ndo_change_mtu =3D		eth_change_mtu,
+	.ndo_validate_addr =3D		eth_validate_addr,
+	.ndo_set_mac_address =3D		eth_mac_addr,
 };
=20
 static int netvsc_probe(struct device *device)
--=20
1.6.3.2


--_002_1FB5E1D5CA062146B38059374562DF7280E8547CTK5EX14MBXC121r_
Content-Type: application/octet-stream;
	name="0729-fix-missing-functions-for-net_device_ops.patch"
Content-Description: 0729-fix-missing-functions-for-net_device_ops.patch
Content-Disposition: attachment;
	filename="0729-fix-missing-functions-for-net_device_ops.patch"; size=1131;
	creation-date="Thu, 29 Jul 2010 21:11:11 GMT";
	modification-date="Thu, 29 Jul 2010 22:05:04 GMT"
Content-Transfer-Encoding: base64

RnJvbTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4KClN1YmplY3Q6IHN0
YWdpbmc6IGh2OiBGaXggbWlzc2luZyBmdW5jdGlvbnMgZm9yIG5ldF9kZXZpY2Vfb3BzCiAgVW5s
aWtlIGluIG9sZGVyIGtlcm5lbHMsIGV0aGVyX3NldHVwKCkgbm8gbG9uZ2VyIHNldHMgZGVmYXVs
dApmdW5jdGlvbnMuIFdlIG5lZWQgdG8gcHV0IHRoZW0gaW50byBuZXRfZGV2aWNlX29wcy4gRm9y
IGV4YW1wbGUsCmV0aF9jaGFuZ2VfbXR1IHByZXZlbnRzIHNldHRpbmcgTVRVIGJleW9uZCAxNTAw
LiBUaGlzIGlzIG5lY2Vzc2FyeQpiZWNhdXNlIHdlIGRvbid0IHN1cHBvcnQganVtYm8gZnJhbWUg
YXQgdGhpcyB0aW1lLgoKU2lnbmVkLW9mZi1ieTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWlj
cm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTogSGFuayBKYW5zc2VuIDxoamFuc3NlbkBtaWNyb3Nv
ZnQuY29tPgoKLS0tCiBkcml2ZXJzL3N0YWdpbmcvaHYvbmV0dnNjX2Rydi5jIHwgICAgMyArKysK
IDEgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9odi9uZXR2c2NfZHJ2LmMgYi9kcml2ZXJzL3N0YWdpbmcv
aHYvbmV0dnNjX2Rydi5jCmluZGV4IDU2ZTExNTcuLjY0YTAxMTQgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvc3RhZ2luZy9odi9uZXR2c2NfZHJ2LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL2h2L25ldHZz
Y19kcnYuYwpAQCAtMzI3LDYgKzMyNyw5IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbmV0X2Rldmlj
ZV9vcHMgZGV2aWNlX29wcyA9IHsKIAkubmRvX3N0b3AgPQkJCW5ldHZzY19jbG9zZSwKIAkubmRv
X3N0YXJ0X3htaXQgPQkJbmV0dnNjX3N0YXJ0X3htaXQsCiAJLm5kb19zZXRfbXVsdGljYXN0X2xp
c3QgPQluZXR2c2Nfc2V0X211bHRpY2FzdF9saXN0LAorCS5uZG9fY2hhbmdlX210dSA9CQlldGhf
Y2hhbmdlX210dSwKKwkubmRvX3ZhbGlkYXRlX2FkZHIgPQkJZXRoX3ZhbGlkYXRlX2FkZHIsCisJ
Lm5kb19zZXRfbWFjX2FkZHJlc3MgPQkJZXRoX21hY19hZGRyLAogfTsKIAogc3RhdGljIGludCBu
ZXR2c2NfcHJvYmUoc3RydWN0IGRldmljZSAqZGV2aWNlKQotLSAKMS42LjMuMgoK

--_002_1FB5E1D5CA062146B38059374562DF7280E8547CTK5EX14MBXC121r_--
