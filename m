Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1GaBNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 21:13:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256Ab1GaBNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 21:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <1311971867-25124-2-git-send-email-hpa@linux.intel.com>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com> <1311971867-25124-2-git-send-email-hpa@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Jul 2011 15:13:27 -1000
Message-ID: <CA+55aFz07ewwkBHeqj_VqAiNCBzDj8uzA0xzt2fc4qrYB9O19g@mail.gmail.com>
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00221597587afce5ae04a9533958
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00221597587afce5ae04a9533958
Content-Type: text/plain; charset=ISO-8859-1

So here is my counter-suggestion

NOTE NOTE NOTE! This is completely and utterly untested.  I didn't
actually check how big the "rdrand" and "setc" instructions are, so
the ASM_NOP4 there is just a random "I guess two 'xor' instructions
are four bytes shorter than the rdrand/setc instructions are".

So please don't take this as a serious patch that should be applied,
but instead take it as a serious alternative *approach*.

Note that with the default inline function in <asm-generic/random.h>
is designed so that architectures that use it (this patch does *not*
contain the architecture glue to enable it) will compile the loop in
random.c entirely away. No test, no nothing.

Comments?

(Btw, even on x86, assuming the concept works and the ASM_NOP4 is
corrected to the right length, we'd need to support older assemblers
that don't understand the "rdrand" instruction, so it would need to be
done as a explicit byte sequence).

Again, TOTALLY UNTESTED. Concept patch only!! There may be seriously
stupid bugs here, but the point is that it should make it easy for an
architecture to have a "get a word of random data quickly".

                     Linus

--00221597587afce5ae04a9533958
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqrbefgp0

