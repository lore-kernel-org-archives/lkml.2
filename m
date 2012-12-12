Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab2LLA1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:27:20 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35762 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601Ab2LLA1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:27:16 -0500
MIME-Version: 1.0
In-Reply-To: <50C7C859.60405@zytor.com>
References: <3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com>
	<CAE9FiQXGZYZiH3eUup2UXGWkeqKjsiHk7aMTFJO7xxFkqTpBZA@mail.gmail.com>
	<50C6AB63.9070008@zytor.com>
	<CAE9FiQX7sPLXOacoLakaJ1qC5UuSUbrX_g7N-oWmLYg5W-91UA@mail.gmail.com>
	<50C6D3DF.3030209@zytor.com>
	<CAE9FiQUiEx=p6wTC5wu_E=ih1CSBaTmw90zsc2=+xu6rMO5usg@mail.gmail.com>
	<20121211145716.GB8873@liondog.tnic>
	<CAE9FiQVByBTHwPrtYvVxv4u9QrtN1iN6GH9YaDn3dvmwv5Sg7g@mail.gmail.com>
	<50C763C2.5020603@zytor.com>
	<CAE9FiQUzHBb5SiEhfrOg7hFbuD1H1-7aXa0aTjhZ9tNqdrwGqw@mail.gmail.com>
	<20121211170605.GD28827@liondog.tnic>
	<CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
	<50C76F9E.4080001@zytor.com>
	<CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com>
	<50C7C859.60405@zytor.com>
Date: Tue, 11 Dec 2012 16:27:13 -0800
X-Google-Sender-Auth: Iv5nwbRXQbfl_5YDCgyi2Y-pwf0
Message-ID: <CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Content-Type: multipart/mixed; boundary=00151747bd542a25a504d09cdc4b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151747bd542a25a504d09cdc4b
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Dec 11, 2012 at 3:57 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Well, we could invoke it on the bootloader page tables, but as you say
> it may not be a good idea... depending on how much memory we may be
> talking about.  One solution -- which I have to admit is starting to
> sound really good -- is to set up a #PF handler which cycles through a
> set of page tables and creates a "virtual identity map"... it does have
> the advantage of making the entire physical address space available
> without any additional funnies.

so that #PF handler will work before
arch/x86/kernel/setup.c::setup_arch/early_trap_init

early_strap_intit will install another handler there for #PF

for 64bit, moving early_ioremap_init ahead is very simple, like attach patch

but for 32 bit looks like it is not that easy.

--00151747bd542a25a504d09cdc4b
Content-Type: application/octet-stream; name="early_ioremap_head64.patch"
Content-Disposition: attachment; filename="early_ioremap_head64.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_halpxpqb0

