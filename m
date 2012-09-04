Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab2IDPHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:07:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:41867 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152Ab2IDPHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:07:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,367,1344236400"; 
   d="scan'208,223";a="188619432"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: tsc deadline timer works only when hrtimer high
 resolution configured
Thread-Topic: [PATCH] KVM: tsc deadline timer works only when hrtimer high
 resolution configured
Thread-Index: Ac2Kru6AEaLQ0dDCRmG5O7fBmMDyIw==
Date: Tue, 4 Sep 2012 15:07:00 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233531F0E4@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233531F0E4SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233531F0E4SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 728a17e2de591b557c3c8ba31076b4bf2ca5ab42 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Wed, 5 Sep 2012 03:18:15 +0800
Subject: [PATCH] KVM: tsc deadline timer works only when hrtimer high resol=
ution configured

This is for 2 reasons:
1. it's pointless to enable tsc deadline timer to guest when kernel hrtimer
not configured as high resolution, since that would be un-precise based on =
wheel;
2. tsc deadline timer based on hrtimer, setting a leftmost node to rb tree
and then do hrtimer reprogram. If hrtimer not configured as high resolution=
,
hrtimer_enqueue_reprogram do nothing and would make tsc deadline timer fail=
.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 arch/x86/kvm/x86.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 148ed66..0e64997 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2210,7 +2210,11 @@ int kvm_dev_ioctl_check_extension(long ext)
 		r =3D kvm_has_tsc_control;
 		break;
 	case KVM_CAP_TSC_DEADLINE_TIMER:
+#ifdef CONFIG_HIGH_RES_TIMERS
 		r =3D boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER);
+#else
+		r =3D 0;
+#endif
 		break;
 	default:
 		r =3D 0;
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC829233531F0E4SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-KVM-tsc-deadline-timer-works-only-when-hrtimer-high-.patch"
Content-Description: 0001-KVM-tsc-deadline-timer-works-only-when-hrtimer-high-.patch
Content-Disposition: attachment;
	filename="0001-KVM-tsc-deadline-timer-works-only-when-hrtimer-high-.patch";
	size=1218; creation-date="Tue, 04 Sep 2012 11:48:55 GMT";
	modification-date="Tue, 04 Sep 2012 19:39:46 GMT"
Content-Transfer-Encoding: base64

RnJvbSA3MjhhMTdlMmRlNTkxYjU1N2MzYzhiYTMxMDc2YjRiZjJjYTVhYjQyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogV2VkLCA1IFNlcCAyMDEyIDAzOjE4OjE1ICswODAwClN1YmplY3Q6IFtQQVRDSF0gS1ZN
OiB0c2MgZGVhZGxpbmUgdGltZXIgd29ya3Mgb25seSB3aGVuIGhydGltZXIgaGlnaCByZXNvbHV0
aW9uIGNvbmZpZ3VyZWQKClRoaXMgaXMgZm9yIDIgcmVhc29uczoKMS4gaXQncyBwb2ludGxlc3Mg
dG8gZW5hYmxlIHRzYyBkZWFkbGluZSB0aW1lciB0byBndWVzdCB3aGVuIGtlcm5lbCBocnRpbWVy
Cm5vdCBjb25maWd1cmVkIGFzIGhpZ2ggcmVzb2x1dGlvbiwgc2luY2UgdGhhdCB3b3VsZCBiZSB1
bi1wcmVjaXNlIGJhc2VkIG9uIHdoZWVsOwoyLiB0c2MgZGVhZGxpbmUgdGltZXIgYmFzZWQgb24g
aHJ0aW1lciwgc2V0dGluZyBhIGxlZnRtb3N0IG5vZGUgdG8gcmIgdHJlZQphbmQgdGhlbiBkbyBo
cnRpbWVyIHJlcHJvZ3JhbS4gSWYgaHJ0aW1lciBub3QgY29uZmlndXJlZCBhcyBoaWdoIHJlc29s
dXRpb24sCmhydGltZXJfZW5xdWV1ZV9yZXByb2dyYW0gZG8gbm90aGluZyBhbmQgd291bGQgbWFr
ZSB0c2MgZGVhZGxpbmUgdGltZXIgZmFpbC4KClNpZ25lZC1vZmYtYnk6IExpdSwgSmluc29uZyA8
amluc29uZy5saXVAaW50ZWwuY29tPgotLS0KIGFyY2gveDg2L2t2bS94ODYuYyB8ICAgIDQgKysr
KwogMSBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jCmluZGV4IDE0
OGVkNjYuLjBlNjQ5OTcgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2t2bS94ODYuYworKysgYi9hcmNo
L3g4Ni9rdm0veDg2LmMKQEAgLTIyMTAsNyArMjIxMCwxMSBAQCBpbnQga3ZtX2Rldl9pb2N0bF9j
aGVja19leHRlbnNpb24obG9uZyBleHQpCiAJCXIgPSBrdm1faGFzX3RzY19jb250cm9sOwogCQli
cmVhazsKIAljYXNlIEtWTV9DQVBfVFNDX0RFQURMSU5FX1RJTUVSOgorI2lmZGVmIENPTkZJR19I
SUdIX1JFU19USU1FUlMKIAkJciA9IGJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9UU0NfREVBRExJ
TkVfVElNRVIpOworI2Vsc2UKKwkJciA9IDA7CisjZW5kaWYKIAkJYnJlYWs7CiAJZGVmYXVsdDoK
IAkJciA9IDA7Ci0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC829233531F0E4SHSMSX101ccrcorpi_--
