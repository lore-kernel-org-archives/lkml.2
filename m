Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2BUCTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:19:08 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56758 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2BUCTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:19:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.101.37 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org>
 <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com> <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Feb 2012 18:18:45 -0800
X-Google-Sender-Auth: KTIVo2vToaU6UX07mI4zrBbyZBI
Message-ID: <CA+55aFzottbJCxhh+qJnhk=yZ3Rjf=0ndn7vVvvcjWrBSthEYg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
To: Josh Boyer <jwboyer@gmail.com>, Jongman Heo <jongman.heo@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d04428158ff846c04b9700813
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04428158ff846c04b9700813
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Feb 20, 2012 at 6:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The attached trivial patch fixes it, I bet.

Actually, it doesn't fix it on x86-32, because we actually have an
#ifdef CONFIG_X86_64 around the "current_task" definition due to
pointless differences in how we do that on x86-64 and x86-32.

So much for the "common" part of "arch/x86/kernel/cpu/common.c"

> Although I do wonder if we should just make kernel_fpu_begin() be a
> real function instead of inlining it. I'm not sure it makes sense to
> inline that thing, and it might be better to export that one instead.

I do think that would be better in the long run, but for now here's an
updated "trivial" patch to fix it.

I want the fpu_owner_task to be declared next to the cache-hot
task-switching stuff, and since they are different on 32-bit and
64-bit (for no really good reason), that gets duplicated too. Sad.

                        Linus

                      Linus

--f46d04428158ff846c04b9700813
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gywb22fq1

IGFyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMgfCAgICAzICsrKwogMSBmaWxlcyBjaGFuZ2Vk
LCAzIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a2VybmVsL2NwdS9jb21tb24uYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMKaW5kZXgg
YjY2NzE0OGRmYWQ3Li5jMGY3ZDY4ZDMxOGYgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9j
cHUvY29tbW9uLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYwpAQCAtMTA0NSw2
ICsxMDQ1LDcgQEAgREVGSU5FX1BFUl9DUFUoY2hhciAqLCBpcnFfc3RhY2tfcHRyKSA9CiBERUZJ
TkVfUEVSX0NQVSh1bnNpZ25lZCBpbnQsIGlycV9jb3VudCkgPSAtMTsKIAogREVGSU5FX1BFUl9D
UFUoc3RydWN0IHRhc2tfc3RydWN0ICosIGZwdV9vd25lcl90YXNrKTsKK0VYUE9SVF9QRVJfQ1BV
X1NZTUJPTChmcHVfb3duZXJfdGFzayk7CiAKIC8qCiAgKiBTcGVjaWFsIElTVCBzdGFja3Mgd2hp
Y2ggdGhlIENQVSBzd2l0Y2hlcyB0byB3aGVuIGl0IGNhbGxzCkBAIC0xMTEzLDYgKzExMTQsOCBA
QCB2b2lkIGRlYnVnX3N0YWNrX3Jlc2V0KHZvaWQpCiAKIERFRklORV9QRVJfQ1BVKHN0cnVjdCB0
YXNrX3N0cnVjdCAqLCBjdXJyZW50X3Rhc2spID0gJmluaXRfdGFzazsKIEVYUE9SVF9QRVJfQ1BV
X1NZTUJPTChjdXJyZW50X3Rhc2spOworREVGSU5FX1BFUl9DUFUoc3RydWN0IHRhc2tfc3RydWN0
ICosIGZwdV9vd25lcl90YXNrKTsKK0VYUE9SVF9QRVJfQ1BVX1NZTUJPTChmcHVfb3duZXJfdGFz
ayk7CiAKICNpZmRlZiBDT05GSUdfQ0NfU1RBQ0tQUk9URUNUT1IKIERFRklORV9QRVJfQ1BVX0FM
SUdORUQoc3RydWN0IHN0YWNrX2NhbmFyeSwgc3RhY2tfY2FuYXJ5KTsK
--f46d04428158ff846c04b9700813--
