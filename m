Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab1C1EiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 00:38:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754Ab1C1EiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 00:38:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110328042311.GA15481@elte.hu>
References: <4D8E36CC.7080707@fusionio.com> <20110328042311.GA15481@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 27 Mar 2011 21:37:50 -0700
Message-ID: <AANLkTik3GZ0b5S7p4ONQu4Hb8LoKewmMJ7_J5zvumYD-@mail.gmail.com>
Subject: Re: [GIT PULL] block drivers for 2.6.39-rc
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd57398c13d04049f8382ac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd57398c13d04049f8382ac
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 27, 2011 at 9:23 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> This driver does not build at all:
>
> =A0drivers/block/drbd/drbd_bitmap.c:1187:5: error: implicit declaration o=
f function =91generic_find_next_zero_le_bit=92 [-Werror=3Dimplicit-function=
-declaration]
> =A0drivers/block/drbd/drbd_bitmap.c:1190:5: error: implicit declaration o=
f function =91generic_find_next_le_bit=92 [-Werror=3Dimplicit-function-decl=
aration]
> =A0drivers/block/drbd/drbd_bitmap.c:1290:4: error: implicit declaration o=
f function =91generic___test_and_set_le_bit=92 [-Werror=3Dimplicit-function=
-declaration]
> =A0drivers/block/drbd/drbd_bitmap.c:1292:4: error: implicit declaration o=
f function =91generic___test_and_clear_le_bit=92 [-Werror=3Dimplicit-functi=
on-declaration]
> =A0drivers/block/drbd/drbd_bitmap.c:1441:3: error: implicit declaration o=
f function =91generic_test_le_bit=92 [-Werror=3Dimplicit-function-declarati=
on]
>
> Has this been build-tested? These APIs do not exist upstream.

Actually, I think that's just a merge error - those horrible nasty
crazy names did use to exist.

Does this fix it? (Untested!)

                    Linus

--000e0cd57398c13d04049f8382ac
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_glswp36g1

