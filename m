Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab1LWKYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:24:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:29381 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab1LWKYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:24:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="105418716"
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
Subject: [PATCH 02/10] xen/mce: Change the machine check point
Thread-Topic: [PATCH 02/10] xen/mce: Change the machine check point
Thread-Index: AczBXQ1WSSmFa5n6TGeCtQd8p4HSYg==
Date: Fri, 23 Dec 2011 10:24:29 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233596B7@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233596B7SHSMSX101ccrcorpint_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233596B7SHSMSX101ccrcorpint_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 80221e743d1a693670d701f383da26c8e5d5bf98 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Wed, 7 Dec 2011 05:26:16 +0800
Subject: [PATCH 02/10] xen/mce: Change the machine check point

This patch backport from Jeremy's pvops commit
073349667402682c997394b3fcdbbeb6707f368f

Enable MCE support in dom0, so that if a MCE happen and that MCE impact
dom0, dom0 can receive a vMCE.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Ke, Liping <liping.ke@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index b073e4c..13e7a16 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -526,7 +526,7 @@ static int cvt_gate_to_trap(int vector, const gate_desc=
 *val,
 	 * Look for known traps using IST, and substitute them
 	 * appropriately.  The debugger ones are the only ones we care
 	 * about.  Xen will handle faults like double_fault and
-	 * machine_check, so we should never see them.  Warn if
+	 * nmi, so we should never see them.  Warn if
 	 * there's an unexpected IST-using fault handler.
 	 */
 	if (addr =3D=3D (unsigned long)debug)
@@ -541,7 +541,10 @@ static int cvt_gate_to_trap(int vector, const gate_des=
c *val,
 		return 0;
 #ifdef CONFIG_X86_MCE
 	} else if (addr =3D=3D (unsigned long)machine_check) {
-		return 0;
+		if (xen_initial_domain())
+			addr =3D (unsigned long)machine_check;
+		else
+			return 0;
 #endif
 	} else {
 		/* Some other trap using IST? */
--=20
1.6.5.6

--_002_DE8DF0795D48FD4CA783C40EC829233596B7SHSMSX101ccrcorpint_
Content-Type: application/octet-stream;
	name="0002-xen-mce-Change-the-machine-check-point.patch"
Content-Description: 0002-xen-mce-Change-the-machine-check-point.patch
Content-Disposition: attachment;
	filename="0002-xen-mce-Change-the-machine-check-point.patch"; size=1691;
	creation-date="Wed, 14 Dec 2011 15:20:15 GMT";
	modification-date="Wed, 14 Dec 2011 15:03:34 GMT"
Content-Transfer-Encoding: base64

RnJvbSA4MDIyMWU3NDNkMWE2OTM2NzBkNzAxZjM4M2RhMjZjOGU1ZDViZjk4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBXZWQsIDcgRGVjIDIwMTEgMDU6MjY6MTYgKzA4MDAKU3ViamVjdDogW1BBVENIIDAyLzEw
XSB4ZW4vbWNlOiBDaGFuZ2UgdGhlIG1hY2hpbmUgY2hlY2sgcG9pbnQKClRoaXMgcGF0Y2ggYmFj
a3BvcnQgZnJvbSBKZXJlbXkncyBwdm9wcyBjb21taXQKMDczMzQ5NjY3NDAyNjgyYzk5NzM5NGIz
ZmNkYmJlYjY3MDdmMzY4ZgoKRW5hYmxlIE1DRSBzdXBwb3J0IGluIGRvbTAsIHNvIHRoYXQgaWYg
YSBNQ0UgaGFwcGVuIGFuZCB0aGF0IE1DRSBpbXBhY3QKZG9tMCwgZG9tMCBjYW4gcmVjZWl2ZSBh
IHZNQ0UuCgpTaWduZWQtb2ZmLWJ5OiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNv
bT4KU2lnbmVkLW9mZi1ieTogS2UsIExpcGluZyA8bGlwaW5nLmtlQGludGVsLmNvbT4KU2lnbmVk
LW9mZi1ieTogSmlhbmcsIFl1bmhvbmcgPHl1bmhvbmcuamlhbmdAaW50ZWwuY29tPgpTaWduZWQt
b2ZmLWJ5OiBKZXJlbXkgRml0emhhcmRpbmdlIDxqZXJlbXkuZml0emhhcmRpbmdlQGNpdHJpeC5j
b20+Ci0tLQogYXJjaC94ODYveGVuL2VubGlnaHRlbi5jIHwgICAgNyArKysrKy0tCiAxIGZpbGVz
IGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9h
cmNoL3g4Ni94ZW4vZW5saWdodGVuLmMgYi9hcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMKaW5kZXgg
YjA3M2U0Yy4uMTNlN2ExNiAxMDA2NDQKLS0tIGEvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jCisr
KyBiL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYwpAQCAtNTI2LDcgKzUyNiw3IEBAIHN0YXRpYyBp
bnQgY3Z0X2dhdGVfdG9fdHJhcChpbnQgdmVjdG9yLCBjb25zdCBnYXRlX2Rlc2MgKnZhbCwKIAkg
KiBMb29rIGZvciBrbm93biB0cmFwcyB1c2luZyBJU1QsIGFuZCBzdWJzdGl0dXRlIHRoZW0KIAkg
KiBhcHByb3ByaWF0ZWx5LiAgVGhlIGRlYnVnZ2VyIG9uZXMgYXJlIHRoZSBvbmx5IG9uZXMgd2Ug
Y2FyZQogCSAqIGFib3V0LiAgWGVuIHdpbGwgaGFuZGxlIGZhdWx0cyBsaWtlIGRvdWJsZV9mYXVs
dCBhbmQKLQkgKiBtYWNoaW5lX2NoZWNrLCBzbyB3ZSBzaG91bGQgbmV2ZXIgc2VlIHRoZW0uICBX
YXJuIGlmCisJICogbm1pLCBzbyB3ZSBzaG91bGQgbmV2ZXIgc2VlIHRoZW0uICBXYXJuIGlmCiAJ
ICogdGhlcmUncyBhbiB1bmV4cGVjdGVkIElTVC11c2luZyBmYXVsdCBoYW5kbGVyLgogCSAqLwog
CWlmIChhZGRyID09ICh1bnNpZ25lZCBsb25nKWRlYnVnKQpAQCAtNTQxLDcgKzU0MSwxMCBAQCBz
dGF0aWMgaW50IGN2dF9nYXRlX3RvX3RyYXAoaW50IHZlY3RvciwgY29uc3QgZ2F0ZV9kZXNjICp2
YWwsCiAJCXJldHVybiAwOwogI2lmZGVmIENPTkZJR19YODZfTUNFCiAJfSBlbHNlIGlmIChhZGRy
ID09ICh1bnNpZ25lZCBsb25nKW1hY2hpbmVfY2hlY2spIHsKLQkJcmV0dXJuIDA7CisJCWlmICh4
ZW5faW5pdGlhbF9kb21haW4oKSkKKwkJCWFkZHIgPSAodW5zaWduZWQgbG9uZyltYWNoaW5lX2No
ZWNrOworCQllbHNlCisJCQlyZXR1cm4gMDsKICNlbmRpZgogCX0gZWxzZSB7CiAJCS8qIFNvbWUg
b3RoZXIgdHJhcCB1c2luZyBJU1Q/ICovCi0tIAoxLjYuNS42Cgo=

--_002_DE8DF0795D48FD4CA783C40EC829233596B7SHSMSX101ccrcorpint_--
