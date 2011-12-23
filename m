Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab1LWKgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:36:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:50821 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab1LWKgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:36:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="99640813"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
CC: "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "Brown, Len" <len.brown@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/10] xen/acpi: Move acpi_memory_info definition to public
Thread-Topic: [PATCH 05/10] xen/acpi: Move acpi_memory_info definition to
 public
Thread-Index: AczBXrpnWJj7owNBS3CwTrfqrXT0pA==
Date: Fri, 23 Dec 2011 10:36:28 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233597AA@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233597AASHSMSX101ccrcorpint_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233597AASHSMSX101ccrcorpint_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 0172b1ce6a2ba70e739f968622d78ac1796813f9 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Sun, 11 Dec 2011 17:25:35 +0800
Subject: [PATCH 05/10] xen/acpi: Move acpi_memory_info definition to public

This patch rebased from Jeremy's pvops commit
359e747e6260f105f750657917e1dc75f6427602

Move this definition to header file so that it can be used by dom0
memory hotadd logic also.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/acpi/acpi_memhotplug.c |   15 ---------------
 include/acpi/acpi_drivers.h    |   21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.=
c
index d985713..e28e64d 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -71,21 +71,6 @@ static struct acpi_driver acpi_memory_device_driver =3D =
{
 		},
 };
=20
-struct acpi_memory_info {
-	struct list_head list;
-	u64 start_addr;		/* Memory Range start physical addr */
-	u64 length;		/* Memory Range length */
-	unsigned short caching;	/* memory cache attribute */
-	unsigned short write_protect;	/* memory read/write attribute */
-	unsigned int enabled:1;
-};
-
-struct acpi_memory_device {
-	struct acpi_device * device;
-	unsigned int state;	/* State of the memory device */
-	struct list_head res_list;
-};
-
 static int acpi_hotmem_initialized;
=20
 static acpi_status
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index e49c36d..833de75 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -154,4 +154,25 @@ static inline void unregister_hotplug_dock_device(acpi=
_handle handle)
 }
 #endif
=20
+/*------------------------------------------------------------------------=
--
+                                Memory
+  ------------------------------------------------------------------------=
-- */
+#if defined(CONFIG_ACPI_HOTPLUG_MEMORY) || \
+        defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
+struct acpi_memory_info {
+        struct list_head list;
+        u64 start_addr;         /* Memory Range start physical addr */
+        u64 length;             /* Memory Range length */
+        unsigned short caching; /* memory cache attribute */
+        unsigned short write_protect;   /* memory read/write attribute */
+        unsigned int enabled:1;
+};
+
+struct acpi_memory_device {
+        struct acpi_device *device;
+        unsigned int state;     /* State of the memory device */
+        struct list_head res_list;
+};
+#endif
+
 #endif /*__ACPI_DRIVERS_H__*/
--=20
1.6.5.6

--_002_DE8DF0795D48FD4CA783C40EC829233597AASHSMSX101ccrcorpint_
Content-Type: application/octet-stream;
	name="0005-xen-acpi-Move-acpi_memory_info-definition-to-public.patch"
Content-Description: 0005-xen-acpi-Move-acpi_memory_info-definition-to-public.patch
Content-Disposition: attachment;
	filename="0005-xen-acpi-Move-acpi_memory_info-definition-to-public.patch";
	size=2702; creation-date="Wed, 14 Dec 2011 15:20:15 GMT";
	modification-date="Wed, 14 Dec 2011 15:03:34 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwMTcyYjFjZTZhMmJhNzBlNzM5Zjk2ODYyMmQ3OGFjMTc5NjgxM2Y5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBTdW4sIDExIERlYyAyMDExIDE3OjI1OjM1ICswODAwClN1YmplY3Q6IFtQQVRDSCAwNS8x
