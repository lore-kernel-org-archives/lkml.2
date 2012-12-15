Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab2LOH5H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 02:57:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49350 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2LOH5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 02:57:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com>
References: <20121211170605.GD28827@liondog.tnic>
	<CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
	<50C76F9E.4080001@zytor.com>
	<CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com>
	<50C7C859.60405@zytor.com>
	<CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com>
	<50C82ABF.3020907@zytor.com>
	<20121212133853.GC8760@liondog.tnic>
	<50C963B1.3040609@zytor.com>
	<50C96717.3020407@zytor.com>
	<20121213191317.GE31485@liondog.tnic>
	<50CA4A7A.10104@zytor.com>
	<CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com>
	<50CB8213.9000908@zytor.com>
	<CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com>
	<CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com>
Date: Fri, 14 Dec 2012 23:57:01 -0800
X-Google-Sender-Auth: 19s1SVv6hkeTZgSZAB-DXvCz7Ec
Message-ID: <CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary=0015173ff11051461004d0df7ef3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015173ff11051461004d0df7ef3
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Dec 14, 2012 at 12:08 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Dec 14, 2012 at 12:04 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Fri, Dec 14, 2012 at 11:46 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> I suspect we don't need init_level4_pgt at all and should just plan to
>>> get rid of it.  Is there any reason we can't just build the proper
>>> kernel page table set in pagetable_init() and switch to it there?
>>
>> then how to pass the info to AP?
>
> also we should merge early_level4_pgt with init_level4_pgt.
>
> and #PE handler could just extend to use BRK ...
>
> but need to make sure BRK get mapped at first, and BRK could cross the
> 1G, 512G boundary ...
>
> that could make things less impact to all.

I tailored your patch and made use 2M page increase to replace patch
ioremap function.

   [PATCH v6 12/27] x86: use io_remap to access real_mode_data

and it will extend init_level4_pgt to map extra range. that will limit
affect to even others.

please check if that is ok to you.

Thanks

Yinghai

--0015173ff11051461004d0df7ef3
Content-Type: application/octet-stream; name="limit_pf_handler.patch"
Content-Disposition: attachment; filename="limit_pf_handler.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_haqgbgyh0

