Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab2BWKgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 05:36:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63068 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2BWKgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 05:36:11 -0500
MIME-Version: 1.0
In-Reply-To: <4F45B35D.1010702@zytor.com>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
	<tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
	<CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com>
	<4F45B35D.1010702@zytor.com>
Date: Thu, 23 Feb 2012 02:36:10 -0800
X-Google-Sender-Auth: Tr0R2Y4sN0BYTGrX_emivvncHXM
Message-ID: <CAE9FiQUbyYYN5orG_RyVm=P-8wNh=YsET1VzGojpFTfJPueHqA@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, matt.fleming@intel.com, mingo@redhat.com
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org, keithp@keithp.com,
        rui.zhang@intel.com, huang.ying.caritas@gmail.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf303ea5f862560404b99f36d9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf303ea5f862560404b99f36d9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 22, 2012 at 7:32 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/22/2012 06:20 PM, Yinghai Lu wrote:
>>
>> Why is MAXMEM used here?
>>
>> EFI reserved area could be above 4G?
>>
>> if that is the case, you will map all mmio hole below 4g.
>>
>
> OK, dropping this patch for now, at least from -urgent.
>
> We really need to restrict the memory types we map, at least without
> ioremap() called on them. =A0In theory, on x86-64, we could have a
> dedicated "1:1" address for each physical address, but there is no good
> reason we should ever map memory types other than RAM, ACPI and EFI by
> default -- with the possible exception of the low 1 MiB legacy area.

please check attach patch for tip/efi branch.

Thanks

       Yinghai

--20cf303ea5f862560404b99f36d9
Content-Type: text/x-patch; charset=US-ASCII; name="fix_efi_map_end.patch"
Content-Disposition: attachment; filename="fix_efi_map_end.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gyznl0bj0

