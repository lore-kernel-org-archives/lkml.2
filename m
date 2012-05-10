Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2EJP6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:58:45 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44289 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab2EJP6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:58:43 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyOsPY-RNwedb3NnbKbj=iAc7L6YuSSEZYy5_Sczmqd4A@mail.gmail.com>
References: <4FAAEB37.1080001@siemens.com> <CA+55aFz-z6F=ynvTZp2xrSyq+Ar7huT92_S9e8Wuxepyppq5ZQ@mail.gmail.com>
 <4FABBCE4.3050503@siemens.com> <CA+55aFyOsPY-RNwedb3NnbKbj=iAc7L6YuSSEZYy5_Sczmqd4A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 May 2012 08:58:21 -0700
X-Google-Sender-Auth: 3tuSdf-EPT0Y825dOTVJBoFlubA
Message-ID: <CA+55aFyr4_3MN4yZdNMnDr+nKm+VTONiP6SQnAGXoaQ1egr7zQ@mail.gmail.com>
Subject: Re: [PATCH v2] compat: Fix RT signal mask corruption via sigprocmask
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Anthony Liguori <aliguori@us.ibm.com>, Kevin Wolf <kwolf@redhat.com>
Content-Type: multipart/mixed; boundary=f46d041824ee9e606704bfb0b1ce
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d041824ee9e606704bfb0b1ce
Content-Type: text/plain; charset=ISO-8859-1

On Thu, May 10, 2012 at 8:44 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think I'll just edit your patch directly, no need to send me a new version.

Ok, just FYI, this is the incremental diff I ended up with. I'll
commit it as this, but I'm sending it out for people to verify before
I do. Although just from looking at the code generation, it really
does just change those four instructions that do a mask to a single
'movl', so I think it's pretty safe even though I haven't tested it.

                       Linus

--f46d041824ee9e606704bfb0b1ce
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h2204h510

IGtlcm5lbC9jb21wYXQuYyB8ICAgMTMgKysrKysrKysrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDEw
IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL2NvbXBh
dC5jIGIva2VybmVsL2NvbXBhdC5jCmluZGV4IDM5YzE2NGUwMmQwNS4uZDJjNjdhYTQ5YWU2IDEw
MDY0NAotLS0gYS9rZXJuZWwvY29tcGF0LmMKKysrIGIva2VybmVsL2NvbXBhdC5jCkBAIC0zNzIs
NiArMzcyLDE1IEBAIGFzbWxpbmthZ2UgbG9uZyBjb21wYXRfc3lzX3NpZ3BlbmRpbmcoY29tcGF0
X29sZF9zaWdzZXRfdCBfX3VzZXIgKnNldCkKIAogI2lmZGVmIF9fQVJDSF9XQU5UX1NZU19TSUdQ
Uk9DTUFTSwogCisvKgorICogc3lzX3NpZ3Byb2NtYXNrIFNJR19TRVRNQVNLIHNldHMgdGhlIGZp
cnN0IChjb21wYXQpIHdvcmQgb2YgdGhlCisgKiBibG9ja2VkIHNldCBvZiBzaWduYWxzIHRvIHRo
ZSBzdXBwbGllZCBzaWduYWwgc2V0CisgKi8KK3N0YXRpYyBpbmxpbmUgdm9pZCBjb21wYXRfc2ln
X3NldG1hc2soc2lnc2V0X3QgKmJsb2NrZWQsIGNvbXBhdF9zaWdzZXRfd29yZCBzZXQpCit7CisJ
bWVtY3B5KGJsb2NrZWQtPnNpZywgJnNldCwgc2l6ZW9mKHNldCkpOworfQorCiBhc21saW5rYWdl
IGxvbmcgY29tcGF0X3N5c19zaWdwcm9jbWFzayhpbnQgaG93LAogCQkJCSAgICAgICBjb21wYXRf
b2xkX3NpZ3NldF90IF9fdXNlciAqbnNldCwKIAkJCQkgICAgICAgY29tcGF0X29sZF9zaWdzZXRf
dCBfX3VzZXIgKm9zZXQpCkBAIC0zOTYsOSArNDA1LDcgQEAgYXNtbGlua2FnZSBsb25nIGNvbXBh
dF9zeXNfc2lncHJvY21hc2soaW50IGhvdywKIAkJCXNpZ2RlbHNldG1hc2soJm5ld19ibG9ja2Vk
LCBuZXdfc2V0KTsKIAkJCWJyZWFrOwogCQljYXNlIFNJR19TRVRNQVNLOgotCQkJbmV3X2Jsb2Nr
ZWQuc2lnWzBdICY9Ci0JCQkJfigob2xkX3NpZ3NldF90KShjb21wYXRfb2xkX3NpZ3NldF90KS0x
KTsKLQkJCW5ld19ibG9ja2VkLnNpZ1swXSB8PSBuZXdfc2V0OworCQkJY29tcGF0X3NpZ19zZXRt
YXNrKCZuZXdfYmxvY2tlZCwgbmV3X3NldCk7CiAJCQlicmVhazsKIAkJZGVmYXVsdDoKIAkJCXJl
dHVybiAtRUlOVkFMOwo=
--f46d041824ee9e606704bfb0b1ce--
