Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab2EYSj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 14:39:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59067 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab2EYSj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 14:39:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
	<1337754877-19759-3-git-send-email-yinghai@kernel.org>
	<CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
	<CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
	<CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
	<20120525043651.GA1391@google.com>
	<CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
Date: Fri, 25 May 2012 11:39:26 -0700
X-Google-Sender-Auth: 8uwQc1rwUpkMiIvr0M7abcwugRA
Message-ID: <CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7b162fd718665c04c0e0b0cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b162fd718665c04c0e0b0cf
Content-Type: text/plain; charset=ISO-8859-1

On Fri, May 25, 2012 at 10:53 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> I don't really like the dependency on PCIBIOS_MAX_MEM_32 + 1ULL
>> overflowing to zero -- that means the reader has to know what the
>> value of PCIBIOS_MAX_MEM_32 is, and things would break in non-obvious
>> ways if we changed it.
>>

please check if attached one is more clear.

make max and bottom is only related to _MEM and not default one.

-       if (!(res->flags & IORESOURCE_MEM_64))
-               max = PCIBIOS_MAX_MEM_32;
+       if (res->flags & IORESOURCE_MEM) {
+               if (!(res->flags & IORESOURCE_MEM_64))
+                       max = PCIBIOS_MAX_MEM_32;
+               else if (PCIBIOS_MAX_MEM_32 != -1)
+                       bottom = (resource_size_t)(1ULL<<32);
+       }

will still not affect to other arches.


Thanks

Yinghai

--047d7b162fd718665c04c0e0b0cf
Content-Type: application/octet-stream; name="allocate_high_at_first.patch"
Content-Disposition: attachment; filename="allocate_high_at_first.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h2nlec0k0

U3ViamVjdDogW1BBVENIXSBQQ0k6IFRyeSB0byBhbGxvY2F0ZSBtZW02NCBhYm92ZSA0RyBhdCBm
aXJzdAoKYW5kIHdpbGwgZmFsbCBiYWNrIHRvIGJlbG93IDRnIGlmIGl0IGNhbiBub3QgZmluZCBh
bnkgYWJvdmUgNGcuCgpvbmx5IHg4NiBoYXZlIFBDSUJJT1NfTUFYX01FTV8zMiBzZXQgdG8gMHhm
ZmZmZmZmZi4KaXQgd2lsbCBvbmx5IGFmZmVjdCB4ODZfNjQgYW5kIDMyYml0IHdpdGggcmVzb3Vy
Y2Vfc2l6ZV90IDY0Yml0IHN1cHBvcnQuCm9ubHkgdGhhdCBjYXNlIGJvdHRvbSBpcyBzZXQgdG8g
NGcgZm9yIGZpcnN0IHRyeS4KCng4NiAzMmJpdCB3aXRob3V0IFg4Nl9QQUUgc3VwcG9ydCB3aWxs
IGhhdmUgYm90dG9tIHNldCB0byAwLCBiZWN1YXNlCnJlc291cmNlX3NpemVfdCBpcyAzMmJpdC4K
CkFsc28gZm9yIDMyYml0IHdpdGggcmVzb3VyY2Vfc2l6ZV90IDY0Yml0IGtlcm5lbCBvbiBtYWNo
aW5lIHdpdGggcGFlIHN1cHBvcnQKd2UgYXJlIHNhZmUgYmVjYXVzZSBpb21lbV9yZXNvdXJjZSBp
cyBsaW1pdGVkIHRvIDMyYml0IGFjY29yZGluZyB0bwp4ODZfcGh5c19iaXRzLgoKLXYyOiB1cGRh
dGUgYm90dG9tIGFzc2lnbmluZyB0byBtYWtlIGl0IGNsZWFyIGZvciBub24tcGFlIHN1cHBvcnQg
bWFjaGluZS4KClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4K
Ci0tLQogZHJpdmVycy9wY2kvYnVzLmMgfCAgIDIwICsrKysrKysrKysrKysrKystLS0tCiAxIGZp
bGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51
eC0yLjYvZHJpdmVycy9wY2kvYnVzLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJp
dmVycy9wY2kvYnVzLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9idXMuYwpAQCAtMTIyLDEz
ICsxMjIsMTkgQEAgcGNpX2J1c19hbGxvY19yZXNvdXJjZShzdHJ1Y3QgcGNpX2J1cyAqYgogCWlu
dCBpLCByZXQgPSAtRU5PTUVNOwogCXN0cnVjdCByZXNvdXJjZSAqcjsKIAlyZXNvdXJjZV9zaXpl
X3QgbWF4ID0gLTE7CisJcmVzb3VyY2Vfc2l6ZV90IGJvdHRvbSA9IDA7CiAKIAl0eXBlX21hc2sg
fD0gSU9SRVNPVVJDRV9JTyB8IElPUkVTT1VSQ0VfTUVNOwogCiAJLyogZG9uJ3QgYWxsb2NhdGUg
dG9vIGhpZ2ggaWYgdGhlIHByZWYgbWVtIGRvZXNuJ3Qgc3VwcG9ydCA2NGJpdCovCi0JaWYgKCEo
cmVzLT5mbGFncyAmIElPUkVTT1VSQ0VfTUVNXzY0KSkKLQkJbWF4ID0gUENJQklPU19NQVhfTUVN
XzMyOworCWlmIChyZXMtPmZsYWdzICYgSU9SRVNPVVJDRV9NRU0pIHsKKwkJaWYgKCEocmVzLT5m
bGFncyAmIElPUkVTT1VSQ0VfTUVNXzY0KSkKKwkJCW1heCA9IFBDSUJJT1NfTUFYX01FTV8zMjsK
KwkJZWxzZSBpZiAoUENJQklPU19NQVhfTUVNXzMyICE9IC0xKQorCQkJYm90dG9tID0gKHJlc291
cmNlX3NpemVfdCkoMVVMTDw8MzIpOworCX0KIAorYWdhaW46CiAJcGNpX2J1c19mb3JfZWFjaF9y
ZXNvdXJjZShidXMsIHIsIGkpIHsKIAkJaWYgKCFyKQogCQkJY29udGludWU7CkBAIC0xNDUsMTIg
KzE1MSwxOCBAQCBwY2lfYnVzX2FsbG9jX3Jlc291cmNlKHN0cnVjdCBwY2lfYnVzICpiCiAKIAkJ
LyogT2ssIHRyeSBpdCBvdXQuLiAqLwogCQlyZXQgPSBhbGxvY2F0ZV9yZXNvdXJjZShyLCByZXMs
IHNpemUsCi0JCQkJCXItPnN0YXJ0ID8gOiBtaW4sCisJCQkJCW1heChib3R0b20sIHItPnN0YXJ0
ID8gOiBtaW4pLAogCQkJCQltYXgsIGFsaWduLAogCQkJCQlhbGlnbmYsIGFsaWduZl9kYXRhKTsK
IAkJaWYgKHJldCA9PSAwKQotCQkJYnJlYWs7CisJCQlyZXR1cm4gMDsKKwl9CisKKwlpZiAoYm90
dG9tICE9IDApIHsKKwkJYm90dG9tID0gMDsKKwkJZ290byBhZ2FpbjsKIAl9CisKIAlyZXR1cm4g
cmV0OwogfQogCg==
--047d7b162fd718665c04c0e0b0cf--
