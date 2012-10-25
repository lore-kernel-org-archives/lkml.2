Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965612Ab2JYNML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:12:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:47525 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965589Ab2JYNMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:12:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,646,1344236400"; 
   d="scan'208,223";a="209179775"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: [PATCH 2/2] Revert pad config check in xen_check_mwait
Thread-Topic: [PATCH 2/2] Revert pad config check in xen_check_mwait
Thread-Index: Ac2yslLcYde/7kJ6SnCXVbHberM6CA==
Date: Thu, 25 Oct 2012 13:12:02 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335371767@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335371767SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335371767SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Seems my mail server has a little problem, so re-send it. If you receive it=
 twice, please ignore one. Sorry :)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>From 9ed5cd6012ac0832973be6e7fa01fc159f373e1c Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 26 Oct 2012 03:14:46 +0800
Subject: [PATCH 2/2] Revert pad config check in xen_check_mwait

With Xen acpi pad logic added into kernel, we can now revert xen mwait rela=
ted
patch df88b2d96e36d9a9e325bfcd12eb45671cbbc937. The reason is, when runs un=
der
Xen platform, Xen pad driver would be early loaded, so native pad driver wo=
uld
fail to be loaded, and hence no mwait/monitor #UD risk again.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 arch/x86/xen/enlighten.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 586d838..8bf28b1 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -287,8 +287,7 @@ static void xen_cpuid(unsigned int *ax, unsigned int *b=
x,
=20
 static bool __init xen_check_mwait(void)
 {
-#if defined(CONFIG_ACPI) && !defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR) && =
\
-	!defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR_MODULE)
+#ifdef CONFIG_ACPI
 	struct xen_platform_op op =3D {
 		.cmd			=3D XENPF_set_processor_pminfo,
 		.u.set_pminfo.id	=3D -1,
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC8292335371767SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-Revert-pad-config-check-in-xen_check_mwait.patch"
Content-Description: 0002-Revert-pad-config-check-in-xen_check_mwait.patch
Content-Disposition: attachment;
	filename="0002-Revert-pad-config-check-in-xen_check_mwait.patch"; size=1201;
	creation-date="Thu, 25 Oct 2012 12:15:46 GMT";
	modification-date="Thu, 25 Oct 2012 20:07:22 GMT"
Content-Transfer-Encoding: base64

RnJvbSA5ZWQ1Y2Q2MDEyYWMwODMyOTczYmU2ZTdmYTAxZmMxNTlmMzczZTFjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAyNiBPY3QgMjAxMiAwMzoxNDo0NiArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSBSZXZlcnQgcGFkIGNvbmZpZyBjaGVjayBpbiB4ZW5fY2hlY2tfbXdhaXQKCldpdGggWGVuIGFj
cGkgcGFkIGxvZ2ljIGFkZGVkIGludG8ga2VybmVsLCB3ZSBjYW4gbm93IHJldmVydCB4ZW4gbXdh
aXQgcmVsYXRlZApwYXRjaCBkZjg4YjJkOTZlMzZkOWE5ZTMyNWJmY2QxMmViNDU2NzFjYmJjOTM3
LiBUaGUgcmVhc29uIGlzLCB3aGVuIHJ1bnMgdW5kZXIKWGVuIHBsYXRmb3JtLCBYZW4gcGFkIGRy
aXZlciB3b3VsZCBiZSBlYXJseSBsb2FkZWQsIHNvIG5hdGl2ZSBwYWQgZHJpdmVyIHdvdWxkCmZh
aWwgdG8gYmUgbG9hZGVkLCBhbmQgaGVuY2Ugbm8gbXdhaXQvbW9uaXRvciAjVUQgcmlzayBhZ2Fp
bi4KClNpZ25lZC1vZmYtYnk6IExpdSwgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgot
LS0KIGFyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYyB8ICAgIDMgKy0tCiAxIGZpbGVzIGNoYW5nZWQs
IDEgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni94
ZW4vZW5saWdodGVuLmMgYi9hcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMKaW5kZXggNTg2ZDgzOC4u
OGJmMjhiMSAxMDA2NDQKLS0tIGEvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jCisrKyBiL2FyY2gv
eDg2L3hlbi9lbmxpZ2h0ZW4uYwpAQCAtMjg3LDggKzI4Nyw3IEBAIHN0YXRpYyB2b2lkIHhlbl9j
cHVpZCh1bnNpZ25lZCBpbnQgKmF4LCB1bnNpZ25lZCBpbnQgKmJ4LAogCiBzdGF0aWMgYm9vbCBf
X2luaXQgeGVuX2NoZWNrX213YWl0KHZvaWQpCiB7Ci0jaWYgZGVmaW5lZChDT05GSUdfQUNQSSkg
JiYgIWRlZmluZWQoQ09ORklHX0FDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1IpICYmIFwKLQkhZGVm
aW5lZChDT05GSUdfQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9NT0RVTEUpCisjaWZkZWYgQ09O
RklHX0FDUEkKIAlzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIG9wID0gewogCQkuY21kCQkJPSBYRU5Q
Rl9zZXRfcHJvY2Vzc29yX3BtaW5mbywKIAkJLnUuc2V0X3BtaW5mby5pZAk9IC0xLAotLSAKMS43
LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC8292335371767SHSMSX101ccrcorpi_--