U3ViamVjdDogW1BBVENIXSB4ODYsIDY0Yml0OiB1c2UgI1BFIGhhbmRsZXIgdG8gc2V0dXAgcGFn
ZSB0YWJsZSBmb3IgZGF0YQoKV2UgbmVlZCB0byBhY2Nlc3MgZGF0YSBhcmVhIHRoYXQgaXMgbm90
IG1hcHBlZCBpbiBhcmNoL3g4Ni9rZXJuZWwvaGVhZF82NC5TCnR3byBjYXNlOgphLiBsb2FkIG1p
Y3JvY29kZSBmcm9tIG1pY3JvY29kZQpiLiB3aGVuIHplcm9fcGFnZSBhbmQgY29tbWFuZF9saW5l
IGxzIGxvYWRlZCBoaWdoIGFib3ZlIDFHLgoKd2l0aCB0aGlzIG9uZSwgd2lsbCBkb24ndCBub3Qg
bmVlZCB0byBpb3JlbWFwX2luaXQgYWhlYWQuLi4KCnRoZSBwZ3QgYnVmZmVyIGlzIGZyb20gQlJL
LCBhbmQgd2UgaGF2ZSBlbm91Z2ggc3BhY2UgdGhlcmUuCgpBbHNvIGxhdGVyIGluaXRfbWVtX21h
cHBpbmcgd2lsbCByZXN1c2UgdGhvc2UgcGd0LgoKVGhpcyBwYXRjaCBpcyBtb3N0IGZyb20gSFBB
LgpvdGhlcnMgZnJvbSBZaW5naGFpOgoxLiB1c2UgaXQgd2l0aCBCUksKMi4gb25seSBtYXAgMk0g
b25lIHRpbWUsIGJlY2FzZSB1c2UgemVyb19wYWdlLCBhbmQgY29tbWFuZCBsaW5lIGlzIHZlcnkg
c21hbGwKICAgYWxzbyBtaWNyb2NvZGUgc2hvdWxkIGJlIHNtYWxsIHRvbyAxMjhrID8KICAgYW5k
IHNob3VsZCBub3QgaGl0IHBvc3NpYmxlIGhvbGUgdGhhdCBzaG91bGQgYmUgbWFwcGVkLgozLiBt
YWtlIGl0IHdvcmsgd2l0aCBrZXhlYyB3aGVuIHBoeXNfYmFzZSBpcyBub3QgemVyby4KClNpZ25l
ZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCi0tLQogYXJjaC94ODYv
a2VybmVsL2hlYWQ2NC5jICB8ICAgNTQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKwogYXJjaC94ODYva2VybmVsL2hlYWRfNjQuUyB8ICAgMTMgKysrKysrKyst
LS0KIDIgZmlsZXMgY2hhbmdlZCwgNjQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCklu
ZGV4OiBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2hlYWQ2NC5jCj09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxp
bnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5lbC9oZWFkNjQuYworKysgbGludXgtMi42L2FyY2gv
eDg2L2tlcm5lbC9oZWFkNjQuYwpAQCAtMjYsNiArMjYsNjAgQEAKICNpbmNsdWRlIDxhc20vZTgy
MC5oPgogI2luY2x1ZGUgPGFzbS9iaW9zX2ViZGEuaD4KIAorLyogQ3JlYXRlIGEgbmV3IFBNRCBl
bnRyeSAqLworaW50IF9faW5pdCBlYXJseV9tYWtlX3BndGFibGUodW5zaWduZWQgbG9uZyBhZGRy
ZXNzKQoreworCXVuc2lnbmVkIGxvbmcgcGh5c2FkZHIgPSBhZGRyZXNzIC0gX19QQUdFX09GRlNF
VDsKKwl1bnNpZ25lZCBsb25nIGk7CisJcGdkdmFsX3QgcGdkLCAqcGdkX3A7CisJcHVkdmFsX3Qg
cHVkLCAqcHVkX3A7CisJcG1kdmFsX3QgcG1kLCAqcG1kX3A7CisKKwlpZiAoYWRkcmVzcyA8IF9f
UEFHRV9PRkZTRVQgfHwgcGh5c2FkZHIgPj0gTUFYTUVNKQorCQlyZXR1cm4gLTE7CS8qIEludmFs
aWQgYWRkcmVzcyAtIHB1a2UgKi8KKworCXBnZF9wID0gJmluaXRfbGV2ZWw0X3BndFtwZ2RfaW5k
ZXgoYWRkcmVzcyldLnBnZDsKKwlwZ2QgPSAqcGdkX3A7CisKKwkvKgorCSAqIFRoZSB1c2Ugb2Yg
X19TVEFSVF9LRVJORUxfbWFwIHJhdGhlciB0aGFuIF9fUEFHRV9PRkZTRVQgaGVyZSBpcworCSAq
IGNyaXRpY2FsIC0tIF9fUEFHRV9PRkZTRVQgd291bGQgcG9pbnQgdXMgYmFjayBpbnRvIHRoZSBk
eW5hbWljCisJICogcmFuZ2UgYW5kIHdlIG1pZ2h0IGVuZCB1cCBsb29waW5nIGZvcmV2ZXIuLi4K
KwkgKi8KKwlpZiAocGdkKQorCQlwdWRfcCA9IChwdWR2YWxfdCAqKSgocGdkICYgUFRFX1BGTl9N
QVNLKSArIF9fU1RBUlRfS0VSTkVMX21hcCAtIHBoeXNfYmFzZSk7CisJZWxzZSB7CisJCWlmICgo
Y2hhciAqKShfYnJrX2VuZCArIFBBR0VfU0laRSkgPiBfX2Jya19saW1pdCkKKwkJCXJldHVybiAt
MTsKKwkJcHVkX3AgPSAocHVkdmFsX3QgKilfYnJrX2VuZDsKKwkJX2Jya19lbmQgKz0gUEFHRV9T
SVpFOworCisJCWZvciAoaSA9IDA7IGkgPCBQVFJTX1BFUl9QVUQ7IGkrKykKKwkJCXB1ZF9wW2ld
ID0gMDsKKwkJKnBnZF9wID0gKHBnZHZhbF90KXB1ZF9wIC0gX19TVEFSVF9LRVJORUxfbWFwICsg
cGh5c19iYXNlICsgX0tFUk5QR19UQUJMRTsKKwl9CisJcHVkX3AgKz0gcHVkX2luZGV4KGFkZHJl
c3MpOworCXB1ZCA9ICpwdWRfcDsKKworCWlmIChwdWQpCisJCXBtZF9wID0gKHBtZHZhbF90ICop
KChwdWQgJiBQVEVfUEZOX01BU0spICsgX19TVEFSVF9LRVJORUxfbWFwIC0gcGh5c19iYXNlKTsK
KwllbHNlIHsKKwkJaWYgKChjaGFyICopKF9icmtfZW5kICsgUEFHRV9TSVpFKSA+IF9fYnJrX2xp
bWl0KQorCQkJcmV0dXJuIC0xOworCQlwbWRfcCA9IChwbWR2YWxfdCAqKV9icmtfZW5kOworCQlf
YnJrX2VuZCArPSBQQUdFX1NJWkU7CisKKwkJZm9yIChpID0gMDsgaSA8IFBUUlNfUEVSX1BNRDsg
aSsrKQorCQkJcG1kX3BbaV0gPSAwOworCQkqcHVkX3AgPSAocHVkdmFsX3QpcG1kX3AgLSBfX1NU
QVJUX0tFUk5FTF9tYXAgKyBwaHlzX2Jhc2UgKyBfS0VSTlBHX1RBQkxFOworCX0KKwlwbWQgPSAo
cGh5c2FkZHIgJiBQTURfTUFTSykgKyBfX1BBR0VfS0VSTkVMX0xBUkdFOworCXBtZF9wW3BtZF9p
bmRleChhZGRyZXNzKV0gPSBwbWQ7CisKKwlyZXR1cm4gMDsKK30KKworCiBzdGF0aWMgdm9pZCBf
X2luaXQgemFwX2lkZW50aXR5X21hcHBpbmdzKHZvaWQpCiB7CiAJcGdkX3QgKnBnZCA9IHBnZF9v
ZmZzZXRfaygwVUwpOwpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9oZWFkXzY0LlMK
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL2hlYWRfNjQuUwor
KysgbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9oZWFkXzY0LlMKQEAgLTQ5NCwxNCArNDk0LDIx
IEBAIEVOVFJZKGVhcmx5X2lkdF9oYW5kbGVyKQogCXB1c2hxICVyMTEJCSMgIDAoJXJzcCkKIAog
CWNtcGwgJF9fS0VSTkVMX0NTLDk2KCVyc3ApCi0Jam5lIDEwZgorCWpuZSAxMWYKIAorCWNtcGwg
JDE0LDcyKCVyc3ApICAgICAgICMgUGFnZSBmYXVsdD8KKwlqbnogMTBmCisJR0VUX0NSMl9JTlRP
KCVyZGkpICAgICAgIyBjYW4gY2xvYmJlciBhbnkgdm9sYXRpbGUgcmVnaXN0ZXIgaWYgcHYKKwlj
YWxsIGVhcmx5X21ha2VfcGd0YWJsZQorCWFuZGwgJWVheCwlZWF4CisJanogMjBmICAgICAgICAg
ICAgICAgICAgIyBBbGwgZ29vZAorMTA6CiAJbGVhcSA4OCglcnNwKSwlcmRpCSMgUG9pbnRlciB0
byAlcmlwCiAJY2FsbCBlYXJseV9maXh1cF9leGNlcHRpb24KIAlhbmRsICVlYXgsJWVheAogCWpu
eiAyMGYJCQkjIEZvdW5kIGFuIGV4Y2VwdGlvbiBlbnRyeQogCi0xMDoKKzExOgogI2lmZGVmIENP
TkZJR19FQVJMWV9QUklOVEsKIAlHRVRfQ1IyX0lOVE8oJXI5KQkjIGNhbiBjbG9iYmVyIGFueSB2
b2xhdGlsZSByZWdpc3RlciBpZiBwdgogCW1vdmwgODAoJXJzcCksJXI4ZAkjIGVycm9yIGNvZGUK
QEAgLTUyMyw3ICs1MzAsNyBAQCBFTlRSWShlYXJseV9pZHRfaGFuZGxlcikKIDE6CWhsdAogCWpt
cCAxYgogCi0yMDoJIyBFeGNlcHRpb24gdGFibGUgZW50cnkgZm91bmQKKzIwOgkjIEV4Y2VwdGlv
biB0YWJsZSBlbnRyeSBmb3VuZCBvciBwYWdlIHRhYmxlIGdlbmVyYWdlZC4KIAlwb3BxICVyMTEK
IAlwb3BxICVyMTAKIAlwb3BxICVyOQo=
--0015173ff11051461004d0df7ef3--
