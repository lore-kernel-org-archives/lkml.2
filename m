Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab0IFSxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:53:49 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35960 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755Ab0IFSxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:53:42 -0400
Message-Id: <1283799222.15941.1393621887@webmail.messagingengine.com>
X-Sasl-Enc: yw5BawFJ3IELIlk/B1boGvzuotRetUae+bVtxbK35RJC 1283799222
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>, mingo@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        hch@lst.de, "Thomas Gleixner" <tglx@linutronix.de>
Cc: linux-tip-commits@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_1283799222159410"
X-Mailer: MessagingEngine.com Webmail Interface
References: <20100628121554.GA6605@lst.de><tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org><20100903150041.GA30573@elte.hu>
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
In-Reply-To: <20100903150041.GA30573@elte.hu>
Date: Mon, 06 Sep 2010 20:53:42 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--_----------=_1283799222159410
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 6 Sep 2010 14:53:42 -0400
X-Mailer: MessagingEngine.com Webmail Interface

On Fri, 03 Sep 2010 17:00 +0200, "Ingo Molnar" <mingo@elte.hu> wrote:
> 
> * tip-bot for Christoph Hellwig <hch@lst.de> wrote:
> 
> > Commit-ID:  7974891db234467eaf1fec613ec0129cb4ac2332
> > Gitweb:     http://git.kernel.org/tip/7974891db234467eaf1fec613ec0129cb4ac2332
> > Author:     Christoph Hellwig <hch@lst.de>
> > AuthorDate: Mon, 28 Jun 2010 14:15:54 +0200
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Tue, 29 Jun 2010 12:12:59 +0200
> > 
> > x86: Always use irq stacks
>
> [...]
> 
> Checking out 7974891db2 and building+booting a kernel with this config 
> causes shows the crash.
> 
> Checking out 7974891db2~1 and building+booting a kernel with this config 
> gives a working system.
> 
> Note that tip:x86/irq has these commits currently:
> 
>  1813a68: x86: Move alloc_desk_mask variables inside ifdef
>  2589737: x86-32: Align IRQ stacks properly
>  dcfa726: x86: Remove CONFIG_4KSTACKS
>  7974891: x86: Always use irq stacks

Hello Ingo, Christoph, ...

There is still a problem with the alignment of the irq stacks. Maybe it's only
theoretical, but I think the attached patch is necessary. (Attached because
I'm sending it via a web interface.)

Please test and apply :).

Greetings,
    Alexander

> Thanks,
> 
> 	Ingo
> 


--_----------=_1283799222159410
MIME-Version: 1.0
Content-Disposition: attachment; filename="0001-i386-Align-percpu-area-and-irq-stacks-to-THREAD_SIZE.patch"
Content-Id: <FKSWVDsHRRq3WOZnS3t3KWNUZdM@messagingengine.com>
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="0001-i386-Align-percpu-area-and-irq-stacks-to-THREAD_SIZE.patch"
X-Mailer: MIME::Lite 3.021 (F2.76; T1.24; A2.03; B3.07_01; Q3.07)
Date: Mon, 6 Sep 2010 14:53:42 -0400

