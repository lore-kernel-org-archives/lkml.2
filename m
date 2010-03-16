Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937610Ab0CPJTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:19:06 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:44696 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932553Ab0CPJTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:19:01 -0400
To: Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH] gpio: max732x: fix input configuration for open-drain pins
MIME-Version: 1.0
Date: Tue, 16 Mar 2010 10:19:00 +0100
From: Marc Zyngier <maz@misterjones.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Organization: Metropolis
Message-ID: <c2d04a7116b74b3717366148db5f7e54@localhost>
User-Agent: RoundCube Webmail/0.3.1
Content-Type: multipart/mixed;
	boundary="=_6d0deb0e9a11be98ffdbe8b3755a8bb5"
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: eric.y.miao@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=_6d0deb0e9a11be98ffdbe8b3755a8bb5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"

Eric,

The attached patch tries to fix a bug I noticed while hacking on the
max732x driver for interrupt support.
According to the datasheets, open-drain pins have to be configured as
output-high (which in that case is actually high impedance) to be used as
input.

Note that this patch has only been compile tested, as I still have to
solder the actual chip to one of my boards...

Thanks,

        M.
-- 
Who you jivin' with that Cosmik Debris?
--=_6d0deb0e9a11be98ffdbe8b3755a8bb5
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name*0*="UTF-8''0002-gpio-max732x-fix-input-configuration-for-open-drain"
 name*1*="-.patch";
Content-Disposition: attachment;
 filename*0*="UTF-8''0002-gpio-max732x-fix-input-configuration-for-open-d"
 filename*1*="rain-.patch";

RnJvbSAwNTllYjliNjFiMjc2YTY4MWQ2MzQ3ODFhYmFhMTE1OWRmYjU0N2JjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJjIFp5bmdpZXIgPG1hekBtaXN0ZXJqb25lcy5vcmc+CkRh
dGU6IE1vbiwgMTUgTWFyIDIwMTAgMjI6MTQ6NTEgKzAwMDAKU3ViamVjdDogW1BBVENIXSBncGlv
OiBtYXg3MzJ4OiBmaXggaW5wdXQgY29uZmlndXJhdGlvbiBmb3Igb3Blbi1kcmFpbiBwaW5zCgpt
YXg3MzJ4IGRhdGFzaGVldHMgaW5kaWNhdGUgdGhhdCBvcGVuLWRyYWluIHBpbnMgbXVzdCBiZQpj
b25maWd1cmVkIGFzIG91dHB1dC1oaWdoIHRvIGJlIHVzZWQgYXMgaW5wdXQuLi4KClNpZ25lZC1v
ZmYtYnk6IE1hcmMgWnluZ2llciA8bWF6QG1pc3RlcmpvbmVzLm9yZz4KLS0tCiBkcml2ZXJzL2dw
aW8vbWF4NzMyeC5jIHwgICAxMiArKysrKysrKysrKy0KIDEgZmlsZXMgY2hhbmdlZCwgMTEgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwaW8vbWF4
NzMyeC5jIGIvZHJpdmVycy9ncGlvL21heDczMnguYwppbmRleCBmNzg2ODI0Li4zNjE4ZmViIDEw
MDY0NAotLS0gYS9kcml2ZXJzL2dwaW8vbWF4NzMyeC5jCisrKyBiL2RyaXZlcnMvZ3Bpby9tYXg3
MzJ4LmMKQEAgLTE3OSwxNSArMTc5LDI1IEBAIHN0YXRpYyBpbnQgbWF4NzMyeF9ncGlvX2RpcmVj
dGlvbl9pbnB1dChzdHJ1Y3QgZ3Bpb19jaGlwICpnYywgdW5zaWduZWQgb2ZmKQogewogCXN0cnVj
dCBtYXg3MzJ4X2NoaXAgKmNoaXA7CiAJdW5zaWduZWQgaW50IG1hc2sgPSAxdSA8PCBvZmY7CisJ
dW5zaWduZWQgaW50IGlzX2lucHV0OwogCiAJY2hpcCA9IGNvbnRhaW5lcl9vZihnYywgc3RydWN0
IG1heDczMnhfY2hpcCwgZ3Bpb19jaGlwKTsKIAotCWlmICgobWFzayAmIGNoaXAtPmRpcl9pbnB1
dCkgPT0gMCkgeworCWlzX2lucHV0ID0gbWFzayAmIGNoaXAtPmRpcl9pbnB1dDsKKworCWlmICgh
aXNfaW5wdXQpIHsKIAkJZGV2X2RiZygmY2hpcC0+Y2xpZW50LT5kZXYsICIlcyBwb3J0ICVkIGlz
IG91dHB1dCBvbmx5XG4iLAogCQkJY2hpcC0+Y2xpZW50LT5uYW1lLCBvZmYpOwogCQlyZXR1cm4g
LUVBQ0NFUzsKIAl9CiAKKwkvKgorCSAqIE9wZW4tZHJhaW4gcGlucyBtdXN0IGJlIHNldCB0byBo
aWdoIGltcGVkYW5jZSAod2hpY2ggaXMKKwkgKiBlcXVpdmFsZW50IHRvIG91dHB1dC1oaWdoKSB0
byBiZSB0dXJuZWQgaW50byBhbiBpbnB1dC4KKwkgKi8KKwlpZiAoKGlzX2lucHV0ICYgY2hpcC0+
ZGlyX291dHB1dCkpCisJCW1heDczMnhfZ3Bpb19zZXRfdmFsdWUoZ2MsIG9mZiwgMSk7CisKIAly
ZXR1cm4gMDsKIH0KIAotLSAKMS43LjAuMgoK
--=_6d0deb0e9a11be98ffdbe8b3755a8bb5--

