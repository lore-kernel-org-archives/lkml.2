Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2HYBt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 21:49:27 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49341 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2HYBtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 21:49:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVugSnpVjbYLScXUNfXqmUBD54FkAuvm7TWThGYrSVLMA@mail.gmail.com>
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com>
	<1345852516-3125-2-git-send-email-jacob.shin@amd.com>
	<CAE9FiQVugSnpVjbYLScXUNfXqmUBD54FkAuvm7TWThGYrSVLMA@mail.gmail.com>
Date: Fri, 24 Aug 2012 18:49:23 -0700
X-Google-Sender-Auth: 0nNxQ0O35lHjFO_4KUAn9CsBySY
Message-ID: <CAE9FiQUyoDmpQ96OPY-9Lvq4sqHP2h=O_knkVqbpLaX6BKJRhQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86: Move enabling of PSE and PGE out of init_memory_mapping
From: Yinghai Lu <yinghai@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Content-Type: multipart/mixed; boundary=bcaec501605746fcbb04c80d4dfc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec501605746fcbb04c80d4dfc
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Aug 24, 2012 at 6:25 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Aug 24, 2012 at 4:55 PM, Jacob Shin <jacob.shin@amd.com> wrote:
>> Depending on the platform, init_memory_mapping() may be called multiple
>> times. Move it out to setup_arch() to avoid writing to cr4 on every call.
>>
>> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
>> ---
>>  arch/x86/kernel/setup.c |   10 ++++++++++
>>  arch/x86/mm/init.c      |   10 ----------
>>  2 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index f4b9b80..751e020 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -913,6 +913,16 @@ void __init setup_arch(char **cmdline_p)
>>
>>         init_gbpages();
>>
>> +       /* Enable PSE if available */
>> +       if (cpu_has_pse)
>> +               set_in_cr4(X86_CR4_PSE);
>> +
>> +       /* Enable PGE if available */
>> +       if (cpu_has_pge) {
>> +               set_in_cr4(X86_CR4_PGE);
>> +               __supported_pte_mask |= _PAGE_GLOBAL;
>> +       }
>> +
>
> please don't put it directly in setup_arch().
>
> and another function.
>

Jacob, hpa

can you use attached one to replace the first patch?

Thanks

Yinghai

--bcaec501605746fcbb04c80d4dfc
Content-Type: application/octet-stream; name="get_page_size_mask.patch"
Content-Disposition: attachment; filename="get_page_size_mask.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h6a1wf740

