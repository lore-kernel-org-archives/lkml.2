Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab0HCU5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:57:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37943 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab0HCU5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=d0BDSjltRj4HjwwycZEsEq7e9tlL4k0LxiDJqmLqdLHgcf6CuI9xicWiHTrecHKcI7
         ViIUmd8ixterI3L4cbyULL1pyEPKA1AG2Gs1tAmgm8S55brh1DBaX11QpIOJwD3dIiHS
         GdHnCMa9/vAr3iBVMadaeMsqqrVTuf3o20xmc=
MIME-Version: 1.0
In-Reply-To: <201008031659.58736.tvrtko.ursulin@sophos.com>
References: <201008031028.57263.tvrtko.ursulin@sophos.com>
	<201008031557.04613.tvrtko.ursulin@sophos.com>
	<201008031617.21418.tvrtko.ursulin@sophos.com>
	<201008031659.58736.tvrtko.ursulin@sophos.com>
Date: Tue, 3 Aug 2010 13:57:48 -0700
X-Google-Sender-Auth: 9Kso7WUhxV_xBWycqt-vDQM578o
Message-ID: <AANLkTi=WDRCcmpi_VrEm1b18Hep0KgAXX0KY5Xo5sywf@mail.gmail.com>
Subject: Re: 2.6.35 hangs on early boot in KVM
From: Yinghai Lu <yinghai@kernel.org>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: multipart/mixed; boundary=0015174c4510ce8daa048cf19152
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174c4510ce8daa048cf19152
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 3, 2010 at 8:59 AM, Tvrtko Ursulin
<tvrtko.ursulin@sophos.com> wrote:
> On Tuesday 03 Aug 2010 16:17:20 Tvrtko Ursulin wrote:
>> On Tuesday 03 Aug 2010 15:57:03 Tvrtko Ursulin wrote:
>> > On Tuesday 03 Aug 2010 15:51:08 Avi Kivity wrote:
>> > > =A0 On 08/03/2010 12:28 PM, Tvrtko Ursulin wrote:
>> > > > I have basically built 2.6.35 with make oldconfig from a working
>> > > > 2.6.34. Latter works fine in kvm while 2.6.35 hangs very early. I =
see
>> > > > nothing after grub (have early printk and verbose bootup enabled),
>> > > > just a blinking VGA cursor and CPU at 100%.
>> > >
>> > > Please copy kvm@vger.kernel.org on kvm issues.
>> > >
>> > > > CONFIG_PRINTK_TIME=3Dy
>> > >
>> > > Try disabling this as a workaround.
>> >
>> > I am in the middle of a bisect run with five builds left to go, curren=
tly
>> > I have:
>> >
>> > bad 537b60d17894b7c19a6060feae40299d7109d6e7
>> > good 93c9d7f60c0cb7715890b1f9e159da6f4d1f5a65
>>
>> Bisect is looking good, narrowed it to ten revisions, but I am not sure =
to
>> make it to the end today:
>>
>> bad cb41838bbc4403f7270a94b93a9a0d9fc9c2e7ea
>> good 41d59102e146a4423a490b8eca68a5860af4fe1c
>
> Bisect points the finger to "x86, ioapic: In mpparse use mp_register_ioap=
ic"
> (cf7500c0ea133d66f8449d86392d83f840102632), so I am copying Eric. No idea
> whether this commit is solely to blame or it is a combined interaction wi=
th
> KVM, but I am sure you guys will know.
>
> If you want me to test something else please shout.
>

please try attached patch, to see if it help.

Yinghai

--0015174c4510ce8daa048cf19152
Content-Type: text/x-patch; charset=US-ASCII; name="smp_mptable_2.patch"
Content-Disposition: attachment; filename="smp_mptable_2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gcf8ayz70

