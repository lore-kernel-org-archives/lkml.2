Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1HYTRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:17:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64008 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab1HYTQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:16:59 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MUbafosBVsycwFjH9sSq8GJumaeq+MKmeUPKD_zyHdGgw@mail.gmail.com>
References: <20110722154219.GA25694@elte.hu> <CACqU3MUxUBzu9frjHLVoHUEKtaDEP+Gn7txm1wbxq=Qkv12ssw@mail.gmail.com>
 <CAObL_7HXMQxf+kYVMutdfAFNrSGYKJF2WPkSeWGK230r_zwskA@mail.gmail.com> <CACqU3MUbafosBVsycwFjH9sSq8GJumaeq+MKmeUPKD_zyHdGgw@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 25 Aug 2011 15:16:36 -0400
X-Google-Sender-Auth: Co6edFU1WpsxsyfWbk1NbslP10k
Message-ID: <CAObL_7Hi7du37D0PiRVFZZ5=yYGLm4oaGNYqQCeVoab5aJ_2NQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.1
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=000e0cd29ad2bd93a804ab5945bd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd29ad2bd93a804ab5945bd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 25, 2011 at 10:06 AM, Arnaud Lacombe <lacombar@gmail.com> wrote=
:
> On Thu, Aug 25, 2011 at 7:51 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>> On Thu, Aug 25, 2011 at 1:58 AM, Arnaud Lacombe <lacombar@gmail.com> wro=
te:
>>> Hi,