Y29tbWl0IDIxODYwMzQxMmFhZDA3M2EwNGVhODE1ODU4Yjk4ZjZjMzNhYjMwZDIKQXV0aG9yOiBM
aW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+CkRhdGU6ICAgU2F0
IEp1bCAzMCAxNTowNjoxNiAyMDExIC0xMDAwCgogICAgRVhBTVBMRSAnUkRSQU5EJyBQQVRDSAog
ICAgCiAgICBOT1QgRk9SIFJFQUwgQ09OU1VNUFRJT04hCi0tLQogYXJjaC94ODYvaW5jbHVkZS9h
c20vcmFuZG9tLmggfCAgIDIzICsrKysrKysrKysrKysrKysrKysrKysrCiBkcml2ZXJzL2NoYXIv
cmFuZG9tLmMgICAgICAgICB8ICAgMTUgKysrKysrKysrKysrKysrCiBpbmNsdWRlL2FzbS1nZW5l
cmljL3JhbmRvbS5oICB8ICAgMTMgKysrKysrKysrKysrKwogMyBmaWxlcyBjaGFuZ2VkLCA1MSBp
bnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1
ZGUvYXNtL3JhbmRvbS5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcmFuZG9tLmgKbmV3IGZpbGUg
bW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi5mNmZiZDMzNDA2MDgKLS0tIC9kZXYvbnVs
bAorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9yYW5kb20uaApAQCAtMCwwICsxLDIzIEBACisj
aWZuZGVmIF9YODZfUkFORE9NX0gKKyNkZWZpbmUgX1g4Nl9SQU5ET01fSAorCisjaW5jbHVkZSA8
YXNtL2FsdGVybmF0aXZlLmg+CisKK3N0YXRpYyBpbmxpbmUgaW50IGFyY2hfZ2V0X3JhbmRvbV93
b3JkKHVuc2lnbmVkIGxvbmcgKndvcmQpCit7CisJaW50IHJldDsKKworCWFsdGVybmF0aXZlX2lv
KCJ4b3IgJTAsJTA7IHhvciAlMSwlMSIgQVNNX05PUDQsCisJCSJyZHJhbmQgJTE7IHNldGNjICUw
IiwKKwkJWDg2X0ZFQVRVUkVfUEVSRkNUUl9DT1JFLAorCQlBU01fT1VUUFVUMigiPWEiIChyZXQp
LCAiPWQiICgqd29yZCkpLAorCQkiaSIgKDApIC8qIGZha2UgaW5wdXQgKi8pOworCS8qCisJICog
V2UgcmV0dXJuIDAgaWYgQ0YgaXMgY2xlYXIgb2YgaWYgdGhlIENQVQorCSAqIGRvZXNuJ3Qgc3Vw
cG9ydCBSRFJBTkQsIG90aGVyd2lzZSB3ZSByZXR1cm4KKwkgKiA4IChmb3IgOCBieXRlcyBvZiBk
YXRhKS4KKwkgKi8KKwlyZXR1cm4gcmV0ICYgODsKK30KKworI2VuZGlmCmRpZmYgLS1naXQgYS9k
cml2ZXJzL2NoYXIvcmFuZG9tLmMgYi9kcml2ZXJzL2NoYXIvcmFuZG9tLmMKaW5kZXggNzI5Mjgx
OTYxZjIyLi5lMzM1ZWM5NmJmODggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY2hhci9yYW5kb20uYwor
KysgYi9kcml2ZXJzL2NoYXIvcmFuZG9tLmMKQEAgLTI1Nyw2ICsyNTcsNyBAQAogI2luY2x1ZGUg
PGFzbS91YWNjZXNzLmg+CiAjaW5jbHVkZSA8YXNtL2lycS5oPgogI2luY2x1ZGUgPGFzbS9pby5o
PgorI2luY2x1ZGUgPGFzbS9yYW5kb20uaD4KIAogLyoKICAqIENvbmZpZ3VyYXRpb24gaW5mb3Jt
YXRpb24KQEAgLTg2NSw2ICs4NjYsMjAgQEAgc3RhdGljIHNzaXplX3QgZXh0cmFjdF9lbnRyb3B5
KHN0cnVjdCBlbnRyb3B5X3N0b3JlICpyLCB2b2lkICpidWYsCiAJeGZlcl9zZWNvbmRhcnlfcG9v
bChyLCBuYnl0ZXMpOwogCW5ieXRlcyA9IGFjY291bnQociwgbmJ5dGVzLCBtaW4sIHJlc2VydmVk
KTsKIAorCS8qIFVzZSBmYXN0IENQVSByYW5kb20gd29yZHMgaWYgYXZhaWxhYmxlICovCisJd2hp
bGUgKG5ieXRlcykgeworCQl1bnNpZ25lZCBsb25nIHdvcmQ7CisJCWludCBieXRlcyA9IGFyY2hf
Z2V0X3JhbmRvbV93b3JkKCZ3b3JkKTsKKwkJaWYgKCFieXRlcykKKwkJCWJyZWFrOworCQlpZiAo
Ynl0ZXMgPiBuYnl0ZXMpCisJCQlieXRlcyA9IG5ieXRlczsKKwkJbWVtY3B5KGJ1ZiwgJndvcmQs
IGJ5dGVzKTsKKwkJbmJ5dGVzIC09IGJ5dGVzOworCQlidWYgKz0gYnl0ZXM7CisJCXJldCArPSBi
eXRlczsKKwl9CisKIAl3aGlsZSAobmJ5dGVzKSB7CiAJCWV4dHJhY3RfYnVmKHIsIHRtcCk7CiAK
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvYXNtLWdlbmVyaWMvcmFuZG9tLmggYi9pbmNsdWRlL2FzbS1n
ZW5lcmljL3JhbmRvbS5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAwMDAwMC4u
ZTliZTEyYmE4NmZhCi0tLSAvZGV2L251bGwKKysrIGIvaW5jbHVkZS9hc20tZ2VuZXJpYy9yYW5k
b20uaApAQCAtMCwwICsxLDEzIEBACisjaWZuZGVmIF9BU01fUkFORE9NX0gKKyNkZWZpbmUgX0FT
TV9SQU5ET01fSAorCisvKgorICogQXJjaGl0ZWN0dXJlIHJhbmRvbSBkYXRhIGluIGxvdyBieXRl
cyBvZiAid29yZCIsIHJldHVybiBob3cKKyAqIG1hbnkgYnl0ZXMgd2VyZSBmaWxsZWQgaW4uIERl
ZmF1bHQgaW1wbGVtZW50YXRpb246IG5vbmUuCisgKi8KK3N0YXRpYyBpbmxpbmUgaW50IGFyY2hf
Z2V0X3JhbmRvbV93b3JkKHVuc2lnbmVkIGxvbmcgKndvcmQpCit7CisJcmV0dXJuIDA7Cit9CisK
KyNlbmRpZgo=
--00221597587afce5ae04a9533958--
