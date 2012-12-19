Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab2LSXsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:48:45 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:44923 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2LSXsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:48:37 -0500
MIME-Version: 1.0
In-Reply-To: <50D25128.7030205@zytor.com>
References: <50CCEE49.3080801@zytor.com>
	<CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com>
	<50CCF6F6.4020107@zytor.com>
	<CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com>
	<50CD04F1.8020902@zytor.com>
	<0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
	<20121219220504.GA32212@jshin-Toonie>
	<50D23EE8.7030904@zytor.com>
	<20121219225155.GK24895@liondog.tnic>
	<20121219225941.GB2968@jshin-Toonie>
	<20121219230329.GM24895@liondog.tnic>
	<50D24C25.5050604@zytor.com>
	<CAE9FiQWuC+34=q1K5oj8j+U1XjbXPDz5k1VKvs4vnoZDAzFzRg@mail.gmail.com>
	<50D25128.7030205@zytor.com>
Date: Wed, 19 Dec 2012 15:48:35 -0800
X-Google-Sender-Auth: AnGfadPQcJu3Q_0hoQFvTCk081Y
Message-ID: <CAE9FiQUB_hVqmbOf8C-bRkdQm85x3b=pk-xa2-8ZMZMfSt5s=w@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Content-Type: multipart/mixed; boundary=001517478216bb727b04d13d40e7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001517478216bb727b04d13d40e7
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Dec 19, 2012 at 3:43 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/19/2012 03:40 PM, Yinghai Lu wrote:
>>
>> On Wed, Dec 19, 2012 at 3:22 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> The other bit is that building the real kernel page tables iteratively
>>> (ignoring the early page tables here) is safer, since the real page
>>> table builder is fully aware of the memory map.  This means any
>>> "spillover" from the early page tables gets minimized to regions where
>>> there are data objects that have to be accessed early.  Since Yinghai
>>> already had iterative page table building working, I don't see any
>>> reason to not use that capability.
>>
>>
>> that is v6, right?
>>
>> including that patch
>>
>
> No, that's just a different way to create the early page tables (and it
> doesn't solve anything, quite on the contrary.)  I'm talking about the
> strategy for creating the *permanent* page tables
>

i'm confused. permanent one is in tip/x86/mm2 right?

for for-x86-boot:
so you want v7 plus attached patch ? that change to 2M per PF.

Yinghai

--001517478216bb727b04d13d40e7
Content-Type: application/octet-stream; name="fix_hpa_pe_pgt.patch"
Content-Disposition: attachment; filename="fix_hpa_pe_pgt.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hax441a50

