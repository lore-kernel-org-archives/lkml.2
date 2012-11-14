Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161186Ab2KNLrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:47:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:47533 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161139Ab2KNLrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:47:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,250,1352102400"; 
   d="scan'208,223";a="219454660"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "Brown, Len" <len.brown@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] X86/acpi: remove redundant logic of acpi memory hotadd
Thread-Topic: [PATCH] X86/acpi: remove redundant logic of acpi memory hotadd
Thread-Index: Ac3CXcl8ew8WST3yRku0w23f1yFzHg==
Date: Wed, 14 Nov 2012 11:47:13 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233538235A@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233538235ASHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233538235ASHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 1d39279e45c54ce531691da5ffe261e7689dd92c Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Wed, 14 Nov 2012 18:52:06 +0800
Subject: [PATCH] X86/acpi: remove redundant logic of acpi memory hotadd

When memory hotadd, acpi_memory_enable_device has already been done
at drv->ops.add (acpi_memory_device_add), no need to do it again
at notify callback.

At acpi_memory_enable_device, acpi_memory_get_device_resources
is also a redundant action, since it has been done at drv->ops.add.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/acpi/acpi_memhotplug.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.=
c
index 24c807f..a6489fd 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -220,15 +220,6 @@ static int acpi_memory_enable_device(struct acpi_memor=
y_device *mem_device)
 	struct acpi_memory_info *info;
 	int node;
