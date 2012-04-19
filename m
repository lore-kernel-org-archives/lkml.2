Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab2DSNaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:30:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:23784 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378Ab2DSNaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:30:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="132876978"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] Register native mce handler as vMCE bounce back point
Thread-Topic: [PATCH 2/3] Register native mce handler as vMCE bounce back
 point
Thread-Index: Ac0eMI9iD+oSW/jqQkm/LrvBmMmVbg==
Date: Thu, 19 Apr 2012 13:30:17 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335154F12@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335154F12SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335154F12SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 8534a7b3fbd85410b35f0de26d09a48639a093a9 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 20 Apr 2012 05:09:55 +0800
Subject: [PATCH 2/3] Register native mce handler as vMCE bounce back point

When xen hypervisor inject vMCE to guest, use native mce handler to handle =
it

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Ke, Liping <liping.ke@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 15628d4..346ba64 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -614,8 +614,8 @@ static int cvt_gate_to_trap(int vector, const gate_desc=
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
@@ -630,7 +630,11 @@ static int cvt_gate_to_trap(int vector, const gate_des=
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

--_002_DE8DF0795D48FD4CA783C40EC8292335154F12SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-Register-native-mce-handler-as-vMCE-bounce-back-poin.patch"
Content-Description: 0002-Register-native-mce-handler-as-vMCE-bounce-back-poin.patch
Content-Disposition: attachment;
	filename="0002-Register-native-mce-handler-as-vMCE-bounce-back-poin.patch";
	size=1663; creation-date="Thu, 19 Apr 2012 13:21:53 GMT";
	modification-date="Thu, 19 Apr 2012 21:16:56 GMT"
Content-Transfer-Encoding: base64

RnJvbSA4NTM0YTdiM2ZiZDg1NDEwYjM1ZjBkZTI2ZDA5YTQ4NjM5YTA5M2E5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAyMCBBcHIgMjAxMiAwNTowOTo1NSArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMi8z
XSBSZWdpc3RlciBuYXRpdmUgbWNlIGhhbmRsZXIgYXMgdk1DRSBib3VuY2UgYmFjayBwb2ludAoK
V2hlbiB4ZW4gaHlwZXJ2aXNvciBpbmplY3Qgdk1DRSB0byBndWVzdCwgdXNlIG5hdGl2ZSBtY2Ug
aGFuZGxlciB0byBoYW5kbGUgaXQKClNpZ25lZC1vZmYtYnk6IExpdSwgSmluc29uZyA8amluc29u
Zy5saXVAaW50ZWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBLZSwgTGlwaW5nIDxsaXBpbmcua2VAaW50
ZWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBKaWFuZywgWXVuaG9uZyA8eXVuaG9uZy5qaWFuZ0BpbnRl
bC5jb20+ClNpZ25lZC1vZmYtYnk6IEplcmVteSBGaXR6aGFyZGluZ2UgPGplcmVteS5maXR6aGFy
ZGluZ2VAY2l0cml4LmNvbT4KLS0tCiBhcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMgfCAgIDEwICsr
KysrKystLS0KIDEgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYyBiL2FyY2gveDg2L3hlbi9l
bmxpZ2h0ZW4uYwppbmRleCAxNTYyOGQ0Li4zNDZiYTY0IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni94
ZW4vZW5saWdodGVuLmMKKysrIGIvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jCkBAIC02MTQsOCAr
NjE0LDggQEAgc3RhdGljIGludCBjdnRfZ2F0ZV90b190cmFwKGludCB2ZWN0b3IsIGNvbnN0IGdh
dGVfZGVzYyAqdmFsLAogCS8qCiAJICogTG9vayBmb3Iga25vd24gdHJhcHMgdXNpbmcgSVNULCBh
bmQgc3Vic3RpdHV0ZSB0aGVtCiAJICogYXBwcm9wcmlhdGVseS4gIFRoZSBkZWJ1Z2dlciBvbmVz
IGFyZSB0aGUgb25seSBvbmVzIHdlIGNhcmUKLQkgKiBhYm91dC4gIFhlbiB3aWxsIGhhbmRsZSBm
YXVsdHMgbGlrZSBkb3VibGVfZmF1bHQgYW5kCi0JICogbWFjaGluZV9jaGVjaywgc28gd2Ugc2hv
dWxkIG5ldmVyIHNlZSB0aGVtLiAgV2FybiBpZgorCSAqIGFib3V0LiAgWGVuIHdpbGwgaGFuZGxl
IGZhdWx0cyBsaWtlIGRvdWJsZV9mYXVsdCwKKwkgKiBzbyB3ZSBzaG91bGQgbmV2ZXIgc2VlIHRo
ZW0uICBXYXJuIGlmCiAJICogdGhlcmUncyBhbiB1bmV4cGVjdGVkIElTVC11c2luZyBmYXVsdCBo
YW5kbGVyLgogCSAqLwogCWlmIChhZGRyID09ICh1bnNpZ25lZCBsb25nKWRlYnVnKQpAQCAtNjMw
LDcgKzYzMCwxMSBAQCBzdGF0aWMgaW50IGN2dF9nYXRlX3RvX3RyYXAoaW50IHZlY3RvciwgY29u
c3QgZ2F0ZV9kZXNjICp2YWwsCiAJCXJldHVybiAwOwogI2lmZGVmIENPTkZJR19YODZfTUNFCiAJ
fSBlbHNlIGlmIChhZGRyID09ICh1bnNpZ25lZCBsb25nKW1hY2hpbmVfY2hlY2spIHsKLQkJcmV0
dXJuIDA7CisJCS8qCisJCSAqIHdoZW4geGVuIGh5ZXBydmlzb3IgaW5qZWN0IHZNQ0UgdG8gZ3Vl
c3QsCisJCSAqIHVzZSBuYXRpdmUgbWNlIGhhbmRsZXIgdG8gaGFuZGxlIGl0CisJCSAqLworCQk7
CiAjZW5kaWYKIAl9IGVsc2UgewogCQkvKiBTb21lIG90aGVyIHRyYXAgdXNpbmcgSVNUPyAqLwot
LSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC8292335154F12SHSMSX101ccrcorpi_--