U3ViamVjdDogW1BBVENIXSB4ODYsIGVmaTogdXNlIGU4MjBfZW5kX3Bmbl9lZmkgd2l0aCBsb3df
cGZuIGFuZCBtYXhfcGZuCkZyb206IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KClNv
IGF2b2lkIHRvIG1hcCBtbWlvIGJlbG93IDRnLCBpZiBzeXN0ZW0gaGF2ZSBFRkkgcmFuZ2UgYWJv
dmUgNGcuCgpTaWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+Cgot
LS0KIGFyY2gveDg2L2tlcm5lbC9zZXR1cC5jIHwgICA0MiArKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspLCAx
OCBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL3NldHVwLmMK
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL3NldHVwLmMKKysr
IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYwpAQCAtNjgxLDYgKzY4MSwyNyBAQCBz
dGF0aWMgaW50IF9faW5pdCBwYXJzZV9yZXNlcnZlbG93KGNoYXIKIAogZWFybHlfcGFyYW0oInJl
c2VydmVsb3ciLCBwYXJzZV9yZXNlcnZlbG93KTsKIAorc3RhdGljIHVuc2lnbmVkIGxvbmcgX19p
bml0IGU4MjBfZW5kX3Bmbl9lZmkodW5zaWduZWQgbG9uZyBlbmRfcGZuLAorCQkJCQkgICAgIHVu
c2lnbmVkIGxvbmcgbGltaXRfcGZuKQoreworI2lmZGVmIENPTkZJR19YODZfNjQKKwkvKgorCSAq
IFRoZXJlIG1heSBiZSByZWdpb25zIGFmdGVyIHRoZSBsYXN0IEU4MjBfUkFNIHJlZ2lvbiB0aGF0
IHdlCisJICogd2FudCB0byBpbmNsdWRlIGluIHRoZSBrZXJuZWwgZGlyZWN0IG1hcHBpbmcgYmVj
YXVzZSB0aGVpcgorCSAqIGNvbnRlbnRzIGFyZSBuZWVkZWQgYXQgcnVudGltZS4KKwkgKi8KKwlp
ZiAoZWZpX2VuYWJsZWQpIHsKKwkJdW5zaWduZWQgbG9uZyBlZmlfZW5kOworCisJCWVmaV9lbmQg
PSBlODIwX2VuZF9wZm4obGltaXRfcGZuLCBFODIwX1JFU0VSVkVEX0VGSSk7CisJCWlmIChlZmlf
ZW5kID4gZW5kX3BmbikKKwkJCWVuZF9wZm4gPSBlZmlfZW5kOworCX0KKyNlbmRpZgorCisJcmV0
dXJuIGVuZF9wZm47Cit9CisKIC8qCiAgKiBEZXRlcm1pbmUgaWYgd2Ugd2VyZSBsb2FkZWQgYnkg
YW4gRUZJIGxvYWRlci4gIElmIHNvLCB0aGVuIHdlIGhhdmUgYWxzbyBiZWVuCiAgKiBwYXNzZWQg
dGhlIGVmaSBtZW1tYXAsIHN5c3RhYiwgZXRjLiwgc28gd2Ugc2hvdWxkIHVzZSB0aGVzZSBkYXRh
IHN0cnVjdHVyZXMKQEAgLTkzNCwzMCArOTU1LDE1IEBAIHZvaWQgX19pbml0IHNldHVwX2FyY2go
Y2hhciAqKmNtZGxpbmVfcCkKIAlpbml0X2dicGFnZXMoKTsKIAogCS8qIG1heF9wZm5fbWFwcGVk
IGlzIHVwZGF0ZWQgaGVyZSAqLwotCWVuZF9wZm4gPSBtYXhfbG93X3BmbjsKLQotI2lmZGVmIENP
TkZJR19YODZfNjQKLQkvKgotCSAqIFRoZXJlIG1heSBiZSByZWdpb25zIGFmdGVyIHRoZSBsYXN0
IEU4MjBfUkFNIHJlZ2lvbiB0aGF0IHdlCi0JICogd2FudCB0byBpbmNsdWRlIGluIHRoZSBrZXJu
ZWwgZGlyZWN0IG1hcHBpbmcgYmVjYXVzZSB0aGVpcgotCSAqIGNvbnRlbnRzIGFyZSBuZWVkZWQg
YXQgcnVudGltZS4KLQkgKi8KLQlpZiAoZWZpX2VuYWJsZWQpIHsKLQkJdW5zaWduZWQgbG9uZyBl
ZmlfZW5kOwotCi0JCWVmaV9lbmQgPSBlODIwX2VuZF9wZm4oTUFYTUVNPj5QQUdFX1NISUZULCBF
ODIwX1JFU0VSVkVEX0VGSSk7Ci0JCWlmIChlZmlfZW5kID4gZW5kX3BmbikKLQkJCWVuZF9wZm4g
PSBlZmlfZW5kOwotCX0KLSNlbmRpZgotCisJZW5kX3BmbiA9IGU4MjBfZW5kX3Bmbl9lZmkobWF4
X2xvd19wZm4sIDFVTDw8KDMyLVBBR0VfU0hJRlQpKTsKIAltYXhfbG93X3Bmbl9tYXBwZWQgPSBp
bml0X21lbW9yeV9tYXBwaW5nKDAsIGVuZF9wZm4gPDwgUEFHRV9TSElGVCk7CiAJbWF4X3Bmbl9t
YXBwZWQgPSBtYXhfbG93X3Bmbl9tYXBwZWQ7CiAKICNpZmRlZiBDT05GSUdfWDg2XzY0CiAJaWYg
KG1heF9wZm4gPiBtYXhfbG93X3BmbikgeworCQllbmRfcGZuID0gZTgyMF9lbmRfcGZuX2VmaSht
YXhfcGZuLCBNQVhNRU0+PlBBR0VfU0hJRlQpOwogCQltYXhfcGZuX21hcHBlZCA9IGluaXRfbWVt
b3J5X21hcHBpbmcoMVVMPDwzMiwKLQkJCQkJCSAgICAgbWF4X3Bmbjw8UEFHRV9TSElGVCk7CisJ
CQkJCQkgICAgIGVuZF9wZm48PFBBR0VfU0hJRlQpOwogCQkvKiBjYW4gd2UgcHJlc2V2ZSBtYXhf
bG93X3BmbiA/Ki8KIAkJbWF4X2xvd19wZm4gPSBtYXhfcGZuOwogCX0K
--20cf303ea5f862560404b99f36d9--