U3ViamVjdDogW1BBVENIXSB4ODYsIDY0Yml0OiAjUEYgaGFuZGxlciBzZXQgcGFnZSB0byBjb3Zl
ciAyTSBvbmx5Cgpvbmx5IGFkZCBvbmUgMk0gaW5zdGVhZCBvZiAxRyBhY2Nlc3Npbmcgb25lIHRp
bWUgZm9yIGR5bmFtaWNhbGx5LgoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBr
ZXJuZWwub3JnPgoKLS0tCiBhcmNoL3g4Ni9rZXJuZWwvaGVhZDY0LmMgfCAgIDQwICsrKysrKysr
KysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyNCBpbnNl
cnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYva2Vy
bmVsL2hlYWQ2NC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5l
bC9oZWFkNjQuYworKysgbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9oZWFkNjQuYwpAQCAtNTIs
NyArNTIsNyBAQCBpbnQgX19pbml0IGVhcmx5X21ha2VfcGd0YWJsZSh1bnNpZ25lZCBsCiAJdW5z
aWduZWQgbG9uZyBwaHlzYWRkciA9IGFkZHJlc3MgLSBfX1BBR0VfT0ZGU0VUOwogCXVuc2lnbmVk
IGxvbmcgaTsKIAlwZ2R2YWxfdCBwZ2QsICpwZ2RfcDsKLQlwdWR2YWxfdCAqcHVkX3A7CisJcHVk
dmFsX3QgcHVkLCAqcHVkX3A7CiAJcG1kdmFsX3QgcG1kLCAqcG1kX3A7CiAKIApAQCAtNjAsOCAr
NjAsOCBAQCBpbnQgX19pbml0IGVhcmx5X21ha2VfcGd0YWJsZSh1bnNpZ25lZCBsCiAJaWYgKHBo
eXNhZGRyID49IE1BWE1FTSB8fCByZWFkX2NyMygpICE9IF9fcGEoZWFybHlfbGV2ZWw0X3BndCkp
CiAJCXJldHVybiAtMTsKIAotCWkgPSAoYWRkcmVzcyA+PiBQR0RJUl9TSElGVCkgJiAoUFRSU19Q
RVJfUEdEIC0gMSk7Ci0JcGdkX3AgPSAmZWFybHlfbGV2ZWw0X3BndFtpXS5wZ2Q7CithZ2FpbjoK
KwlwZ2RfcCA9ICZlYXJseV9sZXZlbDRfcGd0W3BnZF9pbmRleChhZGRyZXNzKV0ucGdkOwogCXBn
ZCA9ICpwZ2RfcDsKIAogCS8qCkBAIC02OSwyOSArNjksMzcgQEAgaW50IF9faW5pdCBlYXJseV9t
YWtlX3BndGFibGUodW5zaWduZWQgbAogCSAqIGNyaXRpY2FsIC0tIF9fUEFHRV9PRkZTRVQgd291
bGQgcG9pbnQgdXMgYmFjayBpbnRvIHRoZSBkeW5hbWljCiAJICogcmFuZ2UgYW5kIHdlIG1pZ2h0
IGVuZCB1cCBsb29waW5nIGZvcmV2ZXIuLi4KIAkgKi8KLQlpZiAocGdkICYmIG5leHRfZWFybHlf
cGd0IDwgRUFSTFlfRFlOQU1JQ19QQUdFX1RBQkxFUykgeworCWlmIChwZ2QpCiAJCXB1ZF9wID0g
KHB1ZHZhbF90ICopKChwZ2QgJiBQVEVfUEZOX01BU0spICsgX19TVEFSVF9LRVJORUxfbWFwIC0g
cGh5c19iYXNlKTsKLQl9IGVsc2UgewotCQlpZiAobmV4dF9lYXJseV9wZ3QgPj0gRUFSTFlfRFlO
QU1JQ19QQUdFX1RBQkxFUy0xKQorCWVsc2UgeworCQlpZiAobmV4dF9lYXJseV9wZ3QgPj0gRUFS
TFlfRFlOQU1JQ19QQUdFX1RBQkxFUykgewogCQkJcmVzZXRfZWFybHlfcGFnZV90YWJsZXMoKTsK
KwkJCWdvdG8gYWdhaW47CisJCX0KIAogCQlwdWRfcCA9IChwdWR2YWxfdCAqKWVhcmx5X2R5bmFt
aWNfcGd0c1tuZXh0X2Vhcmx5X3BndCsrXTsKIAkJZm9yIChpID0gMDsgaSA8IFBUUlNfUEVSX1BV
RDsgaSsrKQogCQkJcHVkX3BbaV0gPSAwOwotCiAJCSpwZ2RfcCA9IChwZ2R2YWxfdClwdWRfcCAt
IF9fU1RBUlRfS0VSTkVMX21hcCArIHBoeXNfYmFzZSArIF9LRVJOUEdfVEFCTEU7CiAJfQotCWkg
PSAoYWRkcmVzcyA+PiBQVURfU0hJRlQpICYgKFBUUlNfUEVSX1BVRCAtIDEpOwotCXB1ZF9wICs9
IGk7CisJcHVkX3AgKz0gcHVkX2luZGV4KGFkZHJlc3MpOworCXB1ZCA9ICpwdWRfcDsKIAotCXBt
ZF9wID0gKHBtZHZhbF90ICopZWFybHlfZHluYW1pY19wZ3RzW25leHRfZWFybHlfcGd0KytdOwot
CXBtZCA9IChwaHlzYWRkciAmIFBVRF9NQVNLKSArIChfX1BBR0VfS0VSTkVMX0xBUkdFICYgfl9Q
QUdFX0dMT0JBTCk7Ci0JZm9yIChpID0gMDsgaSA8IFBUUlNfUEVSX1BNRDsgaSsrKSB7Ci0JCXBt
ZF9wW2ldID0gcG1kOwotCQlwbWQgKz0gUE1EX1NJWkU7Ci0JfQorCWlmIChwdWQpCisJCXBtZF9w
ID0gKHBtZHZhbF90ICopKChwdWQgJiBQVEVfUEZOX01BU0spICsgX19TVEFSVF9LRVJORUxfbWFw
IC0gcGh5c19iYXNlKTsKKwllbHNlIHsKKwkJaWYgKG5leHRfZWFybHlfcGd0ID49IEVBUkxZX0RZ
TkFNSUNfUEFHRV9UQUJMRVMpIHsKKwkJCXJlc2V0X2Vhcmx5X3BhZ2VfdGFibGVzKCk7CisJCQln
b3RvIGFnYWluOworCQl9CiAKLQkqcHVkX3AgPSAocHVkdmFsX3QpcG1kX3AgLSBfX1NUQVJUX0tF
Uk5FTF9tYXAgKyBwaHlzX2Jhc2UgKyBfS0VSTlBHX1RBQkxFOworCQlwbWRfcCA9IChwbWR2YWxf
dCAqKWVhcmx5X2R5bmFtaWNfcGd0c1tuZXh0X2Vhcmx5X3BndCsrXTsKKwkJZm9yIChpID0gMDsg
aSA8IFBUUlNfUEVSX1BNRDsgaSsrKQorCQkJcG1kX3BbaV0gPSAwOworCQkqcHVkX3AgPSAocHVk
dmFsX3QpcG1kX3AgLSBfX1NUQVJUX0tFUk5FTF9tYXAgKyBwaHlzX2Jhc2UgKyBfS0VSTlBHX1RB
QkxFOworCX0KKwlwbWQgPSAocGh5c2FkZHIgJiBQTURfTUFTSykgKyAoX19QQUdFX0tFUk5FTF9M
QVJHRSAmIH5fUEFHRV9HTE9CQUwpOworCXBtZF9wW3BtZF9pbmRleChhZGRyZXNzKV0gPSBwbWQ7
CiAKIAlyZXR1cm4gMDsKIH0K
--001517478216bb727b04d13d40e7--
