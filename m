Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab1L3UGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 15:06:42 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44644 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1L3UGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 15:06:40 -0500
MIME-Version: 1.0
In-Reply-To: <1325264878.30917.11.camel@twins>
References: <20111229210707.GA22300@elte.hu> <CA+55aFydsXqRg-QwfVBuUOSfpGQ24MjgWaK-z+3Qvgn-BHn6Tw@mail.gmail.com>
 <1325264878.30917.11.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Dec 2011 12:06:18 -0800
X-Google-Sender-Auth: yfp07oZrkJX6lV8jibP3rERxRxM
Message-ID: <CA+55aFzPfysGq+ihMioGXASs3ixn9RBOuju2UhygKY_qtoo_Ag@mail.gmail.com>
Subject: Re: [GIT PULL] futex fixlet
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: multipart/mixed; boundary=0016e6dedde652b11004b554c587
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6dedde652b11004b554c587
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Dec 30, 2011 at 9:07 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> So I _think_ you're completely right and we can simply kill the whole
> thing, but I've been trying very hard to forget everything kernel
> related for a week, and I really shouldn't kick-start my brain until
> somewhere next week.

Ok.

Ingo, I'd suggest you put a patch like that into -next, and mark it
for stable after it has gotten lots more testing.

Something like the appended *totally* untested code. It compiles, but
maybe there really is some "!page->mapping" case that could possibly
matter.

I can't see it, though - but we should definitely get some testing for
this before I'd put it in a release. Since we do that
"get_user_pages_fast()" and ask for a writable page, the result should
be as stable as it will ever get. There is still the race with
hugepage splitting, but at least that one has a comment.

                       Linus

--0016e6dedde652b11004b554c587
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gwtmrjop0

IGtlcm5lbC9mdXRleC5jIHwgICAyMCArKysrKysrKysrKystLS0tLS0tLQogMSBmaWxlcyBjaGFu
Z2VkLCAxMiBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5l
bC9mdXRleC5jIGIva2VybmVsL2Z1dGV4LmMKaW5kZXggZWE4N2Y0ZDJmNDU1Li44ZDJlZTJmNjY0
MTggMTAwNjQ0Ci0tLSBhL2tlcm5lbC9mdXRleC5jCisrKyBiL2tlcm5lbC9mdXRleC5jCkBAIC0z
MTAsMjEgKzMxMCwyNSBAQCBhZ2FpbjoKIAlpZiAocGFnZSAhPSBwYWdlX2hlYWQpIHsKIAkJZ2V0
X3BhZ2UocGFnZV9oZWFkKTsKIAkJcHV0X3BhZ2UocGFnZSk7CisJCS8qIEF2b2lkICJ1bnVzZWQg
bGFiZWwiIGZvciBub24tVEhQIGNvbmZpZyAqLworCQlpZiAoMCkKKwkJCWdvdG8gYWdhaW47CiAJ
fQogI2VuZGlmCiAKIAlsb2NrX3BhZ2UocGFnZV9oZWFkKTsKKworCS8qCisJICogSWYgdGhlIHBh
Z2UgZG9lc24ndCBoYXZlIGEgbWFwcGluZyBhc3NvY2lhdGVkIHdpdGggaXQsCisJICogdGhpcyBp
cyBlaXRoZXIgYW4gYW5vbnltb3VzIHBhZ2UgdGhhdCB3YXMgYWNjZXNzZWQgUk8KKwkgKiAoc28g
bm8gQ09XIGV0YykgYW5kIHdlIHdvdWxkIGp1c3QgcmV0dXJuIEVGQVVMVCBhbnl3YXksCisJICog
b3Igc29tZSBzcGVjaWFsIGNhc2UgcGFnZSAoWkVST19QQUdFLCBnYXRlIGFyZWEsIHNwZWNpYWwK
KwkgKiBtYXBwaW5nLi4pLgorCSAqLwogCWlmICghcGFnZV9oZWFkLT5tYXBwaW5nKSB7CiAJCXVu
bG9ja19wYWdlKHBhZ2VfaGVhZCk7CiAJCXB1dF9wYWdlKHBhZ2VfaGVhZCk7Ci0JCS8qCi0JCSog
WkVST19QQUdFIHBhZ2VzIGRvbid0IGhhdmUgYSBtYXBwaW5nLiBBdm9pZCBhIGJ1c3kgbG9vcAot
CQkqIHRyeWluZyB0byBmaW5kIG9uZS4gUlcgbWFwcGluZyB3b3VsZCBoYXZlIENPVydkIChhbmQg
dGh1cwotCQkqIGhhdmUgYSBtYXBwaW5nKSBzbyB0aGlzIHBhZ2UgaXMgUk8gYW5kIHdvbid0IGV2
ZXIgY2hhbmdlLgotCQkqLwotCQlpZiAoKHBhZ2VfaGVhZCA9PSBaRVJPX1BBR0UoYWRkcmVzcykp
KQotCQkJcmV0dXJuIC1FRkFVTFQ7Ci0JCWdvdG8gYWdhaW47CisJCXJldHVybiAtRUZBVUxUOwog
CX0KIAogCS8qCg==
--0016e6dedde652b11004b554c587--
