Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2FMHdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:33:53 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49048 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924Ab2FMHdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:33:50 -0400
MIME-Version: 1.0
Date: Wed, 13 Jun 2012 15:33:48 +0800
Message-ID: <CAH3Oq6Sua5vmOioOQHZd6BYRvVGfeTrNCgCHpyhZAv2_HhhcZg@mail.gmail.com>
Subject: Deprecate suspend/resume in device_driver
From: Ning Jiang <ning.n.jiang@gmail.com>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8f22c72ba48a9204c2559a29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f22c72ba48a9204c2559a29
Content-Type: text/plain; charset=ISO-8859-1

The suspend/resume will not be called if they are defined in
device_driver directly,
PM core will only use suspend/resume function in dev_pm_ops. Thus we shall
mark the old suspend/resume deprecated and make them scheduled for removal.


>From efee1b349a8abcb4702d93c1c12e7f27c96fbcfc Mon Sep 17 00:00:00 2001
From: Ning Jiang <ning.n.jiang@gmail.com>
Date: Wed, 13 Jun 2012 15:00:33 +0800
Subject: [PATCH] PM: Deprecate suspend/resume in device_driver

Make suspend/resume callbacks in device_driver deprecated and scheduled
for removal since they are not used in PM core anymore.

Legacy drivers who still use them need to move suspend/resume callbacks
to dev_pm_ops.

Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
---
 include/linux/device.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index e04f577..884d9a6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -226,8 +226,8 @@ struct device_driver {
 	int (*probe) (struct device *dev);
 	int (*remove) (struct device *dev);
 	void (*shutdown) (struct device *dev);
-	int (*suspend) (struct device *dev, pm_message_t state);
-	int (*resume) (struct device *dev);
+	int (*suspend) (struct device *dev, pm_message_t state) __deprecated;
+	int (*resume) (struct device *dev) __deprecated;
 	const struct attribute_group **groups;

 	const struct dev_pm_ops *pm;
-- 
1.7.1

--e89a8f22c72ba48a9204c2559a29
Content-Type: application/octet-stream; 
	name="0001-PM-Deprecate-suspend-resume-in-device_driver.patch"
Content-Disposition: attachment; 
	filename="0001-PM-Deprecate-suspend-resume-in-device_driver.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h3e2s9yh1

RnJvbSBlZmVlMWIzNDlhOGFiY2I0NzAyZDkzYzFjMTJlN2YyN2M5NmZiY2ZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaW5nIEppYW5nIDxuaW5nLm4uamlhbmdAZ21haWwuY29tPgpE
YXRlOiBXZWQsIDEzIEp1biAyMDEyIDE1OjAwOjMzICswODAwClN1YmplY3Q6IFtQQVRDSF0gUE06
IERlcHJlY2F0ZSBzdXNwZW5kL3Jlc3VtZSBpbiBkZXZpY2VfZHJpdmVyCgpNYWtlIHN1c3BlbmQv
cmVzdW1lIGNhbGxiYWNrcyBpbiBkZXZpY2VfZHJpdmVyIGRlcHJlY2F0ZWQgYW5kIHNjaGVkdWxl
ZApmb3IgcmVtb3ZhbCBzaW5jZSB0aGV5IGFyZSBub3QgdXNlZCBpbiBQTSBjb3JlIGFueW1vcmUu
CgpMZWdhY3kgZHJpdmVycyB3aG8gc3RpbGwgdXNlIHRoZW0gbmVlZCB0byBtb3ZlIHN1c3BlbmQv
cmVzdW1lIGNhbGxiYWNrcwp0byBkZXZfcG1fb3BzLgoKU2lnbmVkLW9mZi1ieTogTmluZyBKaWFu
ZyA8bmluZy5uLmppYW5nQGdtYWlsLmNvbT4KLS0tCiBpbmNsdWRlL2xpbnV4L2RldmljZS5oIHwg
ICAgNCArKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2RldmljZS5oIGIvaW5jbHVkZS9saW51eC9k
ZXZpY2UuaAppbmRleCBlMDRmNTc3Li44ODRkOWE2IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4
L2RldmljZS5oCisrKyBiL2luY2x1ZGUvbGludXgvZGV2aWNlLmgKQEAgLTIyNiw4ICsyMjYsOCBA
QCBzdHJ1Y3QgZGV2aWNlX2RyaXZlciB7CiAJaW50ICgqcHJvYmUpIChzdHJ1Y3QgZGV2aWNlICpk
ZXYpOwogCWludCAoKnJlbW92ZSkgKHN0cnVjdCBkZXZpY2UgKmRldik7CiAJdm9pZCAoKnNodXRk
b3duKSAoc3RydWN0IGRldmljZSAqZGV2KTsKLQlpbnQgKCpzdXNwZW5kKSAoc3RydWN0IGRldmlj
ZSAqZGV2LCBwbV9tZXNzYWdlX3Qgc3RhdGUpOwotCWludCAoKnJlc3VtZSkgKHN0cnVjdCBkZXZp
Y2UgKmRldik7CisJaW50ICgqc3VzcGVuZCkgKHN0cnVjdCBkZXZpY2UgKmRldiwgcG1fbWVzc2Fn
ZV90IHN0YXRlKSBfX2RlcHJlY2F0ZWQ7CisJaW50ICgqcmVzdW1lKSAoc3RydWN0IGRldmljZSAq
ZGV2KSBfX2RlcHJlY2F0ZWQ7CiAJY29uc3Qgc3RydWN0IGF0dHJpYnV0ZV9ncm91cCAqKmdyb3Vw
czsKIAogCWNvbnN0IHN0cnVjdCBkZXZfcG1fb3BzICpwbTsKLS0gCjEuNy4xCgo=
--e89a8f22c72ba48a9204c2559a29--
