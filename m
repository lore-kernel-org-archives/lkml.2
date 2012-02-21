Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2BUCKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:10:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44768 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2BUCKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:10:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.216.135.15 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Feb 2012 18:10:29 -0800
X-Google-Sender-Auth: UNGVEw_HrU0T5lVaSM-96-8SCNU
Message-ID: <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
To: Josh Boyer <jwboyer@gmail.com>, Jongman Heo <jongman.heo@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e6d99d2d70187004b96febe2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d99d2d70187004b96febe2
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Feb 20, 2012 at 5:50 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>
> I haven't tried really figuring this out yet, but building the Fedora kernel
> on x86_64 with your latest tree results in:
>
> ERROR: "fpu_owner_task" [lib/raid6/raid6_pq.ko] undefined!

Ugh. My dislike of modules on my machines strikes again, and
apparently nobody else tested the patches I sent out.

The attached trivial patch fixes it, I bet.

Although I do wonder if we should just make kernel_fpu_begin() be a
real function instead of inlining it. I'm not sure it makes sense to
inline that thing, and it might be better to export that one instead.
Comments?

                     Linus

--0016e6d99d2d70187004b96febe2
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gywar8oi0

IGFyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMgfCAgICAxICsKIDEgZmlsZXMgY2hhbmdlZCwg
MSBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tl
cm5lbC9jcHUvY29tbW9uLmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jCmluZGV4IGI2
NjcxNDhkZmFkNy4uMjYyNTVjNjYxMWE0IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1
L2NvbW1vbi5jCisrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMKQEAgLTEwNDUsNiAr
MTA0NSw3IEBAIERFRklORV9QRVJfQ1BVKGNoYXIgKiwgaXJxX3N0YWNrX3B0cikgPQogREVGSU5F
X1BFUl9DUFUodW5zaWduZWQgaW50LCBpcnFfY291bnQpID0gLTE7CiAKIERFRklORV9QRVJfQ1BV
KHN0cnVjdCB0YXNrX3N0cnVjdCAqLCBmcHVfb3duZXJfdGFzayk7CitFWFBPUlRfUEVSX0NQVV9T
WU1CT0woZnB1X293bmVyX3Rhc2spOwogCiAvKgogICogU3BlY2lhbCBJU1Qgc3RhY2tzIHdoaWNo
IHRoZSBDUFUgc3dpdGNoZXMgdG8gd2hlbiBpdCBjYWxscwo=
--0016e6d99d2d70187004b96febe2--
