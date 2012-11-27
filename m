Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2K0EkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 23:40:13 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52824 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2K0EkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 23:40:11 -0500
MIME-Version: 1.0
Date: Tue, 27 Nov 2012 12:40:10 +0800
Message-ID: <CABawtvMQ1ShCWFcz3ot4OjT3APCZraG=f9PL2qzsXRM-6fGBmA@mail.gmail.com>
Subject: [patch] Add IVB model 3e support to /drivers/idle/intel_idle.c
From: Ethan Zhao <ethan.kernel@gmail.com>
To: len.brown@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        "Zheng, Lv" <lv.zheng@intel.com>, yinghai@kernel.org
Content-Type: multipart/mixed; boundary=e89a8f642ee024474c04cf72a532
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f642ee024474c04cf72a532
Content-Type: text/plain; charset=ISO-8859-1

Hi, Len
    Please help to review and apply the patch if it is OK.
I didn't go through all the related code, simply add the model 3e to
the id list, I have tested it with stable branch kernel 3.6.7 on my
Server with Intel ES0 installed.

Thanks,
Ethan

commit 59b90976a0d93d1656583c7a807ec9c8909b0772
Author: ethan.kernel <ethan.kernel@gmail.com>
Date:   Mon Nov 26 19:55:24 2012 -0800

    According to SDM version 44(Intel64 and IA-32 Architectures Software
    Developer's Manual Vol.3C 35-1),add cpu model 3e support

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index e872617..b0f6b4c 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -413,6 +413,7 @@ static const struct x86_cpu_id intel_idle_ids[] = {
        ICPU(0x2a, idle_cpu_snb),
        ICPU(0x2d, idle_cpu_snb),
        ICPU(0x3a, idle_cpu_ivb),
+       ICPU(0x3e, idle_cpu_ivb),
        {}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);

--e89a8f642ee024474c04cf72a532
Content-Type: application/octet-stream; 
	name="Add_IVB_3E_support_to_intel_idle.patch"
Content-Disposition: attachment; 
	filename="Add_IVB_3E_support_to_intel_idle.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ha0j9e770

RnJvbSA1OWI5MDk3NmEwZDkzZDE2NTY1ODNjN2E4MDdlYzljODkwOWIwNzcyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBldGhhbi5rZXJuZWwgPGV0aGFuLmtlcm5lbEBnbWFpbC5jb20+
CkRhdGU6IE1vbiwgMjYgTm92IDIwMTIgMTk6NTU6MjQgLTA4MDAKU3ViamVjdDogW1BBVENIIDUz
OS81MzldIEFjY29yZGluZyB0byBTRE0gdmVyc2lvbiA0NChJbnRlbDY0IGFuZCBJQS0zMiBBcmNo
aXRlY3R1cmVzIFNvZnR3YXJlCiBEZXZlbG9wZXIncyBNYW51YWwgVm9sLjNDIDM1LTEpLGFkZCBj
cHUgbW9kZWwgM2Ugc3VwcG9ydAoKClNpZ25lZC1vZmYtYnk6IGV0aGFuLmtlcm5lbCA8ZXRoYW4u
a2VybmVsQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL2lkbGUvaW50ZWxfaWRsZS5jIHwgICAgMSAr
CiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2lkbGUvaW50ZWxfaWRsZS5jIGIvZHJpdmVycy9pZGxlL2ludGVsX2lk
bGUuYwppbmRleCBlODcyNjE3Li5iMGY2YjRjIDEwMDY0NAotLS0gYS9kcml2ZXJzL2lkbGUvaW50
ZWxfaWRsZS5jCisrKyBiL2RyaXZlcnMvaWRsZS9pbnRlbF9pZGxlLmMKQEAgLTQxMyw2ICs0MTMs
NyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHg4Nl9jcHVfaWQgaW50ZWxfaWRsZV9pZHNbXSA9IHsK
IAlJQ1BVKDB4MmEsIGlkbGVfY3B1X3NuYiksCiAJSUNQVSgweDJkLCBpZGxlX2NwdV9zbmIpLAog
CUlDUFUoMHgzYSwgaWRsZV9jcHVfaXZiKSwKKwlJQ1BVKDB4M2UsIGlkbGVfY3B1X2l2YiksCiAJ
e30KIH07CiBNT0RVTEVfREVWSUNFX1RBQkxFKHg4NmNwdSwgaW50ZWxfaWRsZV9pZHMpOwotLSAK
MS43LjEKCg==
--e89a8f642ee024474c04cf72a532--
