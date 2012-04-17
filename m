Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab2DQBmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 21:42:12 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44113 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2DQBmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 21:42:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com>
References: <4F6A483D.50702@fold.natur.cuni.cz>
	<CAE9FiQVnErU-cska4gpinyj-LOup-U+3vsEG2z_-7h6kyREYtw@mail.gmail.com>
	<4F6A5A53.305@fold.natur.cuni.cz>
	<CAE9FiQXP7fO9OGN557jdofFFiFj96wL--ZA8X3UPEJ6o9JLvBw@mail.gmail.com>
	<4F8BEB1D.9080903@fold.natur.cuni.cz>
	<CAE9FiQXoX3J6P_9Tun_XbkK3egvSeBZxAtC13HacFDO0fwmZaA@mail.gmail.com>
	<4F8C6E4E.1000205@fold.natur.cuni.cz>
	<CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com>
Date: Mon, 16 Apr 2012 18:42:09 -0700
X-Google-Sender-Auth: aIQO-zWM-3tcwsAXUunjjM21R6U
Message-ID: <CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b10ce0313b10d04bdd60c08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b10ce0313b10d04bdd60c08
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 16, 2012 at 1:53 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Apr 16, 2012 at 12:09 PM, Martin Mokrejs
> <mmokrejs@fold.natur.cuni.cz> wrote:
>>>>> On Wed, Mar 21, 2012 at 3:46 PM, Martin Mokrejs
>>>> =A0 I had some Ooopses with 3.4-rc2 but now I have tested 3.4-rc3. Sti=
ll, linux
>>>> does NOT realize that I have removed an ExpressCard from the slot. It =
realizes
>>>> that only when I pluging the card back again. Actually, this is a case=
 of a
>>>> NEC chipset base USB3.0 card.
>>>>
>>>> =A0In contrast, kernel DOES recognize that I unplugged a FireWire card=
 from the
>>>> same slot.
>>>>
>>>> =A0This is a Dell Vostro 3550 laptop. Below is what syslog logged with=
 my comment.
>>>> Empty lines between the log entries are inserted whe I either inserted=
 or removed
>>>> a card. Probably a bit more will be in the attached dmesg file.
>
> so the interrupt for removal get generated, but pcie_isr() is delayed
> when another surprise is generated...
>

please try to revert
commit 486b10b9f43500741cd63a878d0ef23cd87fc66d
Author: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Date:   Mon Nov 7 20:56:50 2011 +0900

    PCI: pciehp: Handle push button event asynchronously

    Use non-ordered workqueue for attention button events.

    Attention button events on each slot can be handled asynchronously. So
    we should use non-ordered workqueue. This patch also removes ordered
    workqueue in pciehp as a result.

to see if there is any difference.

Yinghai

--047d7b10ce0313b10d04bdd60c08
Content-Type: application/octet-stream; name=commit-486b10b
Content-Disposition: attachment; filename=commit-486b10b
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h14ae4np0