MF0geGVuL2FjcGk6IE1vdmUgYWNwaV9tZW1vcnlfaW5mbyBkZWZpbml0aW9uIHRvIHB1YmxpYwoK
VGhpcyBwYXRjaCByZWJhc2VkIGZyb20gSmVyZW15J3MgcHZvcHMgY29tbWl0CjM1OWU3NDdlNjI2
MGYxMDVmNzUwNjU3OTE3ZTFkYzc1ZjY0Mjc2MDIKCk1vdmUgdGhpcyBkZWZpbml0aW9uIHRvIGhl
YWRlciBmaWxlIHNvIHRoYXQgaXQgY2FuIGJlIHVzZWQgYnkgZG9tMAptZW1vcnkgaG90YWRkIGxv
Z2ljIGFsc28uCgpTaWduZWQtb2ZmLWJ5OiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVs
LmNvbT4KU2lnbmVkLW9mZi1ieTogSmlhbmcsIFl1bmhvbmcgPHl1bmhvbmcuamlhbmdAaW50ZWwu
Y29tPgpTaWduZWQtb2ZmLWJ5OiBKZXJlbXkgRml0emhhcmRpbmdlIDxqZXJlbXkuZml0emhhcmRp
bmdlQGNpdHJpeC5jb20+Ci0tLQogZHJpdmVycy9hY3BpL2FjcGlfbWVtaG90cGx1Zy5jIHwgICAx
NSAtLS0tLS0tLS0tLS0tLS0KIGluY2x1ZGUvYWNwaS9hY3BpX2RyaXZlcnMuaCAgICB8ICAgMjEg
KysrKysrKysrKysrKysrKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyks
IDE1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9hY3BpX21lbWhvdHBs
dWcuYyBiL2RyaXZlcnMvYWNwaS9hY3BpX21lbWhvdHBsdWcuYwppbmRleCBkOTg1NzEzLi5lMjhl
NjRkIDEwMDY0NAotLS0gYS9kcml2ZXJzL2FjcGkvYWNwaV9tZW1ob3RwbHVnLmMKKysrIGIvZHJp
dmVycy9hY3BpL2FjcGlfbWVtaG90cGx1Zy5jCkBAIC03MSwyMSArNzEsNiBAQCBzdGF0aWMgc3Ry
dWN0IGFjcGlfZHJpdmVyIGFjcGlfbWVtb3J5X2RldmljZV9kcml2ZXIgPSB7CiAJCX0sCiB9Owog
Ci1zdHJ1Y3QgYWNwaV9tZW1vcnlfaW5mbyB7Ci0Jc3RydWN0IGxpc3RfaGVhZCBsaXN0OwotCXU2
NCBzdGFydF9hZGRyOwkJLyogTWVtb3J5IFJhbmdlIHN0YXJ0IHBoeXNpY2FsIGFkZHIgKi8KLQl1
NjQgbGVuZ3RoOwkJLyogTWVtb3J5IFJhbmdlIGxlbmd0aCAqLwotCXVuc2lnbmVkIHNob3J0IGNh
Y2hpbmc7CS8qIG1lbW9yeSBjYWNoZSBhdHRyaWJ1dGUgKi8KLQl1bnNpZ25lZCBzaG9ydCB3cml0
ZV9wcm90ZWN0OwkvKiBtZW1vcnkgcmVhZC93cml0ZSBhdHRyaWJ1dGUgKi8KLQl1bnNpZ25lZCBp
bnQgZW5hYmxlZDoxOwotfTsKLQotc3RydWN0IGFjcGlfbWVtb3J5X2RldmljZSB7Ci0Jc3RydWN0
IGFjcGlfZGV2aWNlICogZGV2aWNlOwotCXVuc2lnbmVkIGludCBzdGF0ZTsJLyogU3RhdGUgb2Yg
dGhlIG1lbW9yeSBkZXZpY2UgKi8KLQlzdHJ1Y3QgbGlzdF9oZWFkIHJlc19saXN0OwotfTsKLQog
c3RhdGljIGludCBhY3BpX2hvdG1lbV9pbml0aWFsaXplZDsKIAogc3RhdGljIGFjcGlfc3RhdHVz
CmRpZmYgLS1naXQgYS9pbmNsdWRlL2FjcGkvYWNwaV9kcml2ZXJzLmggYi9pbmNsdWRlL2FjcGkv
YWNwaV9kcml2ZXJzLmgKaW5kZXggZTQ5YzM2ZC4uODMzZGU3NSAxMDA2NDQKLS0tIGEvaW5jbHVk
ZS9hY3BpL2FjcGlfZHJpdmVycy5oCisrKyBiL2luY2x1ZGUvYWNwaS9hY3BpX2RyaXZlcnMuaApA
QCAtMTU0LDQgKzE1NCwyNSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgdW5yZWdpc3Rlcl9ob3RwbHVn
X2RvY2tfZGV2aWNlKGFjcGlfaGFuZGxlIGhhbmRsZSkKIH0KICNlbmRpZgogCisvKi0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIE1lbW9yeQorICAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLSAqLworI2lmIGRlZmluZWQoQ09ORklHX0FDUElfSE9UUExVR19NRU1PUlkp
IHx8IFwKKyAgICAgICAgZGVmaW5lZChDT05GSUdfQUNQSV9IT1RQTFVHX01FTU9SWV9NT0RVTEUp
CitzdHJ1Y3QgYWNwaV9tZW1vcnlfaW5mbyB7CisgICAgICAgIHN0cnVjdCBsaXN0X2hlYWQgbGlz
dDsKKyAgICAgICAgdTY0IHN0YXJ0X2FkZHI7ICAgICAgICAgLyogTWVtb3J5IFJhbmdlIHN0YXJ0
IHBoeXNpY2FsIGFkZHIgKi8KKyAgICAgICAgdTY0IGxlbmd0aDsgICAgICAgICAgICAgLyogTWVt
b3J5IFJhbmdlIGxlbmd0aCAqLworICAgICAgICB1bnNpZ25lZCBzaG9ydCBjYWNoaW5nOyAvKiBt
ZW1vcnkgY2FjaGUgYXR0cmlidXRlICovCisgICAgICAgIHVuc2lnbmVkIHNob3J0IHdyaXRlX3By
b3RlY3Q7ICAgLyogbWVtb3J5IHJlYWQvd3JpdGUgYXR0cmlidXRlICovCisgICAgICAgIHVuc2ln
bmVkIGludCBlbmFibGVkOjE7Cit9OworCitzdHJ1Y3QgYWNwaV9tZW1vcnlfZGV2aWNlIHsKKyAg
ICAgICAgc3RydWN0IGFjcGlfZGV2aWNlICpkZXZpY2U7CisgICAgICAgIHVuc2lnbmVkIGludCBz
dGF0ZTsgICAgIC8qIFN0YXRlIG9mIHRoZSBtZW1vcnkgZGV2aWNlICovCisgICAgICAgIHN0cnVj
dCBsaXN0X2hlYWQgcmVzX2xpc3Q7Cit9OworI2VuZGlmCisKICNlbmRpZiAvKl9fQUNQSV9EUklW
RVJTX0hfXyovCi0tIAoxLjYuNS42Cgo=

--_002_DE8DF0795D48FD4CA783C40EC829233597AASHSMSX101ccrcorpint_--
