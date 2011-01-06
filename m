Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1AFNMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 08:12:13 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34958 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab1AFNML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:12:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QKqqHcW8+EP8b0UqhS2yULDgyPmk+bHmz5aQxjbK0uxpTX7qtsiaafzVEE04aDD8+E
         PrNU+g891mVz05oe9XuHc2Vz6JGRAnkrwL+XXc7u93e8eLJ6EETpgh8GZZkTytgbL/ID
         /8/WwCosx7B65AQTGr4zt5LAuFdkQjNkJ6jbA=
MIME-Version: 1.0
In-Reply-To: <AANLkTimtrinH-7tnGE2zxtoNNTEnqqD3ZDTTTWM-m0Uk@mail.gmail.com>
References: <8679.1294247741@localhost>
	<AANLkTimtrinH-7tnGE2zxtoNNTEnqqD3ZDTTTWM-m0Uk@mail.gmail.com>
Date: Fri, 7 Jan 2011 00:12:09 +1100
Message-ID: <AANLkTi=nVJNJdBChyuD43sqWEf3O_1tDj0FTO8O_Ukib@mail.gmail.com>
Subject: Re: 2.6.37-next - kernel BUG at fs/dcache.c:1363
From: Nick Piggin <npiggin@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Joel Becker <joel.becker@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0ce0424acdc05d04992d3f77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0ce0424acdc05d04992d3f77
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 6, 2011 at 9:44 PM, Nick Piggin <npiggin@gmail.com> wrote:
> On Thu, Jan 6, 2011 at 4:15 AM, =A0<Valdis.Kletnieks@vt.edu> wrote:
>> Saw this crash on a linux-next pulled yesterday at 2PM EST, kernel dies =
very
>> early (looks like first time it touches configfs for anything - trying t=
o boot
>> with netconsole enabled caused it to die even faster). =A0I can bisect t=
his if
>> it doesn't immediately ring a bell...
>
> Thanks, bah configfs isn't widely used.
>
>
>> It dies here:
>>
>> void d_set_d_op(struct dentry *dentry, const struct dentry_operations *o=
p)
>> {
>> =A0 =A0 =A0 =A0BUG_ON(dentry->d_op);
>>
>> Am guessing configfs passed in a dentry that wasn't filled in enough.
>>
>> (hand-transcribed from a crappy cellphone pic)
>>
>> kernel BUG at fs/dcache.c:1363
>
> Thanks. It actually passed in a dentry that appears to have already been
> used for something. This is not exactly a nice thing for a filesystem to =
do
> and probably indicates an underlying bug anyway (or at least something
> the vfs doesn't guarantee the safety of).
>
> Taking a look now.

This patch fixes it here

--000e0ce0424acdc05d04992d3f77
Content-Type: application/octet-stream; name="dentry-debug.patch"
Content-Disposition: attachment; filename="dentry-debug.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gilojamu0

Y29uZmlnIGZzOiBhdm9pZCBzd2l0Y2hpbmcgLT5kX29wIG9uIGxpdmUgZGVudHJ5CgpTd2l0Y2hp
bmcgZF9vcCBvbiBhIGxpdmUgZGVudHJ5IGlzIHJhY3kgaW4gZ2VuZXJhbCwgc28gYXZvaWQgaXQu
IEluIHRoaXMgY2FzZQppdCBpcyBhIG5lZ2F0aXZlIGRlbnRyeSwgd2hpY2ggaXMgc2FmZXIsIGJ1
dCB0aGVyZSBhcmUgc3RpbGwgY29uY3VycmVudCBvcHMKd2hpY2ggbWF5IGJlIGNhbGxlZCBvbiBk
X29wIGluIHRoYXQgY2FzZSAoZWcuIGRfcmV2YWxpZGF0ZSkuIFNvIGluIGdlbmVyYWwKYSBmaWxl
c3lzdGVtIG1heSBub3QgZG8gdGhpcy4gRml4IGNvbmZpZ2ZzIHNvIGFzIG5vdCB0byBkbyB0aGlz
LgoKW3RvIGJlIGJhY2ttZXJnZWQgb3IgcmVwbGFjZWQgd2l0aCBBbCBWaXJvJ3MgYWx0ZXJuYXRp
dmVdCgpTaWduZWQtb2ZmLWJ5OiBOaWNrIFBpZ2dpbiA8bnBpZ2dpbkBrZXJuZWwuZGs+CgpJbmRl
eDogbGludXgtMi42L2ZzL2NvbmZpZ2ZzL2Rpci5jCj09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5v
cmlnL2ZzL2NvbmZpZ2ZzL2Rpci5jCTIwMTEtMDEtMDYgMjE6NTU6NTguMDAwMDAwMDAwICsxMTAw
CisrKyBsaW51eC0yLjYvZnMvY29uZmlnZnMvZGlyLmMJMjAxMS0wMS0wNyAwMDowNjo0My4wMDAw
MDAwMDAgKzExMDAKQEAgLTIzMiwxMCArMjMyLDggQEAgaW50IGNvbmZpZ2ZzX21ha2VfZGlyZW50
KHN0cnVjdCBjb25maWdmcwogCiAJc2QtPnNfbW9kZSA9IG1vZGU7CiAJc2QtPnNfZGVudHJ5ID0g
ZGVudHJ5OwotCWlmIChkZW50cnkpIHsKKwlpZiAoZGVudHJ5KQogCQlkZW50cnktPmRfZnNkYXRh
ID0gY29uZmlnZnNfZ2V0KHNkKTsKLQkJZF9zZXRfZF9vcChkZW50cnksICZjb25maWdmc19kZW50
cnlfb3BzKTsKLQl9CiAKIAlyZXR1cm4gMDsKIH0KQEAgLTI3OCw3ICsyNzYsNiBAQCBzdGF0aWMg
aW50IGNyZWF0ZV9kaXIoc3RydWN0IGNvbmZpZ19pdGVtCiAJCWVycm9yID0gY29uZmlnZnNfY3Jl
YXRlKGQsIG1vZGUsIGluaXRfZGlyKTsKIAkJaWYgKCFlcnJvcikgewogCQkJaW5jX25saW5rKHAt
PmRfaW5vZGUpOwotCQkJZF9zZXRfZF9vcCgoZCksICZjb25maWdmc19kZW50cnlfb3BzKTsKIAkJ
fSBlbHNlIHsKIAkJCXN0cnVjdCBjb25maWdmc19kaXJlbnQgKnNkID0gZC0+ZF9mc2RhdGE7CiAJ
CQlpZiAoc2QpIHsKQEAgLTM3MSw5ICszNjgsNyBAQCBpbnQgY29uZmlnZnNfY3JlYXRlX2xpbmso
c3RydWN0IGNvbmZpZ2ZzCiAJCQkJICAgQ09ORklHRlNfSVRFTV9MSU5LKTsKIAlpZiAoIWVycikg
ewogCQllcnIgPSBjb25maWdmc19jcmVhdGUoZGVudHJ5LCBtb2RlLCBpbml0X3N5bWxpbmspOwot
CQlpZiAoIWVycikKLQkJCWRfc2V0X2Rfb3AoZGVudHJ5LCAmY29uZmlnZnNfZGVudHJ5X29wcyk7
Ci0JCWVsc2UgeworCQlpZiAoZXJyKSB7CiAJCQlzdHJ1Y3QgY29uZmlnZnNfZGlyZW50ICpzZCA9
IGRlbnRyeS0+ZF9mc2RhdGE7CiAJCQlpZiAoc2QpIHsKIAkJCQlzcGluX2xvY2soJmNvbmZpZ2Zz
X2RpcmVudF9sb2NrKTsKQEAgLTQ5Miw3ICs0ODcsMTEgQEAgc3RhdGljIHN0cnVjdCBkZW50cnkg
KiBjb25maWdmc19sb29rdXAocwogCQkgKiBJZiBpdCBkb2Vzbid0IGV4aXN0IGFuZCBpdCBpc24n
dCBhIE5PVF9QSU5ORUQgaXRlbSwKIAkJICogaXQgbXVzdCBiZSBuZWdhdGl2ZS4KIAkJICovCi0J
CXJldHVybiBzaW1wbGVfbG9va3VwKGRpciwgZGVudHJ5LCBuZCk7CisJCWlmIChkZW50cnktPmRf
bmFtZS5sZW4gPiBOQU1FX01BWCkKKwkJCXJldHVybiBFUlJfUFRSKC1FTkFNRVRPT0xPTkcpOwor
CQlkX3NldF9kX29wKGRlbnRyeSwgJmNvbmZpZ2ZzX2RlbnRyeV9vcHMpOworCQlkX2FkZChkZW50
cnksIE5VTEwpOworCQlyZXR1cm4gTlVMTDsKIAl9CiAKIG91dDoKQEAgLTY4NCw2ICs2ODMsNyBA
QCBzdGF0aWMgaW50IGNyZWF0ZV9kZWZhdWx0X2dyb3VwKHN0cnVjdCBjCiAJcmV0ID0gLUVOT01F
TTsKIAljaGlsZCA9IGRfYWxsb2MocGFyZW50LCAmbmFtZSk7CiAJaWYgKGNoaWxkKSB7CisJCWRf
c2V0X2Rfb3AoY2hpbGQsICZjb25maWdmc19kZW50cnlfb3BzKTsKIAkJZF9hZGQoY2hpbGQsIE5V
TEwpOwogCiAJCXJldCA9IGNvbmZpZ2ZzX2F0dGFjaF9ncm91cCgmcGFyZW50X2dyb3VwLT5jZ19p
dGVtLApAQCAtMTY4MSw2ICsxNjgxLDcgQEAgaW50IGNvbmZpZ2ZzX3JlZ2lzdGVyX3N1YnN5c3Rl
bShzdHJ1Y3QgYwogCWVyciA9IC1FTk9NRU07CiAJZGVudHJ5ID0gZF9hbGxvYyhjb25maWdmc19z
Yi0+c19yb290LCAmbmFtZSk7CiAJaWYgKGRlbnRyeSkgeworCQlkX3NldF9kX29wKGRlbnRyeSwg
JmNvbmZpZ2ZzX2RlbnRyeV9vcHMpOwogCQlkX2FkZChkZW50cnksIE5VTEwpOwogCiAJCWVyciA9
IGNvbmZpZ2ZzX2F0dGFjaF9ncm91cChzZC0+c19lbGVtZW50LCAmZ3JvdXAtPmNnX2l0ZW0sCg==
--000e0ce0424acdc05d04992d3f77--