RnJvbSAxMDMxZGE0OGE4OWFhNDM3MTk5YWY1ODExNjljNjUyNjhmOWJkYmFh
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4YW5kZXIgdmFu
IEhldWtlbHVtIDxoZXVrZWx1bUBmYXN0bWFpbC5mbT4KRGF0ZTogTW9uLCA2
IFNlcCAyMDEwIDIwOjE1OjA1ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gaTM4
NjogQWxpZ24gcGVyY3B1IGFyZWEgYW5kIGlycSBzdGFja3MgdG8gVEhSRUFE
X1NJWkUKClRoZSBpcnEgc3RhY2tzLCBsb2NhdGVkIGluIHRoZSBwZXJjcHUt
YXJlYSwgbmVlZCB0byBiZSBUSFJFQURfU0laRSBhbGlnbmVkLiBBZGQKdGhl
IGluZnJhc3R1Y3R1cmUgdG8gYWxpZ24gcGVyY3B1IHZhcmlhYmxlcyB0byBs
YXJnZXItdGhhbi1wYWdlc2l6ZSBhbW91bnRzIHdpdGhpbgp0aGUgcGVyY3B1
IGFyZWEsIGFuZCB1c2UgaXQgdG8gc3BlY2lmeSB0aGUgYWxpZ25tZW50IGZv
ciB0aGUgaXJxIHN0YWNrcy4gQWxzbwphbGlnbiB0aGUgcGVyY3B1IGFyZWEg
aXRzZWxmIHRvIFRIUkVBRF9TSVpFLgoKVGhpcyBzaG91bGQgbWFrZSBpcnEg
c3RhY2tzIHdvcmsgd2l0aCA4SyBUSFJFQURfU0laRS4KClNpZ25lZC1vZmYt
Ynk6IEFsZXhhbmRlciB2YW4gSGV1a2VsdW0gPGhldWtlbHVtQGZhc3RtYWls
LmZtPgotLS0KIGFyY2gveDg2L2tlcm5lbC9pcnFfMzIuYyAgICAgIHwgICAg
NiArKysrLS0KIGFyY2gveDg2L2tlcm5lbC92bWxpbnV4Lmxkcy5TIHwgICAg
MiArLQogaW5jbHVkZS9saW51eC9wZXJjcHUtZGVmcy5oICAgfCAgIDEyICsr
KysrKysrKysrKwogMyBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCsp
LCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5l
bC9pcnFfMzIuYyBiL2FyY2gveDg2L2tlcm5lbC9pcnFfMzIuYwppbmRleCAz
YjU2MDlmLi5kYjdlYmU2IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwv
aXJxXzMyLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2lycV8zMi5jCkBAIC02
MCw4ICs2MCwxMCBAQCB1bmlvbiBpcnFfY3R4IHsKIHN0YXRpYyBERUZJTkVf
UEVSX0NQVSh1bmlvbiBpcnFfY3R4ICosIGhhcmRpcnFfY3R4KTsKIHN0YXRp
YyBERUZJTkVfUEVSX0NQVSh1bmlvbiBpcnFfY3R4ICosIHNvZnRpcnFfY3R4
KTsKIAotc3RhdGljIERFRklORV9QRVJfQ1BVX1BBR0VfQUxJR05FRCh1bmlv
biBpcnFfY3R4LCBoYXJkaXJxX3N0YWNrKTsKLXN0YXRpYyBERUZJTkVfUEVS
X0NQVV9QQUdFX0FMSUdORUQodW5pb24gaXJxX2N0eCwgc29mdGlycV9zdGFj
ayk7CitzdGF0aWMgREVGSU5FX1BFUl9DUFVfTVVMVElQQUdFX0FMSUdORUQo
dW5pb24gaXJxX2N0eCwKKwkJIGhhcmRpcnFfc3RhY2ssIFRIUkVBRF9TSVpF
KTsKK3N0YXRpYyBERUZJTkVfUEVSX0NQVV9NVUxUSVBBR0VfQUxJR05FRCh1
bmlvbiBpcnFfY3R4LAorCQlzb2Z0aXJxX3N0YWNrLCBUSFJFQURfU0laRSk7
CiAKIHN0YXRpYyB2b2lkIGNhbGxfb25fc3RhY2sodm9pZCAqZnVuYywgdm9p
ZCAqc3RhY2spCiB7CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvdm1s
aW51eC5sZHMuUyBiL2FyY2gveDg2L2tlcm5lbC92bWxpbnV4Lmxkcy5TCmlu
ZGV4IGQwYmI1MjIuLmJiODk5NDcgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tl
cm5lbC92bWxpbnV4Lmxkcy5TCisrKyBiL2FyY2gveDg2L2tlcm5lbC92bWxp
bnV4Lmxkcy5TCkBAIC0yNzMsNyArMjczLDcgQEAgU0VDVElPTlMKIAl9CiAK
ICNpZiAhZGVmaW5lZChDT05GSUdfWDg2XzY0KSB8fCAhZGVmaW5lZChDT05G
SUdfU01QKQotCVBFUkNQVShQQUdFX1NJWkUpCisJUEVSQ1BVKFRIUkVBRF9T
SVpFKQogI2VuZGlmCiAKIAkuID0gQUxJR04oUEFHRV9TSVpFKTsKZGlmZiAt
LWdpdCBhL2luY2x1ZGUvbGludXgvcGVyY3B1LWRlZnMuaCBiL2luY2x1ZGUv
bGludXgvcGVyY3B1LWRlZnMuaAppbmRleCBjZTJkYzY1Li5hYjIwZDExIDEw
MDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L3BlcmNwdS1kZWZzLmgKKysrIGIv
aW5jbHVkZS9saW51eC9wZXJjcHUtZGVmcy5oCkBAIC0xMzksNiArMTM5LDE4
IEBACiAJX19hbGlnbmVkKFBBR0VfU0laRSkKIAogLyoKKyAqIERlY2xhcmF0
aW9uL2RlZmluaXRpb24gdXNlZCBmb3IgbGFyZ2UgcGVyLUNQVSB2YXJpYWJs
ZXMgdGhhdCBtdXN0IGJlCisgKiBhbGlnbmVkIHRvIHNvbWV0aGluZyBsYXJn
ZXIgdGhhbiB0aGUgcGFnZXNpemUuCisgKi8KKyNkZWZpbmUgREVDTEFSRV9Q
RVJfQ1BVX01VTFRJUEFHRV9BTElHTkVEKHR5cGUsIG5hbWUsIHNpemUpCQlc
CisJREVDTEFSRV9QRVJfQ1BVX1NFQ1RJT04odHlwZSwgbmFtZSwgIi4ucGFn
ZV9hbGlnbmVkIikJCVwKKwlfX2FsaWduZWQoc2l6ZSkKKworI2RlZmluZSBE
RUZJTkVfUEVSX0NQVV9NVUxUSVBBR0VfQUxJR05FRCh0eXBlLCBuYW1lLCBz
aXplKQkJXAorCURFRklORV9QRVJfQ1BVX1NFQ1RJT04odHlwZSwgbmFtZSwg
Ii4ucGFnZV9hbGlnbmVkIikJCVwKKwlfX2FsaWduZWQoc2l6ZSkKKworLyoK
ICAqIEludGVybW9kdWxlIGV4cG9ydHMgZm9yIHBlci1DUFUgdmFyaWFibGVz
LiAgc3BhcnNlIGZvcmdldHMgYWJvdXQKICAqIGFkZHJlc3Mgc3BhY2UgYWNy
b3NzIEVYUE9SVF9TWU1CT0woKSwgY2hhbmdlIEVYUE9SVF9TWU1CT0woKSB0
bwogICogbm9vcCBpZiBfX0NIRUNLRVJfXy4KLS0gCjEuNy4xCgo=

--_----------=_1283799222159410--