IGRyaXZlcnMvYmxvY2svZHJiZC9kcmJkX2JpdG1hcC5jIHwgICAxMiArKysrKystLS0tLS0KIDEg
ZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvYmxvY2svZHJiZC9kcmJkX2JpdG1hcC5jIGIvZHJpdmVycy9ibG9jay9kcmJk
L2RyYmRfYml0bWFwLmMKaW5kZXggZjBhZTYzZC4uZWI5MjVmYSAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9ibG9jay9kcmJkL2RyYmRfYml0bWFwLmMKKysrIGIvZHJpdmVycy9ibG9jay9kcmJkL2RyYmRf
Yml0bWFwLmMKQEAgLTExODQsMTAgKzExODQsMTAgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgX19i
bV9maW5kX25leHQoc3RydWN0IGRyYmRfY29uZiAqbWRldiwgdW5zaWduZWQgbG9uZyBibV9mbywK
IAkJCXBfYWRkciA9IF9fYm1fbWFwX3BpZHgoYiwgYm1fYml0X3RvX3BhZ2VfaWR4KGIsIGJtX2Zv
KSwga20pOwogCiAJCQlpZiAoZmluZF96ZXJvX2JpdCkKLQkJCQlpID0gZ2VuZXJpY19maW5kX25l
eHRfemVyb19sZV9iaXQocF9hZGRyLAorCQkJCWkgPSBmaW5kX25leHRfemVyb19iaXRfbGUocF9h
ZGRyLAogCQkJCQkJUEFHRV9TSVpFKjgsIGJtX2ZvICYgQklUU19QRVJfUEFHRV9NQVNLKTsKIAkJ
CWVsc2UKLQkJCQlpID0gZ2VuZXJpY19maW5kX25leHRfbGVfYml0KHBfYWRkciwKKwkJCQlpID0g
ZmluZF9uZXh0X2JpdF9sZShwX2FkZHIsCiAJCQkJCQlQQUdFX1NJWkUqOCwgYm1fZm8gJiBCSVRT
X1BFUl9QQUdFX01BU0spOwogCiAJCQlfX2JtX3VubWFwKHBfYWRkciwga20pOwpAQCAtMTI4Nyw5
ICsxMjg3LDkgQEAgc3RhdGljIGludCBfX2JtX2NoYW5nZV9iaXRzX3RvKHN0cnVjdCBkcmJkX2Nv
bmYgKm1kZXYsIGNvbnN0IHVuc2lnbmVkIGxvbmcgcywKIAkJCWxhc3RfcGFnZV9uciA9IHBhZ2Vf
bnI7CiAJCX0KIAkJaWYgKHZhbCkKLQkJCWMgKz0gKDAgPT0gZ2VuZXJpY19fX3Rlc3RfYW5kX3Nl
dF9sZV9iaXQoYml0bnIgJiBCSVRTX1BFUl9QQUdFX01BU0ssIHBfYWRkcikpOworCQkJYyArPSAo
MCA9PSBfX3Rlc3RfYW5kX3NldF9iaXRfbGUoYml0bnIgJiBCSVRTX1BFUl9QQUdFX01BU0ssIHBf
YWRkcikpOwogCQllbHNlCi0JCQljIC09ICgwICE9IGdlbmVyaWNfX190ZXN0X2FuZF9jbGVhcl9s
ZV9iaXQoYml0bnIgJiBCSVRTX1BFUl9QQUdFX01BU0ssIHBfYWRkcikpOworCQkJYyAtPSAoMCAh
PSBfX3Rlc3RfYW5kX2NsZWFyX2JpdF9sZShiaXRuciAmIEJJVFNfUEVSX1BBR0VfTUFTSywgcF9h
ZGRyKSk7CiAJfQogCWlmIChwX2FkZHIpCiAJCV9fYm1fdW5tYXAocF9hZGRyLCBrbSk7CkBAIC0x
NDM4LDcgKzE0MzgsNyBAQCBpbnQgZHJiZF9ibV90ZXN0X2JpdChzdHJ1Y3QgZHJiZF9jb25mICpt
ZGV2LCBjb25zdCB1bnNpZ25lZCBsb25nIGJpdG5yKQogCQlibV9wcmludF9sb2NrX2luZm8obWRl
dik7CiAJaWYgKGJpdG5yIDwgYi0+Ym1fYml0cykgewogCQlwX2FkZHIgPSBibV9tYXBfcGlkeChi
LCBibV9iaXRfdG9fcGFnZV9pZHgoYiwgYml0bnIpKTsKLQkJaSA9IGdlbmVyaWNfdGVzdF9sZV9i
aXQoYml0bnIgJiBCSVRTX1BFUl9QQUdFX01BU0ssIHBfYWRkcikgPyAxIDogMDsKKwkJaSA9IHRl
c3RfYml0X2xlKGJpdG5yICYgQklUU19QRVJfUEFHRV9NQVNLLCBwX2FkZHIpID8gMSA6IDA7CiAJ
CWJtX3VubWFwKHBfYWRkcik7CiAJfSBlbHNlIGlmIChiaXRuciA9PSBiLT5ibV9iaXRzKSB7CiAJ
CWkgPSAtMTsKQEAgLTE0ODIsNyArMTQ4Miw3IEBAIGludCBkcmJkX2JtX2NvdW50X2JpdHMoc3Ry
dWN0IGRyYmRfY29uZiAqbWRldiwgY29uc3QgdW5zaWduZWQgbG9uZyBzLCBjb25zdCB1bnNpCiAJ
CUVSUl9JRiAoYml0bnIgPj0gYi0+Ym1fYml0cykgewogCQkJZGV2X2VycihERVYsICJiaXRucj0l
bHUgYm1fYml0cz0lbHVcbiIsIGJpdG5yLCBiLT5ibV9iaXRzKTsKIAkJfSBlbHNlIHsKLQkJCWMg
Kz0gKDAgIT0gZ2VuZXJpY190ZXN0X2xlX2JpdChiaXRuciAtIChwYWdlX25yIDw8IChQQUdFX1NI
SUZUKzMpKSwgcF9hZGRyKSk7CisJCQljICs9ICgwICE9IHRlc3RfYml0X2xlKGJpdG5yIC0gKHBh
Z2VfbnIgPDwgKFBBR0VfU0hJRlQrMykpLCBwX2FkZHIpKTsKIAkJfQogCX0KIAlpZiAocF9hZGRy
KQo=
--000e0cd57398c13d04049f8382ac--