Y29tbWl0IDQ4NmIxMGI5ZjQzNTAwNzQxY2Q2M2E4NzhkMGVmMjNjZDg3ZmM2NmQKQXV0aG9yOiBL
ZW5qaSBLYW5lc2hpZ2UgPGthbmVzaGlnZS5rZW5qaUBqcC5mdWppdHN1LmNvbT4KRGF0ZTogICBN
b24gTm92IDcgMjA6NTY6NTAgMjAxMSArMDkwMAoKICAgIFBDSTogcGNpZWhwOiBIYW5kbGUgcHVz
aCBidXR0b24gZXZlbnQgYXN5bmNocm9ub3VzbHkKICAgIAogICAgVXNlIG5vbi1vcmRlcmVkIHdv
cmtxdWV1ZSBmb3IgYXR0ZW50aW9uIGJ1dHRvbiBldmVudHMuCiAgICAKICAgIEF0dGVudGlvbiBi
dXR0b24gZXZlbnRzIG9uIGVhY2ggc2xvdCBjYW4gYmUgaGFuZGxlZCBhc3luY2hyb25vdXNseS4g
U28KICAgIHdlIHNob3VsZCB1c2Ugbm9uLW9yZGVyZWQgd29ya3F1ZXVlLiBUaGlzIHBhdGNoIGFs
c28gcmVtb3ZlcyBvcmRlcmVkCiAgICB3b3JrcXVldWUgaW4gcGNpZWhwIGFzIGEgcmVzdWx0Lgog
ICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBLZW5qaSBLYW5lc2hpZ2UgPGthbmVzaGlnZS5rZW5qaUBq
cC5mdWppdHN1LmNvbT4KICAgIFNpZ25lZC1vZmYtYnk6IEplc3NlIEJhcm5lcyA8amJhcm5lc0B2
aXJ0dW91c2dlZWsub3JnPgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL2hvdHBsdWcvcGNpZWhw
LmggYi9kcml2ZXJzL3BjaS9ob3RwbHVnL3BjaWVocC5oCmluZGV4IDgzOGY1NzEuLjlhMzNmZGQg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNpL2hvdHBsdWcvcGNpZWhwLmgKKysrIGIvZHJpdmVycy9w
Y2kvaG90cGx1Zy9wY2llaHAuaApAQCAtNDUsNyArNDUsNiBAQCBleHRlcm4gaW50IHBjaWVocF9w
b2xsX3RpbWU7CiBleHRlcm4gaW50IHBjaWVocF9kZWJ1ZzsKIGV4dGVybiBpbnQgcGNpZWhwX2Zv
cmNlOwogZXh0ZXJuIHN0cnVjdCB3b3JrcXVldWVfc3RydWN0ICpwY2llaHBfd3E7Ci1leHRlcm4g
c3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QgKnBjaWVocF9vcmRlcmVkX3dxOwogCiAjZGVmaW5lIGRi
Zyhmb3JtYXQsIGFyZy4uLikJCQkJCQlcCiBkbyB7CQkJCQkJCQkJXApkaWZmIC0tZ2l0IGEvZHJp
dmVycy9wY2kvaG90cGx1Zy9wY2llaHBfY29yZS5jIGIvZHJpdmVycy9wY2kvaG90cGx1Zy9wY2ll
aHBfY29yZS5jCmluZGV4IGExM2FkMTMuLmI4Yzk5ZDMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNp
L2hvdHBsdWcvcGNpZWhwX2NvcmUuYworKysgYi9kcml2ZXJzL3BjaS9ob3RwbHVnL3BjaWVocF9j
b3JlLmMKQEAgLTQzLDcgKzQzLDYgQEAgaW50IHBjaWVocF9wb2xsX21vZGU7CiBpbnQgcGNpZWhw
X3BvbGxfdGltZTsKIGludCBwY2llaHBfZm9yY2U7CiBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdCAq
cGNpZWhwX3dxOwotc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QgKnBjaWVocF9vcmRlcmVkX3dxOwog
CiAjZGVmaW5lIERSSVZFUl9WRVJTSU9OCSIwLjQiCiAjZGVmaW5lIERSSVZFUl9BVVRIT1IJIkRh
biBaaW5rIDxkYW4uemlua0Bjb21wYXEuY29tPiwgR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVnQGty
b2FoLmNvbT4sIERlbHkgU3kgPGRlbHkubC5zeUBpbnRlbC5jb20+IgpAQCAtMzQ1LDE4ICszNDQs
MTEgQEAgc3RhdGljIGludCBfX2luaXQgcGNpZWRfaW5pdCh2b2lkKQogCWlmICghcGNpZWhwX3dx
KQogCQlyZXR1cm4gLUVOT01FTTsKIAotCXBjaWVocF9vcmRlcmVkX3dxID0gYWxsb2Nfb3JkZXJl
ZF93b3JrcXVldWUoInBjaWVocF9vcmRlcmVkIiwgMCk7Ci0JaWYgKCFwY2llaHBfb3JkZXJlZF93
cSkgewotCQlkZXN0cm95X3dvcmtxdWV1ZShwY2llaHBfd3EpOwotCQlyZXR1cm4gLUVOT01FTTsK
LQl9Ci0KIAlwY2llaHBfZmlybXdhcmVfaW5pdCgpOwogCXJldHZhbCA9IHBjaWVfcG9ydF9zZXJ2
aWNlX3JlZ2lzdGVyKCZocGRyaXZlcl9wb3J0ZHJ2KTsKICAJZGJnKCJwY2llX3BvcnRfc2Vydmlj
ZV9yZWdpc3RlciA9ICVkXG4iLCByZXR2YWwpOwogICAJaW5mbyhEUklWRVJfREVTQyAiIHZlcnNp
b246ICIgRFJJVkVSX1ZFUlNJT04gIlxuIik7CiAgCWlmIChyZXR2YWwpIHsKLQkJZGVzdHJveV93
b3JrcXVldWUocGNpZWhwX29yZGVyZWRfd3EpOwogCQlkZXN0cm95X3dvcmtxdWV1ZShwY2llaHBf
d3EpOwogCQlkYmcoIkZhaWx1cmUgdG8gcmVnaXN0ZXIgc2VydmljZVxuIik7CiAJfQpAQCAtMzY3
LDcgKzM1OSw2IEBAIHN0YXRpYyB2b2lkIF9fZXhpdCBwY2llZF9jbGVhbnVwKHZvaWQpCiB7CiAJ
ZGJnKCJ1bmxvYWRfcGNpZWhwZCgpXG4iKTsKIAlwY2llX3BvcnRfc2VydmljZV91bnJlZ2lzdGVy
KCZocGRyaXZlcl9wb3J0ZHJ2KTsKLQlkZXN0cm95X3dvcmtxdWV1ZShwY2llaHBfb3JkZXJlZF93
cSk7CiAJZGVzdHJveV93b3JrcXVldWUocGNpZWhwX3dxKTsKIAlpbmZvKERSSVZFUl9ERVNDICIg
dmVyc2lvbjogIiBEUklWRVJfVkVSU0lPTiAiIHVubG9hZGVkXG4iKTsKIH0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvcGNpL2hvdHBsdWcvcGNpZWhwX2N0cmwuYyBiL2RyaXZlcnMvcGNpL2hvdHBsdWcv
cGNpZWhwX2N0cmwuYwppbmRleCAwODVkYmI1Li4yN2Y0NDI5IDEwMDY0NAotLS0gYS9kcml2ZXJz
L3BjaS9ob3RwbHVnL3BjaWVocF9jdHJsLmMKKysrIGIvZHJpdmVycy9wY2kvaG90cGx1Zy9wY2ll
aHBfY3RybC5jCkBAIC0zNDQsNyArMzQ0LDcgQEAgdm9pZCBwY2llaHBfcXVldWVfcHVzaGJ1dHRv
bl93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkJa2ZyZWUoaW5mbyk7CiAJCWdvdG8g
b3V0OwogCX0KLQlxdWV1ZV93b3JrKHBjaWVocF9vcmRlcmVkX3dxLCAmaW5mby0+d29yayk7CisJ
cXVldWVfd29yayhwY2llaHBfd3EsICZpbmZvLT53b3JrKTsKICBvdXQ6CiAJbXV0ZXhfdW5sb2Nr
KCZwX3Nsb3QtPmxvY2spOwogfQpAQCAtNDM5LDcgKzQzOSw3IEBAIHN0YXRpYyB2b2lkIGhhbmRs
ZV9zdXJwcmlzZV9ldmVudChzdHJ1Y3Qgc2xvdCAqcF9zbG90KQogCWVsc2UKIAkJcF9zbG90LT5z
dGF0ZSA9IFBPV0VST05fU1RBVEU7CiAKLQlxdWV1ZV93b3JrKHBjaWVocF9vcmRlcmVkX3dxLCAm
aW5mby0+d29yayk7CisJcXVldWVfd29yayhwY2llaHBfd3EsICZpbmZvLT53b3JrKTsKIH0KIAog
c3RhdGljIHZvaWQgaW50ZXJydXB0X2V2ZW50X2hhbmRsZXIoc3RydWN0IHdvcmtfc3RydWN0ICp3
b3JrKQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wY2kvaG90cGx1Zy9wY2llaHBfaHBjLmMgYi9kcml2
ZXJzL3BjaS9ob3RwbHVnL3BjaWVocF9ocGMuYwppbmRleCA3YjE0MTQ4Li5iY2RiYjE2IDEwMDY0
NAotLS0gYS9kcml2ZXJzL3BjaS9ob3RwbHVnL3BjaWVocF9ocGMuYworKysgYi9kcml2ZXJzL3Bj
aS9ob3RwbHVnL3BjaWVocF9ocGMuYwpAQCAtODA2LDcgKzgwNiw2IEBAIHN0YXRpYyB2b2lkIHBj
aWVfY2xlYW51cF9zbG90KHN0cnVjdCBjb250cm9sbGVyICpjdHJsKQogCXN0cnVjdCBzbG90ICpz
bG90ID0gY3RybC0+c2xvdDsKIAljYW5jZWxfZGVsYXllZF93b3JrKCZzbG90LT53b3JrKTsKIAlm
bHVzaF93b3JrcXVldWUocGNpZWhwX3dxKTsKLQlmbHVzaF93b3JrcXVldWUocGNpZWhwX29yZGVy
ZWRfd3EpOwogCWtmcmVlKHNsb3QpOwogfQogCg==
--047d7b10ce0313b10d04bdd60c08--
