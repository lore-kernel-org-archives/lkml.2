Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab0DWNhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:37:48 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:45734 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756000Ab0DWNhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:37:46 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gpio: max732x: fix input configuration for open-drain pins
MIME-Version: 1.0
Date: Fri, 23 Apr 2010 15:37:43 +0200
From: Marc Zyngier <maz@misterjones.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Organization: Metropolis
In-Reply-To: <20100420165148.49711c3c.akpm@linux-foundation.org>
References: <c2d04a7116b74b3717366148db5f7e54@localhost> <20100420165148.49711c3c.akpm@linux-foundation.org>
Message-ID: <53798eb0b7ee483000fcd94fb76af377@localhost>
User-Agent: RoundCube Webmail/0.3.1
Content-Type: multipart/mixed;
	boundary="=_2eb6a3c5ffc6f7120dcf6d25712b2b64"
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, eric.y.miao@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=_2eb6a3c5ffc6f7120dcf6d25712b2b64
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"

On Tue, 20 Apr 2010 16:51:48 -0700, Andrew Morton
<akpm@linux-foundation.org> wrote:
>> On Tue, 16 Mar 2010 10:19:00 +0100
> 
> I bet you thought I'd forgotten.

Naaaah... I trust your memory more than mine... ;-)

> You really did mean `&' here, but one very much expects a variable
> called is_foo to be a boolean, and booleans want `&&'.

Actually, the attached patch is a much simpler solution to this particular
one. We already checked that the pin is input-capable. Use the same mask to
check that the pin is also output-capable, and thus open-drain. No need for
an additional variable.

Thanks,

        M.
-- 
Who you jivin' with that Cosmik Debris?
--=_2eb6a3c5ffc6f7120dcf6d25712b2b64
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name*0*="UTF-8''0001-gpio-max732x-fix-input-configuration-for-open-drain"
 name*1*="-.patch";
Content-Disposition: attachment;
 filename*0*="UTF-8''0001-gpio-max732x-fix-input-configuration-for-open-d"
 filename*1*="rain-.patch";

RnJvbSAzZmY3ZmY3ZjEzMTQ1YTZhNDZmZmEyZTBjYzM1MGJlZTFmMTIwNTc3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJjIFp5bmdpZXIgPG1hekBtaXN0ZXJqb25lcy5vcmc+CkRh
dGU6IEZyaSwgMjMgQXByIDIwMTAgMTI6MjU6NTMgKzAxMDAKU3ViamVjdDogW1BBVENIXSBncGlv
OiBtYXg3MzJ4OiBmaXggaW5wdXQgY29uZmlndXJhdGlvbiBmb3Igb3Blbi1kcmFpbiBwaW5zCgpG
aXggYSBidWcgSSBub3RpY2VkIHdoaWxlIGhhY2tpbmcgb24gdGhlIG1heDczMnggZHJpdmVyIGZv
ciBpbnRlcnJ1cHQKc3VwcG9ydC4gIEFjY29yZGluZyB0byB0aGUgZGF0YXNoZWV0cywgb3Blbi1k
cmFpbiBwaW5zIGhhdmUgdG8gYmUKY29uZmlndXJlZCBhcyBvdXRwdXQtaGlnaCAod2hpY2ggaW4g
dGhhdCBjYXNlIGlzIGFjdHVhbGx5IGhpZ2ggaW1wZWRhbmNlKQp0byBiZSB1c2VkIGFzIGlucHV0
LgoKU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAbWlzdGVyam9uZXMub3JnPgpBY2tl
ZC1ieTogRXJpYyBNaWFvIDxlcmljLnkubWlhb0BnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9ncGlv
L21heDczMnguYyB8ICAgIDcgKysrKysrKwogMSBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMo
KyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncGlvL21heDczMnguYyBi
L2RyaXZlcnMvZ3Bpby9tYXg3MzJ4LmMKaW5kZXggZjc4NjgyNC4uYWQ2YTgwYiAxMDA2NDQKLS0t
IGEvZHJpdmVycy9ncGlvL21heDczMnguYworKysgYi9kcml2ZXJzL2dwaW8vbWF4NzMyeC5jCkBA
IC0xODgsNiArMTg4LDEzIEBAIHN0YXRpYyBpbnQgbWF4NzMyeF9ncGlvX2RpcmVjdGlvbl9pbnB1
dChzdHJ1Y3QgZ3Bpb19jaGlwICpnYywgdW5zaWduZWQgb2ZmKQogCQlyZXR1cm4gLUVBQ0NFUzsK
IAl9CiAKKwkvKgorCSAqIE9wZW4tZHJhaW4gcGlucyBtdXN0IGJlIHNldCB0byBoaWdoIGltcGVk
YW5jZSAod2hpY2ggaXMKKwkgKiBlcXVpdmFsZW50IHRvIG91dHB1dC1oaWdoKSB0byBiZSB0dXJu
ZWQgaW50byBhbiBpbnB1dC4KKwkgKi8KKwlpZiAoKG1hc2sgJiBjaGlwLT5kaXJfb3V0cHV0KSkK
KwkJbWF4NzMyeF9ncGlvX3NldF92YWx1ZShnYywgb2ZmLCAxKTsKKwogCXJldHVybiAwOwogfQog
Ci0tIAoxLjcuMC40Cgo=
--=_2eb6a3c5ffc6f7120dcf6d25712b2b64--

