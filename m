Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2IIPKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 11:10:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:25746 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab2IIPKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 11:10:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,394,1344236400"; 
   d="scan'208,223";a="190866430"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: tsc deadline timer works only when hrtimer high
 resolution configured
Thread-Topic: [PATCH] KVM: tsc deadline timer works only when hrtimer high
 resolution configured
Thread-Index: AQHNjpuwEaLQ0dDCRmG5O7fBmMDyI5eCHJhw
Date: Sun, 9 Sep 2012 15:10:50 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353235C7@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233531F0E4@SHSMSX101.ccr.corp.intel.com>
 <5048AC08.5050100@redhat.com>
 <DE8DF0795D48FD4CA783C40EC8292335322311@SHSMSX101.ccr.corp.intel.com>
 <504CA787.2000905@redhat.com>
 <DE8DF0795D48FD4CA783C40EC8292335323599@SHSMSX101.ccr.corp.intel.com>
 <504CAEC7.9000807@redhat.com>
In-Reply-To: <504CAEC7.9000807@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353235C7SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353235C7SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 09/09/2012 05:54 PM, Liu, Jinsong wrote:
>>>=20
>>> hrtimers is an intrusive feature, I don't think we should
>>> force-enable it.  Please change it to a depends on.
>>=20
>> Hmm, if it changed as
>> config KVM
>> 	depends on HIGH_RES_TIMERS
>> The item 'Kernel-based Virtual Machine (KVM) support (NEW)' even
>> didn't appear to user when make menuconfig (when HIGH_RES_TIMERS
>> disable) =20
>>=20
>> Is it good? I just have a little concern here:)
>=20
> It's not good, but that's what we have.
>=20
> It's okay to force-enable low-impact features (like preempt notifies).
>=20
> hrimers, on the other hand, change kernel behaviour quite deeply.
>=20
> Maybe over time someone will fix the config tools to unhide features
> that can be enabled by turning on a dependency.

OK, updated as attached.

Thanks,
Jinsong

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>From e6c2a80d3111cc6fb992d78b242619706d99bc6b Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Mon, 10 Sep 2012 06:55:39 +0800
Subject: [PATCH] KVM: KVM enable depends on HIGH_RES_TIMERS

KVM lapic timer and tsc deadline timer based on hrtimer,
setting a leftmost node to rb tree and then do hrtimer reprogram.
If hrtimer not configured as high resolution, hrtimer_enqueue_reprogram
do nothing and then make kvm lapic timer and tsc deadline timer fail.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 arch/x86/kvm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index a28f338..65657ec 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -20,6 +20,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM
+	depends on HIGH_RES_TIMERS
 	# for device assignment:
 	depends on PCI
 	# for TASKSTATS/TASK_DELAY_ACCT:
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923353235C7SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-KVM-KVM-enable-depends-on-HIGH_RES_TIMERS.patch"
Content-Description: 0001-KVM-KVM-enable-depends-on-HIGH_RES_TIMERS.patch
Content-Disposition: attachment;
	filename="0001-KVM-KVM-enable-depends-on-HIGH_RES_TIMERS.patch"; size=1003;
	creation-date="Sun, 09 Sep 2012 15:07:45 GMT";
	modification-date="Sun, 09 Sep 2012 22:59:48 GMT"
Content-Transfer-Encoding: base64

RnJvbSBlNmMyYTgwZDMxMTFjYzZmYjk5MmQ3OGIyNDI2MTk3MDZkOTliYzZiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogTW9uLCAxMCBTZXAgMjAxMiAwNjo1NTozOSArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIEtW
TTogS1ZNIGVuYWJsZSBkZXBlbmRzIG9uIEhJR0hfUkVTX1RJTUVSUwoKS1ZNIGxhcGljIHRpbWVy
IGFuZCB0c2MgZGVhZGxpbmUgdGltZXIgYmFzZWQgb24gaHJ0aW1lciwKc2V0dGluZyBhIGxlZnRt
b3N0IG5vZGUgdG8gcmIgdHJlZSBhbmQgdGhlbiBkbyBocnRpbWVyIHJlcHJvZ3JhbS4KSWYgaHJ0
aW1lciBub3QgY29uZmlndXJlZCBhcyBoaWdoIHJlc29sdXRpb24sIGhydGltZXJfZW5xdWV1ZV9y
ZXByb2dyYW0KZG8gbm90aGluZyBhbmQgdGhlbiBtYWtlIGt2bSBsYXBpYyB0aW1lciBhbmQgdHNj
IGRlYWRsaW5lIHRpbWVyIGZhaWwuCgpTaWduZWQtb2ZmLWJ5OiBMaXUsIEppbnNvbmcgPGppbnNv
bmcubGl1QGludGVsLmNvbT4KLS0tCiBhcmNoL3g4Ni9rdm0vS2NvbmZpZyB8ICAgIDEgKwogMSBm
aWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva3ZtL0tjb25maWcgYi9hcmNoL3g4Ni9rdm0vS2NvbmZpZwppbmRleCBhMjhm
MzM4Li42NTY1N2VjIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rdm0vS2NvbmZpZworKysgYi9hcmNo
L3g4Ni9rdm0vS2NvbmZpZwpAQCAtMjAsNiArMjAsNyBAQCBpZiBWSVJUVUFMSVpBVElPTgogY29u
ZmlnIEtWTQogCXRyaXN0YXRlICJLZXJuZWwtYmFzZWQgVmlydHVhbCBNYWNoaW5lIChLVk0pIHN1
cHBvcnQiCiAJZGVwZW5kcyBvbiBIQVZFX0tWTQorCWRlcGVuZHMgb24gSElHSF9SRVNfVElNRVJT
CiAJIyBmb3IgZGV2aWNlIGFzc2lnbm1lbnQ6CiAJZGVwZW5kcyBvbiBQQ0kKIAkjIGZvciBUQVNL
U1RBVFMvVEFTS19ERUxBWV9BQ0NUOgotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC82923353235C7SHSMSX101ccrcorpi_--