U3ViamVjdDogW1BBVENIXSB4ODY6IHVzZSBpb19yZW1hcCB0byBhY2Nlc3MgcmVhbF9tb2RlX2Rh
dGEKCldoZW4gNjRiaXQgYm9vdGxvYWRlciBwdXQgcmVhbCBtb2RlIGRhdGEgYWJvdmUgNGcsIFdl
IGNhbiBub3QKYWNjZXNzIHJlYWwgbW9kZSBkYXRhIGRpcmVjdGx5IHlldC4KCmJlY2F1c2UgaW4g
YXJjaC94ODYva2VybmVsL2hlYWRfNjQuUywgb25seSBzZXQgaWRlbnQgbWFwcGluZwpmb3IgMC0x
ZywgYW5kIGtlcm5lbCBjb2RlL2RhdGEvYnNzLgoKTW92ZSBlYXJseV9pb3JlbWFwX2luaXQoKSBj
YWxsaW5nIGFzIGVhcmx5IGFzIHBvc3NpYmxlIHRvCng4Nl82NF9zdGFydF9rZXJuZWwuCgpTaWdu
ZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CgotLS0KIGFyY2gveDg2
L2tlcm5lbC9oZWFkNjQuYyAgfCAgIDI2ICsrKysrKysrKysrKysrKysrKysrKysrLS0tCiBhcmNo
L3g4Ni9rZXJuZWwvaGVhZF82NC5TIHwgICAgNCArKy0tCiBhcmNoL3g4Ni9rZXJuZWwvc2V0dXAu
YyAgIHwgICAgMiArKwogMyBmaWxlcyBjaGFuZ2VkLCAyNyBpbnNlcnRpb25zKCspLCA1IGRlbGV0
aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvaGVhZDY0LmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL2hlYWQ2NC5jCisrKyBsaW51
eC0yLjYvYXJjaC94ODYva2VybmVsL2hlYWQ2NC5jCkBAIC02MiwxMiArNjIsMjEgQEAgc3RhdGlj
IHZvaWQgX19pbml0IGNvcHlfYm9vdGRhdGEoY2hhciAqcgogewogCWNoYXIgKiBjb21tYW5kX2xp
bmU7CiAJdW5zaWduZWQgbG9uZyBjbWRfbGluZV9wdHI7CisJY2hhciAqcDsKIAotCW1lbWNweSgm
Ym9vdF9wYXJhbXMsIHJlYWxfbW9kZV9kYXRhLCBzaXplb2YgYm9vdF9wYXJhbXMpOworCS8qCisJ
ICogZm9yIDY0Yml0IGJvb3Rsb2FkZXIgcGF0aCwgdGhvc2UgZGF0YSBjb3VsZCBiZSBhYm92ZSA0
RywKKwkgKiBhbmQgd2UgZG8gbm90IHNldCBpZGVudCBtYXBwaW5nIGZvciB0aGVtIGluIGhlYWRf
NjQuUy4KKwkgKiBTbyBuZWVkIHRvIHVzZSBpb3JlbWFwIHRvIGFjY2VzcyB0aGVtLgorCSAqLwor
CXAgPSBlYXJseV9tZW1yZW1hcCgodW5zaWduZWQgbG9uZylyZWFsX21vZGVfZGF0YSwgc2l6ZW9m
KGJvb3RfcGFyYW1zKSk7CisJbWVtY3B5KCZib290X3BhcmFtcywgcCwgc2l6ZW9mKGJvb3RfcGFy
YW1zKSk7CisJZWFybHlfaW91bm1hcChwLCBzaXplb2YoYm9vdF9wYXJhbXMpKTsKIAljbWRfbGlu
ZV9wdHIgPSBnZXRfY21kX2xpbmVfcHRyKCk7CiAJaWYgKGNtZF9saW5lX3B0cikgewotCQljb21t
YW5kX2xpbmUgPSBfX3ZhKGNtZF9saW5lX3B0cik7CisJCWNvbW1hbmRfbGluZSA9IGVhcmx5X21l
bXJlbWFwKGNtZF9saW5lX3B0ciwgQ09NTUFORF9MSU5FX1NJWkUpOwogCQltZW1jcHkoYm9vdF9j
b21tYW5kX2xpbmUsIGNvbW1hbmRfbGluZSwgQ09NTUFORF9MSU5FX1NJWkUpOworCQllYXJseV9p
b3VubWFwKGNvbW1hbmRfbGluZSwgQ09NTUFORF9MSU5FX1NJWkUpOwogCX0KIH0KIApAQCAtOTIs
NiArMTAxLDEwIEBAIHZvaWQgX19pbml0IHg4Nl82NF9zdGFydF9rZXJuZWwoY2hhciAqIHIKIAkv
KiBjbGVhciBic3MgYmVmb3JlIHNldF9pbnRyX2dhdGUgd2l0aCBlYXJseV9pZHRfaGFuZGxlciAq
LwogCWNsZWFyX2JzcygpOwogCisJLyogYm9vdF9wYXJhbXMgaXMgaW4gYnNzICovCisJZWFybHlf
aW9yZW1hcF9pbml0KCk7CisJY29weV9ib290ZGF0YShyZWFsX21vZGVfZGF0YSk7CisKIAkvKiBN
YWtlIE5VTEwgcG9pbnRlcnMgc2VnZmF1bHQgKi8KIAl6YXBfaWRlbnRpdHlfbWFwcGluZ3MoKTsK
IApAQCAtMTE0LDcgKzEyNywxNCBAQCB2b2lkIF9faW5pdCB4ODZfNjRfc3RhcnRfa2VybmVsKGNo
YXIgKiByCiAKIHZvaWQgX19pbml0IHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMoY2hhciAqcmVh
bF9tb2RlX2RhdGEpCiB7Ci0JY29weV9ib290ZGF0YShfX3ZhKHJlYWxfbW9kZV9kYXRhKSk7CisJ
LyoKKwkgKiBoZHIudmVyc2lvbiBpcyBhbHdheXMgbm90IDAsIHNvIGNoZWNrIGl0IHRvIHNlZQor
CSAqICBpZiBib290X3BhcmFtcyBpcyBjb3BpZWQgb3Igbm90LgorCSAqLworCWlmICghYm9vdF9w
YXJhbXMuaGRyLnZlcnNpb24pIHsKKwkJZWFybHlfaW9yZW1hcF9pbml0KCk7CisJCWNvcHlfYm9v
dGRhdGEocmVhbF9tb2RlX2RhdGEpOworCX0KIAogCW1lbWJsb2NrX3Jlc2VydmUoX19wYV9zeW1i
b2woX3RleHQpLAogCQkJICh1bnNpZ25lZCBsb25nKV9fYnNzX3N0b3AgLSAodW5zaWduZWQgbG9u
ZylfdGV4dCk7CkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL3NldHVwLmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL3NldHVwLmMKKysrIGxpbnV4
LTIuNi9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYwpAQCAtNzE0LDcgKzcxNCw5IEBAIHZvaWQgX19p
bml0IHNldHVwX2FyY2goY2hhciAqKmNtZGxpbmVfcCkKIAogCWVhcmx5X3RyYXBfaW5pdCgpOwog
CWVhcmx5X2NwdV9pbml0KCk7CisjaWZkZWYgQ09ORklHX1g4Nl8zMgogCWVhcmx5X2lvcmVtYXBf
aW5pdCgpOworI2VuZGlmCiAKIAlzZXR1cF9vbHBjX29md19wZ2QoKTsKIAo=
--00151747bd542a25a504d09cdc4b--