=20
-
-	/* Get the range from the _CRS */
-	result =3D acpi_memory_get_device_resources(mem_device);
-	if (result) {
-		printk(KERN_ERR PREFIX "get_device_resources failed\n");
-		mem_device->state =3D MEMORY_INVALID_STATE;
-		return result;
-	}
-
 	node =3D acpi_get_node(mem_device->device->handle);
 	/*
 	 * Tell the VM there is more memory here...
@@ -357,14 +348,6 @@ static void acpi_memory_device_notify(acpi_handle hand=
le, u32 event, void *data)
 			break;
 		}
=20
-		if (acpi_memory_check_device(mem_device))
-			break;
-
-		if (acpi_memory_enable_device(mem_device)) {
-			printk(KERN_ERR PREFIX "Cannot enable memory device\n");
-			break;
-		}
-
 		ost_code =3D ACPI_OST_SC_SUCCESS;
 		break;
=20
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC829233538235ASHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-X86-acpi-remove-redundant-logic-of-acpi-memory-hotad.patch"
Content-Description: 0001-X86-acpi-remove-redundant-logic-of-acpi-memory-hotad.patch
Content-Disposition: attachment;
	filename="0001-X86-acpi-remove-redundant-logic-of-acpi-memory-hotad.patch";
	size=1705; creation-date="Wed, 14 Nov 2012 11:37:22 GMT";
	modification-date="Wed, 14 Nov 2012 10:53:00 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxZDM5Mjc5ZTQ1YzU0Y2U1MzE2OTFkYTVmZmUyNjFlNzY4OWRkOTJjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBXZWQsIDE0IE5vdiAyMDEyIDE4OjUyOjA2ICswODAwClN1YmplY3Q6IFtQQVRDSF0gWDg2
L2FjcGk6IHJlbW92ZSByZWR1bmRhbnQgbG9naWMgb2YgYWNwaSBtZW1vcnkgaG90YWRkCgpXaGVu
IG1lbW9yeSBob3RhZGQsIGFjcGlfbWVtb3J5X2VuYWJsZV9kZXZpY2UgaGFzIGFscmVhZHkgYmVl
biBkb25lCmF0IGRydi0+b3BzLmFkZCAoYWNwaV9tZW1vcnlfZGV2aWNlX2FkZCksIG5vIG5lZWQg
dG8gZG8gaXQgYWdhaW4KYXQgbm90aWZ5IGNhbGxiYWNrLgoKQXQgYWNwaV9tZW1vcnlfZW5hYmxl
X2RldmljZSwgYWNwaV9tZW1vcnlfZ2V0X2RldmljZV9yZXNvdXJjZXMKaXMgYWxzbyBhIHJlZHVu
ZGFudCBhY3Rpb24sIHNpbmNlIGl0IGhhcyBiZWVuIGRvbmUgYXQgZHJ2LT5vcHMuYWRkLgoKU2ln
bmVkLW9mZi1ieTogTGl1IEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KLS0tCiBkcml2
ZXJzL2FjcGkvYWNwaV9tZW1ob3RwbHVnLmMgfCAgIDE3IC0tLS0tLS0tLS0tLS0tLS0tCiAxIGZp
bGVzIGNoYW5nZWQsIDAgaW5zZXJ0aW9ucygrKSwgMTcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9hY3BpL2FjcGlfbWVtaG90cGx1Zy5jIGIvZHJpdmVycy9hY3BpL2FjcGlfbWVt
aG90cGx1Zy5jCmluZGV4IDI0YzgwN2YuLmE2NDg5ZmQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYWNw
aS9hY3BpX21lbWhvdHBsdWcuYworKysgYi9kcml2ZXJzL2FjcGkvYWNwaV9tZW1ob3RwbHVnLmMK
QEAgLTIyMCwxNSArMjIwLDYgQEAgc3RhdGljIGludCBhY3BpX21lbW9yeV9lbmFibGVfZGV2aWNl
KHN0cnVjdCBhY3BpX21lbW9yeV9kZXZpY2UgKm1lbV9kZXZpY2UpCiAJc3RydWN0IGFjcGlfbWVt
b3J5X2luZm8gKmluZm87CiAJaW50IG5vZGU7CiAKLQotCS8qIEdldCB0aGUgcmFuZ2UgZnJvbSB0
aGUgX0NSUyAqLwotCXJlc3VsdCA9IGFjcGlfbWVtb3J5X2dldF9kZXZpY2VfcmVzb3VyY2VzKG1l
bV9kZXZpY2UpOwotCWlmIChyZXN1bHQpIHsKLQkJcHJpbnRrKEtFUk5fRVJSIFBSRUZJWCAiZ2V0
X2RldmljZV9yZXNvdXJjZXMgZmFpbGVkXG4iKTsKLQkJbWVtX2RldmljZS0+c3RhdGUgPSBNRU1P
UllfSU5WQUxJRF9TVEFURTsKLQkJcmV0dXJuIHJlc3VsdDsKLQl9Ci0KIAlub2RlID0gYWNwaV9n
ZXRfbm9kZShtZW1fZGV2aWNlLT5kZXZpY2UtPmhhbmRsZSk7CiAJLyoKIAkgKiBUZWxsIHRoZSBW
TSB0aGVyZSBpcyBtb3JlIG1lbW9yeSBoZXJlLi4uCkBAIC0zNTcsMTQgKzM0OCw2IEBAIHN0YXRp
YyB2b2lkIGFjcGlfbWVtb3J5X2RldmljZV9ub3RpZnkoYWNwaV9oYW5kbGUgaGFuZGxlLCB1MzIg
ZXZlbnQsIHZvaWQgKmRhdGEpCiAJCQlicmVhazsKIAkJfQogCi0JCWlmIChhY3BpX21lbW9yeV9j
aGVja19kZXZpY2UobWVtX2RldmljZSkpCi0JCQlicmVhazsKLQotCQlpZiAoYWNwaV9tZW1vcnlf
ZW5hYmxlX2RldmljZShtZW1fZGV2aWNlKSkgewotCQkJcHJpbnRrKEtFUk5fRVJSIFBSRUZJWCAi
Q2Fubm90IGVuYWJsZSBtZW1vcnkgZGV2aWNlXG4iKTsKLQkJCWJyZWFrOwotCQl9Ci0KIAkJb3N0
X2NvZGUgPSBBQ1BJX09TVF9TQ19TVUNDRVNTOwogCQlicmVhazsKIAotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC829233538235ASHSMSX101ccrcorpi_--
