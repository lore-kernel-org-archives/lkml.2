Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab2EaRdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:33:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:5447 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810Ab2EaRdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:33:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="106370358"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] Register native mce handler as vMCE bounce back point
Thread-Topic: [PATCH 3/3] Register native mce handler as vMCE bounce back
 point
Thread-Index: Ac0/U4oGOmcgMxj2Q7+f4qg6RfEkEg==
Date: Thu, 31 May 2012 17:33:49 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351FFB7C@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923351FFB7CSHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923351FFB7CSHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From ca1f8a2347eb34acdc7c54b805c78a982a0a590d Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 1 Jun 2012 08:41:00 +0800
Subject: [PATCH 3/3] Register native mce handler as vMCE bounce back point

When xen hypervisor inject vMCE to guest, use native mce handler to handle =
it

Signed-off-by: Ke, Liping <liping.ke@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 arch/x86/xen/enlighten.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index ff2d00e..0cb12dd 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -618,8 +618,8 @@ static int cvt_gate_to_trap(int vector, const gate_desc=
 *val,
 	/*
 	 * Look for known traps using IST, and substitute them
 	 * appropriately.  The debugger ones are the only ones we care
-	 * about.  Xen will handle faults like double_fault and
-	 * machine_check, so we should never see them.  Warn if
+	 * about.  Xen will handle faults like double_fault,
+	 * so we should never see them.  Warn if
 	 * there's an unexpected IST-using fault handler.
 	 */
 	if (addr =3D=3D (unsigned long)debug)
@@ -634,7 +634,11 @@ static int cvt_gate_to_trap(int vector, const gate_des=
c *val,
 		return 0;
 #ifdef CONFIG_X86_MCE
 	} else if (addr =3D=3D (unsigned long)machine_check) {
-		return 0;
+		/*
+		 * when xen hyeprvisor inject vMCE to guest,
+		 * use native mce handler to handle it
+		 */
+		;
 #endif
 	} else {
 		/* Some other trap using IST? */
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923351FFB7CSHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0003-Register-native-mce-handler-as-vMCE-bounce-back-poin.patch"
Content-Description: 0003-Register-native-mce-handler-as-vMCE-bounce-back-poin.patch
Content-Disposition: attachment;
	filename="0003-Register-native-mce-handler-as-vMCE-bounce-back-poin.patch";
	size=1662; creation-date="Thu, 31 May 2012 17:10:05 GMT";
	modification-date="Fri, 01 Jun 2012 00:43:22 GMT"
Content-Transfer-Encoding: base64

RnJvbSBjYTFmOGEyMzQ3ZWIzNGFjZGM3YzU0YjgwNWM3OGE5ODJhMGE1OTBkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAxIEp1biAyMDEyIDA4OjQxOjAwICswODAwClN1YmplY3Q6IFtQQVRDSCAzLzNd
IFJlZ2lzdGVyIG5hdGl2ZSBtY2UgaGFuZGxlciBhcyB2TUNFIGJvdW5jZSBiYWNrIHBvaW50CgpX
aGVuIHhlbiBoeXBlcnZpc29yIGluamVjdCB2TUNFIHRvIGd1ZXN0LCB1c2UgbmF0aXZlIG1jZSBo
YW5kbGVyIHRvIGhhbmRsZSBpdAoKU2lnbmVkLW9mZi1ieTogS2UsIExpcGluZyA8bGlwaW5nLmtl
QGludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTogSmlhbmcsIFl1bmhvbmcgPHl1bmhvbmcuamlhbmdA
aW50ZWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBKZXJlbXkgRml0emhhcmRpbmdlIDxqZXJlbXkuZml0
emhhcmRpbmdlQGNpdHJpeC5jb20+ClNpZ25lZC1vZmYtYnk6IExpdSwgSmluc29uZyA8amluc29u
Zy5saXVAaW50ZWwuY29tPgotLS0KIGFyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYyB8ICAgMTAgKysr
KysrKy0tLQogMSBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jIGIvYXJjaC94ODYveGVuL2Vu
bGlnaHRlbi5jCmluZGV4IGZmMmQwMGUuLjBjYjEyZGQgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L3hl
bi9lbmxpZ2h0ZW4uYworKysgYi9hcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMKQEAgLTYxOCw4ICs2
MTgsOCBAQCBzdGF0aWMgaW50IGN2dF9nYXRlX3RvX3RyYXAoaW50IHZlY3RvciwgY29uc3QgZ2F0
ZV9kZXNjICp2YWwsCiAJLyoKIAkgKiBMb29rIGZvciBrbm93biB0cmFwcyB1c2luZyBJU1QsIGFu
ZCBzdWJzdGl0dXRlIHRoZW0KIAkgKiBhcHByb3ByaWF0ZWx5LiAgVGhlIGRlYnVnZ2VyIG9uZXMg
YXJlIHRoZSBvbmx5IG9uZXMgd2UgY2FyZQotCSAqIGFib3V0LiAgWGVuIHdpbGwgaGFuZGxlIGZh
dWx0cyBsaWtlIGRvdWJsZV9mYXVsdCBhbmQKLQkgKiBtYWNoaW5lX2NoZWNrLCBzbyB3ZSBzaG91
bGQgbmV2ZXIgc2VlIHRoZW0uICBXYXJuIGlmCisJICogYWJvdXQuICBYZW4gd2lsbCBoYW5kbGUg
ZmF1bHRzIGxpa2UgZG91YmxlX2ZhdWx0LAorCSAqIHNvIHdlIHNob3VsZCBuZXZlciBzZWUgdGhl
bS4gIFdhcm4gaWYKIAkgKiB0aGVyZSdzIGFuIHVuZXhwZWN0ZWQgSVNULXVzaW5nIGZhdWx0IGhh
bmRsZXIuCiAJICovCiAJaWYgKGFkZHIgPT0gKHVuc2lnbmVkIGxvbmcpZGVidWcpCkBAIC02MzQs
NyArNjM0LDExIEBAIHN0YXRpYyBpbnQgY3Z0X2dhdGVfdG9fdHJhcChpbnQgdmVjdG9yLCBjb25z
dCBnYXRlX2Rlc2MgKnZhbCwKIAkJcmV0dXJuIDA7CiAjaWZkZWYgQ09ORklHX1g4Nl9NQ0UKIAl9
IGVsc2UgaWYgKGFkZHIgPT0gKHVuc2lnbmVkIGxvbmcpbWFjaGluZV9jaGVjaykgewotCQlyZXR1
cm4gMDsKKwkJLyoKKwkJICogd2hlbiB4ZW4gaHllcHJ2aXNvciBpbmplY3Qgdk1DRSB0byBndWVz
dCwKKwkJICogdXNlIG5hdGl2ZSBtY2UgaGFuZGxlciB0byBoYW5kbGUgaXQKKwkJICovCisJCTsK
ICNlbmRpZgogCX0gZWxzZSB7CiAJCS8qIFNvbWUgb3RoZXIgdHJhcCB1c2luZyBJU1Q/ICovCi0t
IAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC82923351FFB7CSHSMSX101ccrcorpi_--