>>>
>>> commit 59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93
>>> Author: Andy Lutomirski <luto@mit.edu>
>>> Date: =A0 Wed Jul 13 09:24:10 2011 -0400
>>>
>>> =A0 =A0x86: Make alternative instruction pointers relative
>>>
>>> =A0 =A0This save a few bytes on x86-64 and means that future patches ca=
n
>>> =A0 =A0apply alternatives to unrelocated code.
>>>
>>> =A0 =A0Signed-off-by: Andy Lutomirski <luto@mit.edu>
>>> =A0 =A0Link: http://lkml.kernel.org/r/ff64a6b9a1a3860ca4a7b8b6dc7b4754f=
9491cd7.1310563276.git.luto@mit.edu
>>> =A0 =A0Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>>>
>>
>> I probably missed a hardcoded alternative entry that depends on
>> config. =A0Can you send me your System.map and the output of objdump -s
>> -j .altinstructions vmlinux?
>>
> see attached.
>
>> I'm also having issues building from your .config. =A0Building
>> 59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93 asks me about Moorestown MID
>> platform, Ethernet, etc.
>>
> yes, the config is against -rc3. An `oldnoconfig' should do the job
> before the build.
>

I still can't reproduce this.  I'm building the attached .config on
the v3.1-rc3, running make ARCH=3Di386 oldnoconfig (which spews a lot of
changes), then building with ARCH=3Di386 and test-booting in KVM.   No
panic.

Can you either send me a real .config and exact commit that you're
building or try the attached patch and tell me what it says?

Thanks,
Andy

--000e0cd29ad2bd93a804ab5945bd
Content-Type: text/x-patch; charset=US-ASCII; name="alternative_trace.diff"
Content-Disposition: attachment; filename="alternative_trace.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_grs45m5k0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9hbHRlcm5hdGl2ZS5jIGIvYXJjaC94ODYva2Vy
bmVsL2FsdGVybmF0aXZlLmMKaW5kZXggYzYzODIyOC4uYWM3M2EzOCAxMDA2NDQKLS0tIGEvYXJj
aC94ODYva2VybmVsL2FsdGVybmF0aXZlLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2FsdGVybmF0
aXZlLmMKQEAgLTI3NywxMSArMjc3LDE0IEBAIHZvaWQgX19pbml0X29yX21vZHVsZSBhcHBseV9h
bHRlcm5hdGl2ZXMoc3RydWN0IGFsdF9pbnN0ciAqc3RhcnQsCiAJZm9yIChhID0gc3RhcnQ7IGEg
PCBlbmQ7IGErKykgewogCQlpbnN0ciA9ICh1OCAqKSZhLT5pbnN0cl9vZmZzZXQgKyBhLT5pbnN0
cl9vZmZzZXQ7CiAJCXJlcGxhY2VtZW50ID0gKHU4ICopJmEtPnJlcGxfb2Zmc2V0ICsgYS0+cmVw
bF9vZmZzZXQ7CisJCXByaW50ayhLRVJOX0VSUiAic3RhcnQ9JXAgYT0lZCBpbnN0cl9vZmZzZXQ9
JWQgaW5zdHI9JXBTIHJlcGxfb2Zmc2V0PSVkIHJlcGw9JXBTIGluc3RybGVuPSVkIHJlcGxsZW49
JWRcbiIsIHN0YXJ0LCAoaW50KShhLXN0YXJ0KSwgYS0+aW5zdHJfb2Zmc2V0LCBpbnN0ciwgYS0+
cmVwbF9vZmZzZXQsIHJlcGxhY2VtZW50LCAoaW50KWEtPmluc3RybGVuLCAoaW50KWEtPnJlcGxh
Y2VtZW50bGVuKTsKIAkJQlVHX09OKGEtPnJlcGxhY2VtZW50bGVuID4gYS0+aW5zdHJsZW4pOwog
CQlCVUdfT04oYS0+aW5zdHJsZW4gPiBzaXplb2YoaW5zbmJ1ZikpOwogCQlCVUdfT04oYS0+Y3B1
aWQgPj0gTkNBUElOVFMqMzIpOwotCQlpZiAoIWJvb3RfY3B1X2hhcyhhLT5jcHVpZCkpCisJCWlm
ICghYm9vdF9jcHVfaGFzKGEtPmNwdWlkKSkgeworCQkJcHJpbnRrKEtFUk5fRVJSICIgIG5vIGNo
YW5nZVxuIik7CiAJCQljb250aW51ZTsKKwkJfQogCiAJCW1lbWNweShpbnNuYnVmLCByZXBsYWNl
bWVudCwgYS0+cmVwbGFjZW1lbnRsZW4pOwogCkBAIC0yOTMsNiArMjk2LDggQEAgdm9pZCBfX2lu
aXRfb3JfbW9kdWxlIGFwcGx5X2FsdGVybmF0aXZlcyhzdHJ1Y3QgYWx0X2luc3RyICpzdGFydCwK
IAkJCSBhLT5pbnN0cmxlbiAtIGEtPnJlcGxhY2VtZW50bGVuKTsKIAogCQl0ZXh0X3Bva2VfZWFy
bHkoaW5zdHIsIGluc25idWYsIGEtPmluc3RybGVuKTsKKworCQlwcmludGsoS0VSTl9FUlIgIiAg
ZG9uZVxuIik7CiAJfQogfQogCkBAIC01MzMsNyArNTM4LDkgQEAgdm9pZCBfX2luaXQgYWx0ZXJu
YXRpdmVfaW5zdHJ1Y3Rpb25zKHZvaWQpCiAJICogcGF0Y2hpbmcuCiAJICovCiAKKwlwcmludGso
S0VSTl9FUlIgIkFib3V0IHRvIGFwcGx5X2FsdGVybmF0aXZlc1xuIik7CiAJYXBwbHlfYWx0ZXJu
YXRpdmVzKF9fYWx0X2luc3RydWN0aW9ucywgX19hbHRfaW5zdHJ1Y3Rpb25zX2VuZCk7CisJcHJp
bnRrKEtFUk5fRVJSICJhcHBseV9hbHRlcm5hdGl2ZXMgZG9uZVxuIik7CiAKIAkvKiBzd2l0Y2gg
dG8gcGF0Y2gtb25jZS1hdC1ib290dGltZS1vbmx5IG1vZGUgYW5kIGZyZWUgdGhlCiAJICogdGFi
bGVzIGluIGNhc2Ugd2Uga25vdyB0aGUgbnVtYmVyIG9mIENQVXMgd2lsbCBuZXZlciBldmVyCg==
--000e0cd29ad2bd93a804ab5945bd--