U3ViamVjdDogW1BBVENIIDEvM10geDg2LCBtbTogIEludHJvZHVjZSBnbG9iYWwgcGFnZV9zaXpl
X21hc2sKCkFkZCBwcm9iZV9wYWdlX3NpemVfbWFzaygpIHRvIGRldGVjdCBpZiBuZWVkIHRvIHVz
ZSAxRyBvciAyTS4KYW5kIHN0b3JlIHRoZW0gaW4gcGFnZV9zaXplX21hc2suCgpPbmx5IHByb2Jl
IHRoZW0gYXQgZmlyc3QgaW5pdF9tZW1vcnlfbWFwcGluZyBjYWxsaW5nLgpzZWNvbmQgYW5kIGxh
dGVyIGluaXRfbWVtb3J5X21hcHBpbmcoKSBjYWxsaW5nIGRvZXMgbm90IG5lZWQgcHJvYmUgYWdh
aW4uCmFsc28gd2UgZG9uJ3QgbmVlZCB0byBwYXNzIHVzZV9nYnBhZ2VzIGFyb3VuZC4KClN1Z2dl
c3RlZC1ieTogSW5nbyBNb2xuYXIgPG1pbmdvQGVsdGUuaHU+ClNpZ25lLW9mZi1ieTogWWluZ2hh
aSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wZ3Rh
YmxlLmggfCAgICAxIAogYXJjaC94ODYvbW0vaW5pdC5jICAgICAgICAgICAgIHwgICA3MCArKysr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAz
NyBpbnNlcnRpb25zKCspLCAzNCBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94
ODYvaW5jbHVkZS9hc20vcGd0YWJsZS5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL3BndGFibGUuaAorKysgbGludXgtMi42L2FyY2gveDg2L2luY2x1
ZGUvYXNtL3BndGFibGUuaApAQCAtNTk3LDYgKzU5Nyw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IHBn
ZF9ub25lKHBnZF90IHBnZCkKICNpZm5kZWYgX19BU1NFTUJMWV9fCiAKIGV4dGVybiBpbnQgZGly
ZWN0X2dicGFnZXM7Cit2b2lkIHByb2JlX3BhZ2Vfc2l6ZV9tYXNrKHZvaWQpOwogCiAvKiBsb2Nh
bCBwdGUgdXBkYXRlcyBuZWVkIG5vdCB1c2UgeGNoZyBmb3IgbG9ja2luZyAqLwogc3RhdGljIGlu
bGluZSBwdGVfdCBuYXRpdmVfbG9jYWxfcHRlcF9nZXRfYW5kX2NsZWFyKHB0ZV90ICpwdGVwKQpJ
bmRleDogbGludXgtMi42L2FyY2gveDg2L21tL2luaXQuYwo9PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0y
LjYub3JpZy9hcmNoL3g4Ni9tbS9pbml0LmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9tbS9pbml0
LmMKQEAgLTM1LDggKzM1LDEwIEBAIHN0cnVjdCBtYXBfcmFuZ2UgewogCXVuc2lnbmVkIHBhZ2Vf
c2l6ZV9tYXNrOwogfTsKIAotc3RhdGljIHZvaWQgX19pbml0IGZpbmRfZWFybHlfdGFibGVfc3Bh
Y2Uoc3RydWN0IG1hcF9yYW5nZSAqbXIsIHVuc2lnbmVkIGxvbmcgZW5kLAotCQkJCQkgIGludCB1
c2VfcHNlLCBpbnQgdXNlX2dicGFnZXMpCitzdGF0aWMgaW50IHBhZ2Vfc2l6ZV9tYXNrID0gLTE7
CisKK3N0YXRpYyB2b2lkIF9faW5pdCBmaW5kX2Vhcmx5X3RhYmxlX3NwYWNlKHN0cnVjdCBtYXBf
cmFuZ2UgKm1yLAorCQkJCQkgIHVuc2lnbmVkIGxvbmcgZW5kKQogewogCXVuc2lnbmVkIGxvbmcg
cHVkcywgcG1kcywgcHRlcywgdGFibGVzLCBzdGFydCA9IDAsIGdvb2RfZW5kID0gZW5kOwogCXBo
eXNfYWRkcl90IGJhc2U7CkBAIC00NCw3ICs0Niw3IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBmaW5k
X2Vhcmx5X3RhYmxlX3NwYWMKIAlwdWRzID0gKGVuZCArIFBVRF9TSVpFIC0gMSkgPj4gUFVEX1NI
SUZUOwogCXRhYmxlcyA9IHJvdW5kdXAocHVkcyAqIHNpemVvZihwdWRfdCksIFBBR0VfU0laRSk7
CiAKLQlpZiAodXNlX2dicGFnZXMpIHsKKwlpZiAocGFnZV9zaXplX21hc2sgJiAoMSA8PCBQR19M
RVZFTF8xRykpIHsKIAkJdW5zaWduZWQgbG9uZyBleHRyYTsKIAogCQlleHRyYSA9IGVuZCAtICgo
ZW5kPj5QVURfU0hJRlQpIDw8IFBVRF9TSElGVCk7CkBAIC01NCw3ICs1Niw3IEBAIHN0YXRpYyB2
b2lkIF9faW5pdCBmaW5kX2Vhcmx5X3RhYmxlX3NwYWMKIAogCXRhYmxlcyArPSByb3VuZHVwKHBt
ZHMgKiBzaXplb2YocG1kX3QpLCBQQUdFX1NJWkUpOwogCi0JaWYgKHVzZV9wc2UpIHsKKwlpZiAo
cGFnZV9zaXplX21hc2sgJiAoMSA8PCBQR19MRVZFTF8yTSkpIHsKIAkJdW5zaWduZWQgbG9uZyBl
eHRyYTsKIAogCQlleHRyYSA9IGVuZCAtICgoZW5kPj5QTURfU0hJRlQpIDw8IFBNRF9TSElGVCk7
CkBAIC05MCw2ICs5MiwzNCBAQCBzdGF0aWMgdm9pZCBfX2luaXQgZmluZF9lYXJseV90YWJsZV9z
cGFjCiAJCShwZ3RfYnVmX3RvcCA8PCBQQUdFX1NISUZUKSAtIDEpOwogfQogCit2b2lkIHByb2Jl
X3BhZ2Vfc2l6ZV9tYXNrKHZvaWQpCit7CisJaWYgKHBhZ2Vfc2l6ZV9tYXNrICE9IC0xKQorCQly
ZXR1cm47CisKKwlwYWdlX3NpemVfbWFzayA9IDA7CisjaWYgIWRlZmluZWQoQ09ORklHX0RFQlVH
X1BBR0VBTExPQykgJiYgIWRlZmluZWQoQ09ORklHX0tNRU1DSEVDSykKKwkvKgorCSAqIEZvciBD
T05GSUdfREVCVUdfUEFHRUFMTE9DLCBpZGVudGl0eSBtYXBwaW5nIHdpbGwgdXNlIHNtYWxsIHBh
Z2VzLgorCSAqIFRoaXMgd2lsbCBzaW1wbGlmeSBjcGEoKSwgd2hpY2ggb3RoZXJ3aXNlIG5lZWRz
IHRvIHN1cHBvcnQgc3BsaXR0aW5nCisJICogbGFyZ2UgcGFnZXMgaW50byBzbWFsbCBpbiBpbnRl
cnJ1cHQgY29udGV4dCwgZXRjLgorCSAqLworCWlmIChkaXJlY3RfZ2JwYWdlcykKKwkJcGFnZV9z
aXplX21hc2sgfD0gMSA8PCBQR19MRVZFTF8xRzsKKwlpZiAoY3B1X2hhc19wc2UpCisJCXBhZ2Vf
c2l6ZV9tYXNrIHw9IDEgPDwgUEdfTEVWRUxfMk07CisjZW5kaWYKKworCS8qIEVuYWJsZSBQU0Ug
aWYgYXZhaWxhYmxlICovCisJaWYgKGNwdV9oYXNfcHNlKQorCQlzZXRfaW5fY3I0KFg4Nl9DUjRf
UFNFKTsKKworCS8qIEVuYWJsZSBQR0UgaWYgYXZhaWxhYmxlICovCisJaWYgKGNwdV9oYXNfcGdl
KSB7CisJCXNldF9pbl9jcjQoWDg2X0NSNF9QR0UpOworCQlfX3N1cHBvcnRlZF9wdGVfbWFzayB8
PSBfUEFHRV9HTE9CQUw7CisJfQorfQogdm9pZCBfX2luaXQgbmF0aXZlX3BhZ2V0YWJsZV9yZXNl
cnZlKHU2NCBzdGFydCwgdTY0IGVuZCkKIHsKIAltZW1ibG9ja19yZXNlcnZlKHN0YXJ0LCBlbmQg
LSBzdGFydCk7CkBAIC0xMjUsNDQgKzE1NSwxNiBAQCBzdGF0aWMgaW50IF9fbWVtaW5pdCBzYXZl
X21yKHN0cnVjdCBtYXBfCiB1bnNpZ25lZCBsb25nIF9faW5pdF9yZWZvayBpbml0X21lbW9yeV9t
YXBwaW5nKHVuc2lnbmVkIGxvbmcgc3RhcnQsCiAJCQkJCSAgICAgICB1bnNpZ25lZCBsb25nIGVu
ZCkKIHsKLQl1bnNpZ25lZCBsb25nIHBhZ2Vfc2l6ZV9tYXNrID0gMDsKIAl1bnNpZ25lZCBsb25n
IHN0YXJ0X3BmbiwgZW5kX3BmbjsKIAl1bnNpZ25lZCBsb25nIHJldCA9IDA7CiAJdW5zaWduZWQg
bG9uZyBwb3M7Ci0KIAlzdHJ1Y3QgbWFwX3JhbmdlIG1yW05SX1JBTkdFX01SXTsKIAlpbnQgbnJf
cmFuZ2UsIGk7Ci0JaW50IHVzZV9wc2UsIHVzZV9nYnBhZ2VzOwogCiAJcHJpbnRrKEtFUk5fSU5G
TyAiaW5pdF9tZW1vcnlfbWFwcGluZzogW21lbSAlIzAxMGx4LSUjMDEwbHhdXG4iLAogCSAgICAg
ICBzdGFydCwgZW5kIC0gMSk7CiAKLSNpZiBkZWZpbmVkKENPTkZJR19ERUJVR19QQUdFQUxMT0Mp
IHx8IGRlZmluZWQoQ09ORklHX0tNRU1DSEVDSykKLQkvKgotCSAqIEZvciBDT05GSUdfREVCVUdf
UEFHRUFMTE9DLCBpZGVudGl0eSBtYXBwaW5nIHdpbGwgdXNlIHNtYWxsIHBhZ2VzLgotCSAqIFRo
aXMgd2lsbCBzaW1wbGlmeSBjcGEoKSwgd2hpY2ggb3RoZXJ3aXNlIG5lZWRzIHRvIHN1cHBvcnQg
c3BsaXR0aW5nCi0JICogbGFyZ2UgcGFnZXMgaW50byBzbWFsbCBpbiBpbnRlcnJ1cHQgY29udGV4
dCwgZXRjLgotCSAqLwotCXVzZV9wc2UgPSB1c2VfZ2JwYWdlcyA9IDA7Ci0jZWxzZQotCXVzZV9w
c2UgPSBjcHVfaGFzX3BzZTsKLQl1c2VfZ2JwYWdlcyA9IGRpcmVjdF9nYnBhZ2VzOwotI2VuZGlm
Ci0KLQkvKiBFbmFibGUgUFNFIGlmIGF2YWlsYWJsZSAqLwotCWlmIChjcHVfaGFzX3BzZSkKLQkJ
c2V0X2luX2NyNChYODZfQ1I0X1BTRSk7Ci0KLQkvKiBFbmFibGUgUEdFIGlmIGF2YWlsYWJsZSAq
LwotCWlmIChjcHVfaGFzX3BnZSkgewotCQlzZXRfaW5fY3I0KFg4Nl9DUjRfUEdFKTsKLQkJX19z
dXBwb3J0ZWRfcHRlX21hc2sgfD0gX1BBR0VfR0xPQkFMOwotCX0KLQotCWlmICh1c2VfZ2JwYWdl
cykKLQkJcGFnZV9zaXplX21hc2sgfD0gMSA8PCBQR19MRVZFTF8xRzsKLQlpZiAodXNlX3BzZSkK
LQkJcGFnZV9zaXplX21hc2sgfD0gMSA8PCBQR19MRVZFTF8yTTsKKwlwcm9iZV9wYWdlX3NpemVf
bWFzaygpOwogCiAJbWVtc2V0KG1yLCAwLCBzaXplb2YobXIpKTsKIAlucl9yYW5nZSA9IDA7CkBA
IC0yNjcsNyArMjY5LDcgQEAgdW5zaWduZWQgbG9uZyBfX2luaXRfcmVmb2sgaW5pdF9tZW1vcnlf
bQogCSAqIG5vZGVzIGFyZSBkaXNjb3ZlcmVkLgogCSAqLwogCWlmICghYWZ0ZXJfYm9vdG1lbSkK
LQkJZmluZF9lYXJseV90YWJsZV9zcGFjZSgmbXJbMF0sIGVuZCwgdXNlX3BzZSwgdXNlX2dicGFn
ZXMpOworCQlmaW5kX2Vhcmx5X3RhYmxlX3NwYWNlKCZtclswXSwgZW5kKTsKIAogCWZvciAoaSA9
IDA7IGkgPCBucl9yYW5nZTsgaSsrKQogCQlyZXQgPSBrZXJuZWxfcGh5c2ljYWxfbWFwcGluZ19p
bml0KG1yW2ldLnN0YXJ0LCBtcltpXS5lbmQsCg==
--bcaec501605746fcbb04c80d4dfc--
