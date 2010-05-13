Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab0EMP4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:56:37 -0400
Received: from smtp.microsoft.com ([131.107.115.212]:31360 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab0EMP4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:56:35 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "'gregkh@suse.de'" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/1]  staging: hv: Fix error checking in channel.c
Thread-Topic: [PATCH 1/1]  staging: hv: Fix error checking in channel.c
Thread-Index: AQHK8rTb7xJQcz4PvEuTd96eji4ISg==
Date: Thu, 13 May 2010 15:56:30 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF72662AB0C9@TK5EX14MBXC130.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Content-Type: multipart/mixed;
	boundary="_002_1FB5E1D5CA062146B38059374562DF72662AB0C9TK5EX14MBXC130r_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_1FB5E1D5CA062146B38059374562DF72662AB0C9TK5EX14MBXC130r_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Haiyang Zhang <haiyangz@microsoft.com>

Subject: staging: hv: Fix error checking in channel.c
Fixed errors in return value checking code, which caused vmbus channel
not functioning.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 12c351e..f047c5a 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -204,13 +204,13 @@ int VmbusChannelOpen(struct vmbus_channel *NewChannel=
, u32 SendRingBufferSize,
 					   RecvRingBufferSize) >> PAGE_SHIFT;
=20
 	ret =3D RingBufferInit(&NewChannel->Outbound, out, SendRingBufferSize);
-	if (!ret) {
+	if (ret !=3D 0) {
 		err =3D ret;
 		goto errorout;
 	}
=20
 	ret =3D RingBufferInit(&NewChannel->Inbound, in, RecvRingBufferSize);
-	if (!ret) {
+	if (ret !=3D 0) {
 		err =3D ret;
 		goto errorout;
 	}
@@ -228,7 +228,7 @@ int VmbusChannelOpen(struct vmbus_channel *NewChannel, =
u32 SendRingBufferSize,
 					 RecvRingBufferSize,
 					 &NewChannel->RingBufferGpadlHandle);
=20
-	if (!ret) {
+	if (ret !=3D 0) {
 		err =3D ret;
 		goto errorout;
 	}
@@ -569,7 +569,7 @@ int VmbusChannelEstablishGpadl(struct vmbus_channel *Ch=
annel, void *Kbuffer,
 			ret =3D VmbusPostMessage(gpadlBody,
 					       subMsgInfo->MessageSize -
 					       sizeof(*subMsgInfo));
-			if (!ret)
+			if (ret !=3D 0)
 				goto Cleanup;
=20
 		}
--=20
1.6.3.2


--_002_1FB5E1D5CA062146B38059374562DF72662AB0C9TK5EX14MBXC130r_
Content-Type: application/octet-stream;
	name="0513-Fix-error-checking-in-channel.c.patch"
Content-Description: 0513-Fix-error-checking-in-channel.c.patch
Content-Disposition: attachment;
	filename="0513-Fix-error-checking-in-channel.c.patch"; size=1558;
	creation-date="Thu, 13 May 2010 15:21:47 GMT";
	modification-date="Thu, 13 May 2010 16:05:23 GMT"
Content-Transfer-Encoding: base64

RnJvbTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4KClN1YmplY3Q6IHN0
YWdpbmc6IGh2OiBGaXggZXJyb3IgY2hlY2tpbmcgaW4gY2hhbm5lbC5jCkZpeGVkIGVycm9ycyBp
biByZXR1cm4gdmFsdWUgY2hlY2tpbmcgY29kZSwgd2hpY2ggY2F1c2VkIHZtYnVzIGNoYW5uZWwK
bm90IGZ1bmN0aW9uaW5nLgoKQ2M6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQHN1c2UuZGU+
ClNpZ25lZC1vZmYtYnk6IEhhaXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+ClNp
Z25lZC1vZmYtYnk6IEhhbmsgSmFuc3NlbiA8aGphbnNzZW5AbWljcm9zb2Z0LmNvbT4KCi0tLQog
ZHJpdmVycy9zdGFnaW5nL2h2L2NoYW5uZWwuYyB8ICAgIDggKysrKy0tLS0KIDEgZmlsZXMgY2hh
bmdlZCwgNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy9odi9jaGFubmVsLmMgYi9kcml2ZXJzL3N0YWdpbmcvaHYvY2hhbm5lbC5jCmlu
ZGV4IDEyYzM1MWUuLmYwNDdjNWEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy9odi9jaGFu
bmVsLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL2h2L2NoYW5uZWwuYwpAQCAtMjA0LDEzICsyMDQs
MTMgQEAgaW50IFZtYnVzQ2hhbm5lbE9wZW4oc3RydWN0IHZtYnVzX2NoYW5uZWwgKk5ld0NoYW5u
ZWwsIHUzMiBTZW5kUmluZ0J1ZmZlclNpemUsCiAJCQkJCSAgIFJlY3ZSaW5nQnVmZmVyU2l6ZSkg
Pj4gUEFHRV9TSElGVDsKIAogCXJldCA9IFJpbmdCdWZmZXJJbml0KCZOZXdDaGFubmVsLT5PdXRi
b3VuZCwgb3V0LCBTZW5kUmluZ0J1ZmZlclNpemUpOwotCWlmICghcmV0KSB7CisJaWYgKHJldCAh
PSAwKSB7CiAJCWVyciA9IHJldDsKIAkJZ290byBlcnJvcm91dDsKIAl9CiAKIAlyZXQgPSBSaW5n
QnVmZmVySW5pdCgmTmV3Q2hhbm5lbC0+SW5ib3VuZCwgaW4sIFJlY3ZSaW5nQnVmZmVyU2l6ZSk7
Ci0JaWYgKCFyZXQpIHsKKwlpZiAocmV0ICE9IDApIHsKIAkJZXJyID0gcmV0OwogCQlnb3RvIGVy
cm9yb3V0OwogCX0KQEAgLTIyOCw3ICsyMjgsNyBAQCBpbnQgVm1idXNDaGFubmVsT3BlbihzdHJ1
Y3Qgdm1idXNfY2hhbm5lbCAqTmV3Q2hhbm5lbCwgdTMyIFNlbmRSaW5nQnVmZmVyU2l6ZSwKIAkJ
CQkJIFJlY3ZSaW5nQnVmZmVyU2l6ZSwKIAkJCQkJICZOZXdDaGFubmVsLT5SaW5nQnVmZmVyR3Bh
ZGxIYW5kbGUpOwogCi0JaWYgKCFyZXQpIHsKKwlpZiAocmV0ICE9IDApIHsKIAkJZXJyID0gcmV0
OwogCQlnb3RvIGVycm9yb3V0OwogCX0KQEAgLTU2OSw3ICs1NjksNyBAQCBpbnQgVm1idXNDaGFu
bmVsRXN0YWJsaXNoR3BhZGwoc3RydWN0IHZtYnVzX2NoYW5uZWwgKkNoYW5uZWwsIHZvaWQgKkti
dWZmZXIsCiAJCQlyZXQgPSBWbWJ1c1Bvc3RNZXNzYWdlKGdwYWRsQm9keSwKIAkJCQkJICAgICAg
IHN1Yk1zZ0luZm8tPk1lc3NhZ2VTaXplIC0KIAkJCQkJICAgICAgIHNpemVvZigqc3ViTXNnSW5m
bykpOwotCQkJaWYgKCFyZXQpCisJCQlpZiAocmV0ICE9IDApCiAJCQkJZ290byBDbGVhbnVwOwog
CiAJCX0KLS0gCjEuNi4zLjIKCg==

--_002_1FB5E1D5CA062146B38059374562DF72662AB0C9TK5EX14MBXC130r_--