W1BBVENIXSB4ODY6IGNoZWNrIGlmIGFwaWMvcGluIGlzIHNoYXJlZCB3aXRoIGxlZ2FjeSBvbmUK
CmZpeCBzeXN0ZW0gdGhhdCBleHRlcm5hbCBkZXZpY2UgdGhhdCBoYXZlIGlvIGFwaWMgb24gYXBp
YzAvcGluKDAtMTUpCgphbHNvCmZvciB0aGUgaW8gYXBpYyBvdXQgb2Ygb3JkZXIgc3lzdGVtOgo8
Nj5BQ1BJOiBJT0FQSUMgKGlkWzB4MTBdIGFkZHJlc3NbMHhmZWNmZjAwMF0gZ3NpX2Jhc2VbMF0p
Cjw2PklPQVBJQ1swXTogYXBpY19pZCAxNiwgdmVyc2lvbiAwLCBhZGRyZXNzIDB4ZmVjZmYwMDAs
IEdTSSAwLTIKPDY+QUNQSTogSU9BUElDIChpZFsweDBmXSBhZGRyZXNzWzB4ZmVjMDAwMDBdIGdz
aV9iYXNlWzNdKQo8Nj5JT0FQSUNbMV06IGFwaWNfaWQgMTUsIHZlcnNpb24gMCwgYWRkcmVzcyAw
eGZlYzAwMDAwLCBHU0kgMy0zOAo8Nj5BQ1BJOiBJT0FQSUMgKGlkWzB4MGVdIGFkZHJlc3NbMHhm
ZWMwMTAwMF0gZ3NpX2Jhc2VbMzldKQo8Nj5JT0FQSUNbMl06IGFwaWNfaWQgMTQsIHZlcnNpb24g
MCwgYWRkcmVzcyAweGZlYzAxMDAwLCBHU0kgMzktNzQKPDY+QUNQSTogSU5UX1NSQ19PVlIgKGJ1
cyAwIGJ1c19pcnEgMSBnbG9iYWxfaXJxIDQgZGZsIGRmbCkKPDY+QUNQSTogSU5UX1NSQ19PVlIg
KGJ1cyAwIGJ1c19pcnEgMCBnbG9iYWxfaXJxIDUgZGZsIGRmbCkKPDY+QUNQSTogSU5UX1NSQ19P
VlIgKGJ1cyAwIGJ1c19pcnEgMyBnbG9iYWxfaXJxIDYgZGZsIGRmbCkKPDY+QUNQSTogSU5UX1NS
Q19PVlIgKGJ1cyAwIGJ1c19pcnEgNCBnbG9iYWxfaXJxIDcgZGZsIGRmbCkKPDY+QUNQSTogSU5U
X1NSQ19PVlIgKGJ1cyAwIGJ1c19pcnEgNiBnbG9iYWxfaXJxIDkgZGZsIGRmbCkKPDY+QUNQSTog
SU5UX1NSQ19PVlIgKGJ1cyAwIGJ1c19pcnEgNyBnbG9iYWxfaXJxIDEwIGRmbCBkZmwpCjw2PkFD
UEk6IElOVF9TUkNfT1ZSIChidXMgMCBidXNfaXJxIDggZ2xvYmFsX2lycSAxMSBsb3cgZWRnZSkK
PDY+QUNQSTogSU5UX1NSQ19PVlIgKGJ1cyAwIGJ1c19pcnEgOSBnbG9iYWxfaXJxIDEyIGRmbCBk
ZmwpCjw2PkFDUEk6IElOVF9TUkNfT1ZSIChidXMgMCBidXNfaXJxIDEyIGdsb2JhbF9pcnEgMTUg
ZGZsIGRmbCkKPDY+QUNQSTogSU5UX1NSQ19PVlIgKGJ1cyAwIGJ1c19pcnEgMTMgZ2xvYmFsX2ly
cSAxNiBkZmwgZGZsKQo8Nj5BQ1BJOiBJTlRfU1JDX09WUiAoYnVzIDAgYnVzX2lycSAxNCBnbG9i
YWxfaXJxIDE3IGxvdyBlZGdlKQo8Nj5BQ1BJOiBJTlRfU1JDX09WUiAoYnVzIDAgYnVzX2lycSAx
NSBnbG9iYWxfaXJxIDE4IGRmbCBkZmwpCgphZnRlciB0aGlzIHBhdGNoIHdpbGwgZ2V0CgphcGlj
MCwgcGluMCwgR1NJIDA6IGlycSAwKzc1CmFwaWMwLCBwaW4xLCBHU0kgMTogaXJxIDErNzUKYXBp
YzAsIHBpbjIsIEdTSSAyOiBpcnEgMgphcGljMSwgcGluMCwgR1NJIDM6IGlycSAzKzc1CmFwaWMx
LCBwaW41LCBHU0kgODogaXJxIDgrNzUKYXBpYzEsIHBpbjEwLEdTSSAxMzogaXJxIDEzKzc1CmFw
aWMxLCBwaW4xMSxHU0kgMTQ6IGlycSAxNCs3NQoKYmVjYXVzZSBtcF9jb25maWdfYWNwaV9sZWdh
Y3lfaXJxcyB3aWxsIHB1dCBhcGljMCwgcGluMiwgaXJxMiBpbiBtcF9pcnFzLi4uCnNvIHBpbl8y
X2lycV9sZWdhY3kgd2lsbCByZXBvcnQgMi4KaXJxX3RvX2dzaSB3aWxsIHN0aWxsIHJlcG9ydCAy
LiBzbyBpdCBpcyByaWdodC4KZ3NpX3RvX2lycSB3aWxsIHJlcG9ydCAyLgoKZm9yIDAsIDEsIDMs
IDgsIDEzLCAxNDogc3RpbGwgcmlnaHQKClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdo
YWlAa2VybmVsLm9yZz4KCi0tLQogYXJjaC94ODYva2VybmVsL2FwaWMvaW9fYXBpYy5jIHwgICAz
MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMjggaW5z
ZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYva2Vy
bmVsL2FwaWMvaW9fYXBpYy5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2
L2tlcm5lbC9hcGljL2lvX2FwaWMuYworKysgbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9hcGlj
L2lvX2FwaWMuYwpAQCAtMTAxMyw2ICsxMDEzLDI4IEBAIHN0YXRpYyBpbmxpbmUgaW50IGlycV90
cmlnZ2VyKGludCBpZHgpCiAJcmV0dXJuIE1QQklPU190cmlnZ2VyKGlkeCk7CiB9CiAKK3N0YXRp
YyBpbnQgcGluXzJfaXJxX2xlYWdjeShpbnQgYXBpYywgaW50IHBpbikKK3sKKwlpbnQgaTsKKwor
CWZvciAoaSA9IDA7IGkgPCBtcF9pcnFfZW50cmllczsgaSsrKSB7CisJCWludCBidXMgPSBtcF9p
cnFzW2ldLnNyY2J1czsKKworCQlpZiAoIXRlc3RfYml0KGJ1cywgbXBfYnVzX25vdF9wY2kpKQor
CQkJY29udGludWU7CisKKwkJaWYgKG1wX2lvYXBpY3NbYXBpY10uYXBpY2lkICE9IG1wX2lycXNb
aV0uZHN0YXBpYykKKwkJCWNvbnRpbnVlOworCisJCWlmIChtcF9pcnFzW2ldLmRzdGlycSAhPSBw
aW4pCisJCQljb250aW51ZTsKKworCQlyZXR1cm4gbXBfaXJxc1tpXS5zcmNidXNpcnE7CisJfQor
CisJcmV0dXJuIC0xOworfQorCiBzdGF0aWMgaW50IHBpbl8yX2lycShpbnQgaWR4LCBpbnQgYXBp
YywgaW50IHBpbikKIHsKIAlpbnQgaXJxOwpAQCAtMTAyOSwxMCArMTA1MSwxMyBAQCBzdGF0aWMg
aW50IHBpbl8yX2lycShpbnQgaWR4LCBpbnQgYXBpYywKIAl9IGVsc2UgewogCQl1MzIgZ3NpID0g
bXBfZ3NpX3JvdXRpbmdbYXBpY10uZ3NpX2Jhc2UgKyBwaW47CiAKLQkJaWYgKGdzaSA+PSBOUl9J
UlFTX0xFR0FDWSkKKwkJaWYgKGdzaSA+PSBOUl9JUlFTX0xFR0FDWSkgewogCQkJaXJxID0gZ3Np
OwotCQllbHNlCi0JCQlpcnEgPSBnc2lfdG9wICsgZ3NpOworCQl9IGVsc2UgeworCQkJaXJxID0g
cGluXzJfaXJxX2xlZ2FjeShhcGljLCBwaW4pOworCQkJaWYgKGlycSA8IDApCisJCQkJaXJxID0g
Z3NpX3RvcCArIGdzaTsKKwkJfQogCX0KIAogI2lmZGVmIENPTkZJR19YODZfMzIK
--0015174c4510ce8daa048cf19152--
