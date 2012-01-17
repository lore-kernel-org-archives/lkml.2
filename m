Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750986Ab2AQBbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 20:31:20 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46173 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2AQBbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 20:31:19 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzGN59W5zhmc-kicQrpomAKLiwX4yBUsNcagwmM=Z8jxw@mail.gmail.com>
References: <1326744932.16150.9.camel@sbsiddha-desk.sc.intel.com>
 <CA+55aFys9zddHAoKURGAeu0QYD_MC11uEyOQGU_4Ybsf200NkQ@mail.gmail.com>
 <1326760869.16150.16.camel@sbsiddha-desk.sc.intel.com> <CA+55aFzGN59W5zhmc-kicQrpomAKLiwX4yBUsNcagwmM=Z8jxw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 17:30:57 -0800
X-Google-Sender-Auth: eWflPBhKq95N27OmBeD41XjeScs
Message-ID: <CA+55aFwuwPXatwdJqeW_e_7w_rBELL8HTHqq0FLDiE+xmPm5XQ@mail.gmail.com>
Subject: Re: [patch] x86, tsc: fix SMI induced variation in quick_pit_calibrate()
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, asit.k.mallick@intel.com
Content-Type: multipart/mixed; boundary=f46d043bdedea922b704b6af4954
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d043bdedea922b704b6af4954
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Jan 16, 2012 at 4:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm. I get the feeling that we should remove that line entirely.

Yeah, I really cannot come up with a single good reason to keep that
line, and suspect that I was a bit loopy when I wrote it.

So here's the suggested trivially updated patch. Does this work for people?

                    Linus

--f46d043bdedea922b704b6af4954
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxi8xivl0

IGFyY2gveDg2L2tlcm5lbC90c2MuYyB8ICAgMTAgKysrKy0tLS0tLQogMSBmaWxlcyBjaGFuZ2Vk
LCA0IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a2VybmVsL3RzYy5jIGIvYXJjaC94ODYva2VybmVsL3RzYy5jCmluZGV4IGMwZGQ1YjYwMzc0OS4u
YjJhYmQ2NDdkMjMzIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvdHNjLmMKKysrIGIvYXJj
aC94ODYva2VybmVsL3RzYy5jCkBAIC0yOTAsMTQgKzI5MCwxNSBAQCBzdGF0aWMgaW5saW5lIGlu
dCBwaXRfdmVyaWZ5X21zYih1bnNpZ25lZCBjaGFyIHZhbCkKIHN0YXRpYyBpbmxpbmUgaW50IHBp
dF9leHBlY3RfbXNiKHVuc2lnbmVkIGNoYXIgdmFsLCB1NjQgKnRzY3AsIHVuc2lnbmVkIGxvbmcg
KmRlbHRhcCkKIHsKIAlpbnQgY291bnQ7Ci0JdTY0IHRzYyA9IDA7CisJdTY0IHRzYyA9IDAsIHBy
ZXZfdHNjID0gMDsKIAogCWZvciAoY291bnQgPSAwOyBjb3VudCA8IDUwMDAwOyBjb3VudCsrKSB7
CiAJCWlmICghcGl0X3ZlcmlmeV9tc2IodmFsKSkKIAkJCWJyZWFrOworCQlwcmV2X3RzYyA9IHRz
YzsKIAkJdHNjID0gZ2V0X2N5Y2xlcygpOwogCX0KLQkqZGVsdGFwID0gZ2V0X2N5Y2xlcygpIC0g
dHNjOworCSpkZWx0YXAgPSBnZXRfY3ljbGVzKCkgLSBwcmV2X3RzYzsKIAkqdHNjcCA9IHRzYzsK
IAogCS8qCkBAIC0zODMsMTUgKzM4NCwxMiBAQCBzdWNjZXNzOgogCSAqCiAJICogQXMgYSByZXN1
bHQsIHdlIGNhbiBkZXBlbmQgb24gdGhlcmUgbm90IGJlaW5nCiAJICogYW55IG9kZCBkZWxheXMg
YW55d2hlcmUsIGFuZCB0aGUgVFNDIHJlYWRzIGFyZQotCSAqIHJlbGlhYmxlICh3aXRoaW4gdGhl
IGVycm9yKS4gV2UgYWxzbyBhZGp1c3QgdGhlCi0JICogZGVsdGEgdG8gdGhlIG1pZGRsZSBvZiB0
aGUgZXJyb3IgYmFycywganVzdAotCSAqIGJlY2F1c2UgaXQgbG9va3MgbmljZXIuCisJICogcmVs
aWFibGUgKHdpdGhpbiB0aGUgZXJyb3IpLgogCSAqCiAJICoga0h6ID0gdGlja3MgLyB0aW1lLWlu
LXNlY29uZHMgLyAxMDAwOwogCSAqIGtIeiA9ICh0MiAtIHQxKSAvIChJICogMjU2IC8gUElUX1RJ
Q0tfUkFURSkgLyAxMDAwCiAJICoga0h6ID0gKCh0MiAtIHQxKSAqIFBJVF9USUNLX1JBVEUpIC8g
KEkgKiAyNTYgKiAxMDAwKQogCSAqLwotCWRlbHRhICs9IChsb25nKShkMiAtIGQxKS8yOwogCWRl
bHRhICo9IFBJVF9USUNLX1JBVEU7CiAJZG9fZGl2KGRlbHRhLCBpKjI1NioxMDAwKTsKIAlwcmlu
dGsoIkZhc3QgVFNDIGNhbGlicmF0aW9uIHVzaW5nIFBJVFxuIik7Cg==
--f46d043bdedea922b704b6af4954--
