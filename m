Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2GQKjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:39:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49854 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab2GQKjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:39:10 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUW4gNqspcJ1sjBD-3GCVee2VWVV5NPAr6Eo-aZHjp3y+Q@mail.gmail.com>
References: <CA+icZUXjc+13YjoJ6FjDFboX20j3mqHNtvV2Av2-H0My8V2Mgg@mail.gmail.com>
	<CA+icZUW4gNqspcJ1sjBD-3GCVee2VWVV5NPAr6Eo-aZHjp3y+Q@mail.gmail.com>
Date: Tue, 17 Jul 2012 12:39:07 +0200
Message-ID: <CA+icZUW+Gp9HK-6dzHjtTwSc9RaLD3sV+WPMM-vO3A6fj6frwQ@mail.gmail.com>
Subject: Re: linux-next: Tree for July 17 (mfd: AB3100 - ab3100_probe:
 undefined reference to `rand_initialize_irq')
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: multipart/mixed; boundary=bcaec55407c0fb9aab04c50427f1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec55407c0fb9aab04c50427f1
Content-Type: text/plain; charset=UTF-8

On Tue, Jul 17, 2012 at 12:21 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Jul 17, 2012 at 11:47 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Tue, Jul 17, 2012 at 7:41 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi all,
>>>
>>> Changes since 20120716:
>>>
>>> The vfs tree lost its build failure.
>>>
>>> The l2-mtd tree gained a conflict against the mtd tree.
>>>
>>> The battery tree tree lost its build failure.
>>>
>>> The regulator tree gained conflicts against the mfd tree.
>>>
>>> The tty tree lost its build failure but gained another, so I used the
>>> version from next-20120712.
>>>
>>> I have still reverted 3 commits from the signal tree at the request of the
>>> arm maintainer.
>>>
>>> The akpm tree lost a few patches that turned up elsewhere.
>>>
>>
>> From my today's build-log on a Ubuntu/precise AMD64 host:
>> [...]
>>   LD      drivers/video/built-in.o
>>   LD      drivers/built-in.o
>>   LINK    vmlinux
>>   LD      vmlinux.o
>>   MODPOST vmlinux.o
>>   GEN     .version
>>   CHK     include/generated/compile.h
>>   UPD     include/generated/compile.h
>>   CC      init/version.o
>>   LD      init/built-in.o
>> drivers/built-in.o: In function `ab3100_probe':
>> ab3100-core.c:(.devinit.text+0xbf97): undefined reference to
>> `rand_initialize_irq'
>> make[2]: *** [vmlinux] Error 1
>> make[1]: *** [deb-pkg] Error 2
>> make: *** [deb-pkg] Error 2
>>
>> MFD / AB3100 kernel-config settings:
>>
>> CONFIG_AB3100_CORE=y
>> CONFIG_AB3100_OTP=m
>> CONFIG_REGULATOR_AB3100=m
>> CONFIG_RTC_DRV_AB3100=m
>>
>> If you need further informations, please let me know.
>>
>> - Sedat -
>
> [ CC Ted (new random maintainer) ]
>
> Is this due to this change?
>
> From 946672f548682905d8ecdab33bb6e2c705418505 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Sat, 14 Jul 2012 20:27:52 -0400
> Subject: [PATCH] random: remove rand_initialize_irq()
>
> With the new interrupt sampling system, we are no longer using the
> timer_rand_state structure in the irq descriptor, so we can stop
> initializing it now.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu
>
> ...looks like AB3100 is the *only* driver still using rand_initialize_irq()...
>
> drivers/mfd/ab3100-core.c:939:  rand_initialize_irq(client->irq);
>
> ...but why has random.h still this...?
>
> include/linux/random.h:51:extern void rand_initialize_irq(int irq);
>
> Just thinking "loud"...
>
> - Sedat -

Is this attached patch OK, Ted?

- Sedat -

--bcaec55407c0fb9aab04c50427f1
Content-Type: application/octet-stream; 
	name="0001-random-remove-remaining-relicts-of-rand_initialize_i.patch"
Content-Disposition: attachment; 
	filename="0001-random-remove-remaining-relicts-of-rand_initialize_i.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h4qun3y10

RnJvbSA0OWQwMWNlMTc0MjJlYWUxYmQ1NjUzMWE2YmFhYTZkYWQxZmI1OTJmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDE3IEp1bCAyMDEyIDEyOjMwOjE4ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gcmFu
ZG9tOiByZW1vdmUgcmVtYWluaW5nIHJlbGljdHMgb2YgcmFuZF9pbml0aWFsaXplX2lycSgpCgpy
YW5kX2luaXRpYWxpemVfaXJxKCkgd2FzIHJlbW92ZWQgaGVyZToKCmNvbW1pdCA5NDY2NzJmNTQ4
NjgyOTA1ZDhlY2RhYjMzYmI2ZTJjNzA1NDE4NTA1CiJyYW5kb206IHJlbW92ZSByYW5kX2luaXRp
YWxpemVfaXJxKCkiCgpBQjMxMDAgbWZkLWRyaXZlciBpcyB0aGUgb25seSBkcml2ZXIgdXNpbmcg
aXQgYW5kIGJyZWFrcyB3aXRoCnRoZXNlIGVycm9yLW1lc3NhZ2VkIGluIGxpbnV4LW5leHQgKG5l
eHQtMjAxMjA3MTcpOgouLi4KZHJpdmVycy9idWlsdC1pbi5vOiBJbiBmdW5jdGlvbiBgYWIzMTAw
X3Byb2JlJzoKYWIzMTAwLWNvcmUuYzooLmRldmluaXQudGV4dCsweGJmOTcpOiB1bmRlZmluZWQg
cmVmZXJlbmNlIHRvIGByYW5kX2luaXRpYWxpemVfaXJxJwoKRml4IHRoaXMgYW5kIHJlbW92ZSBh
bGwgcmVtYWluaW5nIHJlbGljdHMgb2YgcmFuZF9pbml0aWFsaXplX2lycSgpLgoKU2lnbmVkLW9m
Zi1ieTogU2VkYXQgRGlsZWsgPHNlZGF0LmRpbGVrQGdtYWlsLmNvbT4KLS0tCiBhcmNoL2lhNjQv
a2VybmVsL2lycV9pYTY0LmMgfCAgICAxIC0KIGRyaXZlcnMvbWZkL2FiMzEwMC1jb3JlLmMgICB8
ICAgIDIgLS0KIGluY2x1ZGUvbGludXgvcmFuZG9tLmggICAgICB8ICAgIDIgLS0KIDMgZmlsZXMg
Y2hhbmdlZCwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2lhNjQva2VybmVsL2ly
cV9pYTY0LmMgYi9hcmNoL2lhNjQva2VybmVsL2lycV9pYTY0LmMKaW5kZXggNWMzZTA4OC4uMTAz
NDg4NCAxMDA2NDQKLS0tIGEvYXJjaC9pYTY0L2tlcm5lbC9pcnFfaWE2NC5jCisrKyBiL2FyY2gv
aWE2NC9rZXJuZWwvaXJxX2lhNjQuYwpAQCAtMjMsNyArMjMsNiBAQAogI2luY2x1ZGUgPGxpbnV4
L2lvcG9ydC5oPgogI2luY2x1ZGUgPGxpbnV4L2tlcm5lbF9zdGF0Lmg+CiAjaW5jbHVkZSA8bGlu
dXgvcHRyYWNlLmg+Ci0jaW5jbHVkZSA8bGludXgvcmFuZG9tLmg+CS8qIGZvciByYW5kX2luaXRp
YWxpemVfaXJxKCkgKi8KICNpbmNsdWRlIDxsaW51eC9zaWduYWwuaD4KICNpbmNsdWRlIDxsaW51
eC9zbXAuaD4KICNpbmNsdWRlIDxsaW51eC90aHJlYWRzLmg+CmRpZmYgLS1naXQgYS9kcml2ZXJz
L21mZC9hYjMxMDAtY29yZS5jIGIvZHJpdmVycy9tZmQvYWIzMTAwLWNvcmUuYwppbmRleCBlNzk5
MDUwLi43OGZjYTI5IDEwMDY0NAotLS0gYS9kcml2ZXJzL21mZC9hYjMxMDAtY29yZS5jCisrKyBi
L2RyaXZlcnMvbWZkL2FiMzEwMC1jb3JlLmMKQEAgLTkzNCw4ICs5MzQsNiBAQCBzdGF0aWMgaW50
IF9fZGV2aW5pdCBhYjMxMDBfcHJvYmUoc3RydWN0IGkyY19jbGllbnQgKmNsaWVudCwKIAkJCQkJ
SVJRRl9PTkVTSE9ULCAiYWIzMTAwLWNvcmUiLCBhYjMxMDApOwogCWlmIChlcnIpCiAJCWdvdG8g
ZXhpdF9ub19pcnE7Ci0JLyogVGhpcyByZWFsIHVucHJlZGljdGFibGUgSVJRIGlzIG9mIGNvdXJz
ZSBzYW1wbGVkIGZvciBlbnRyb3B5ICovCi0JcmFuZF9pbml0aWFsaXplX2lycShjbGllbnQtPmly
cSk7CiAKIAllcnIgPSBhYng1MDBfcmVnaXN0ZXJfb3BzKCZjbGllbnQtPmRldiwgJmFiMzEwMF9v
cHMpOwogCWlmIChlcnIpCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3JhbmRvbS5oIGIvaW5j
bHVkZS9saW51eC9yYW5kb20uaAppbmRleCAyOWUyMTdhLi5hYzYyMWNlIDEwMDY0NAotLS0gYS9p
bmNsdWRlL2xpbnV4L3JhbmRvbS5oCisrKyBiL2luY2x1ZGUvbGludXgvcmFuZG9tLmgKQEAgLTQ4
LDggKzQ4LDYgQEAgc3RydWN0IHJuZF9zdGF0ZSB7CiAKICNpZmRlZiBfX0tFUk5FTF9fCiAKLWV4
dGVybiB2b2lkIHJhbmRfaW5pdGlhbGl6ZV9pcnEoaW50IGlycSk7Ci0KIGV4dGVybiB2b2lkIGFk
ZF9kZXZpY2VfcmFuZG9tbmVzcyhjb25zdCB2b2lkICosIHVuc2lnbmVkIGludCk7CiBleHRlcm4g
dm9pZCBhZGRfaW5wdXRfcmFuZG9tbmVzcyh1bnNpZ25lZCBpbnQgdHlwZSwgdW5zaWduZWQgaW50
IGNvZGUsCiAJCQkJIHVuc2lnbmVkIGludCB2YWx1ZSk7Ci0tIAoxLjcuOS41Cgo=
--bcaec55407c0fb9aab04c50427f1--
