Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab1ACKEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 05:04:51 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44416 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1ACKEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 05:04:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=g800I2W/UIxdhyr79QOk0hTXaXaetKTQg50YerLJLlz6QcCUhL6FmkRdZbyrefVjzP
         Yvtsalivx7Sjre1mI5pQu+G3dV/Can1RsWFI4Pvhd1eehhh45n2onP3wba5CQIPdQwaW
         ce8mKfduKwLLZm8AVFjTotdIryhfVJWDWXCh8=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110103015231.1a0e6997@queued.net>
References: <1294023088-31687-1-git-send-email-sedat.dilek@gmail.com>
	<20110103015231.1a0e6997@queued.net>
Date: Mon, 3 Jan 2011 11:04:48 +0100
Message-ID: <AANLkTimpfSxxyDYQ5SzJ9XtOOhNxGBtY48dLpnjMGMq5@mail.gmail.com>
Subject: Re: [PATCH] misc/cs5535: Fix section mismatch derived from
 cs5535_mfgpt_drv variable
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: sameo@linux.intel.com, akpm@linux-foundation.org, tj@kernel.org,
        joe@perches.com, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016364ed8684430860498ee48bc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364ed8684430860498ee48bc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 3, 2011 at 10:52 AM, Andres Salomon <dilinger@queued.net> wrote=
:
> On Mon, =C2=A03 Jan 2011 03:51:28 +0100
> Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>
>> From my build.log:
>>
>> WARNING: drivers/misc/cs5535-mfgpt.o(.data+0x0): Section mismatch in
>> reference from the variable cs5535_mfgpt_drv to the
>> function .devinit.text:cs5535_mfgpt_probe() The variable
>> cs5535_mfgpt_drv references the function __devinit
>> cs5535_mfgpt_probe() If the reference is valid then annotate the
>> variable with __init* or __refdata (see linux/init.h) or name the
>> variable: *driver, *_template, *_timer, *_sht, *_ops, *_probe,
>> *_probe_one, *_console,
>>
>> This patch fixes the warning.
>>
>> Tested with linux-next (next-20101231)
>>
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>> ---
>> =C2=A0drivers/misc/cs5535-mfgpt.c | =C2=A0 =C2=A02 +-
>> =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
>> index d02d302..d80bd14 100644
>> --- a/drivers/misc/cs5535-mfgpt.c
>> +++ b/drivers/misc/cs5535-mfgpt.c
>> @@ -329,7 +329,7 @@ done:
>> =C2=A0 =C2=A0 =C2=A0 return err;
>> =C2=A0}
>>
>> -static struct platform_driver cs5535_mfgpt_drv =3D {
>> +static struct platform_driver cs5535_mfgpt_drv __refdata =3D {
>> =C2=A0 =C2=A0 =C2=A0 .driver =3D {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .name =3D DRV_NAME,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .owner =3D THIS_MODULE,
>
> Hm, I'm confused. =C2=A0There are plenty of other drivers in mfd/ and gpi=
o/
> that have their probe/remove functions marked as __dev{init,exit}, with
> their associated platform_driver definitions not marked with any kind
> of init marking. =C2=A0Are they all generating this warning and getting
> the same __refdata treatment?
>

Yes, there is also a section mismatch in "drivers/misc/ioc4.c" (see P.S.).
I hadn't time to look at it as it was very late 3 or 4 a.m. (and first
time sending patches via git-send-email :-)).

There are still some more section mismatches in other sub-trees, for
example "drivers/mtd/devices/sst25l.c" which I haven't catched.
If someone can look at it?

- Sedat -

P.S.: From my build_linux-next_next20101231.dileks.4.log:

WARNING: drivers/misc/ioc4.o(.data+0xc): Section mismatch in reference
from the variable ioc4_load_modules_work to the function
.devinit.text:ioc4_load_modules()
The variable ioc4_load_modules_work references
the function __devinit ioc4_load_modules()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console=
,

- EOT -

--0016364ed8684430860498ee48bc
Content-Type: text/plain; charset=US-ASCII; name="all-section-mismatches.txt"
Content-Disposition: attachment; filename="all-section-mismatches.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gih7ccjg0

V0FSTklORzogZHJpdmVycy92aWRlby9nZW9kZS9neDFmYi5vKC5kYXRhKzB4NTQpOiBTZWN0aW9u
IG1pc21hdGNoIGluIHJlZmVyZW5jZSBmcm9tIHRoZSB2YXJpYWJsZSBneDFmYl9kcml2ZXIgdG8g
dGhlIGZ1bmN0aW9uIC5pbml0LnRleHQ6Z3gxZmJfcHJvYmUoKQpUaGUgdmFyaWFibGUgZ3gxZmJf
ZHJpdmVyIHJlZmVyZW5jZXMKdGhlIGZ1bmN0aW9uIF9faW5pdCBneDFmYl9wcm9iZSgpCklmIHRo
ZSByZWZlcmVuY2UgaXMgdmFsaWQgdGhlbiBhbm5vdGF0ZSB0aGUKdmFyaWFibGUgd2l0aCBfX2lu
aXQqIG9yIF9fcmVmZGF0YSAoc2VlIGxpbnV4L2luaXQuaCkgb3IgbmFtZSB0aGUgdmFyaWFibGU6
CipfdGVtcGxhdGUsICpfdGltZXIsICpfc2h0LCAqX29wcywgKl9wcm9iZSwgKl9wcm9iZV9vbmUs
ICpfY29uc29sZSwgCgotLQpXQVJOSU5HOiBkcml2ZXJzL21pc2MvY3M1NTM1LW1mZ3B0Lm8oLmRh
dGErMHgwKTogU2VjdGlvbiBtaXNtYXRjaCBpbiByZWZlcmVuY2UgZnJvbSB0aGUgdmFyaWFibGUg
Y3M1NTM1X21mZ3B0X2RydiB0byB0aGUgZnVuY3Rpb24gLmRldmluaXQudGV4dDpjczU1MzVfbWZn
cHRfcHJvYmUoKQpUaGUgdmFyaWFibGUgY3M1NTM1X21mZ3B0X2RydiByZWZlcmVuY2VzCnRoZSBm
dW5jdGlvbiBfX2RldmluaXQgY3M1NTM1X21mZ3B0X3Byb2JlKCkKSWYgdGhlIHJlZmVyZW5jZSBp
cyB2YWxpZCB0aGVuIGFubm90YXRlIHRoZQp2YXJpYWJsZSB3aXRoIF9faW5pdCogb3IgX19yZWZk
YXRhIChzZWUgbGludXgvaW5pdC5oKSBvciBuYW1lIHRoZSB2YXJpYWJsZToKKmRyaXZlciwgKl90
ZW1wbGF0ZSwgKl90aW1lciwgKl9zaHQsICpfb3BzLCAqX3Byb2JlLCAqX3Byb2JlX29uZSwgKl9j
b25zb2xlLCAKCldBUk5JTkc6IGRyaXZlcnMvbWlzYy9pb2M0Lm8oLmRhdGErMHhjKTogU2VjdGlv
biBtaXNtYXRjaCBpbiByZWZlcmVuY2UgZnJvbSB0aGUgdmFyaWFibGUgaW9jNF9sb2FkX21vZHVs
ZXNfd29yayB0byB0aGUgZnVuY3Rpb24gLmRldmluaXQudGV4dDppb2M0X2xvYWRfbW9kdWxlcygp
ClRoZSB2YXJpYWJsZSBpb2M0X2xvYWRfbW9kdWxlc193b3JrIHJlZmVyZW5jZXMKdGhlIGZ1bmN0
aW9uIF9fZGV2aW5pdCBpb2M0X2xvYWRfbW9kdWxlcygpCklmIHRoZSByZWZlcmVuY2UgaXMgdmFs
aWQgdGhlbiBhbm5vdGF0ZSB0aGUKdmFyaWFibGUgd2l0aCBfX2luaXQqIG9yIF9fcmVmZGF0YSAo
c2VlIGxpbnV4L2luaXQuaCkgb3IgbmFtZSB0aGUgdmFyaWFibGU6Cipkcml2ZXIsICpfdGVtcGxh
dGUsICpfdGltZXIsICpfc2h0LCAqX29wcywgKl9wcm9iZSwgKl9wcm9iZV9vbmUsICpfY29uc29s
ZSwgCgpXQVJOSU5HOiBkcml2ZXJzL210ZC9kZXZpY2VzL3NzdDI1bC5vKC5kZXZpbml0LnRleHQr
MHg3Zik6IFNlY3Rpb24gbWlzbWF0Y2ggaW4gcmVmZXJlbmNlIGZyb20gdGhlIGZ1bmN0aW9uIHNz
dDI1bF9tYXRjaF9kZXZpY2UoKSB0byB0aGUgdmFyaWFibGUgLmluaXQuZGF0YTpzc3QyNWxfZmxh
c2hfaW5mbwpUaGUgZnVuY3Rpb24gX19kZXZpbml0IHNzdDI1bF9tYXRjaF9kZXZpY2UoKSByZWZl
cmVuY2VzCmEgdmFyaWFibGUgX19pbml0ZGF0YSBzc3QyNWxfZmxhc2hfaW5mby4KSWYgc3N0MjVs
X2ZsYXNoX2luZm8gaXMgb25seSB1c2VkIGJ5IHNzdDI1bF9tYXRjaF9kZXZpY2UgdGhlbgphbm5v
dGF0ZSBzc3QyNWxfZmxhc2hfaW5mbyB3aXRoIGEgbWF0Y2hpbmcgYW5ub3RhdGlvbi4KCldBUk5J
Tkc6IGRyaXZlcnMvbXRkL2RldmljZXMvc3N0MjVsLm8oLmRldmluaXQudGV4dCsweDk0KTogU2Vj
dGlvbiBtaXNtYXRjaCBpbiByZWZlcmVuY2UgZnJvbSB0aGUgZnVuY3Rpb24gc3N0MjVsX21hdGNo
X2RldmljZSgpIHRvIHRoZSB2YXJpYWJsZSAuaW5pdC5kYXRhOnNzdDI1bF9mbGFzaF9pbmZvClRo
ZSBmdW5jdGlvbiBfX2RldmluaXQgc3N0MjVsX21hdGNoX2RldmljZSgpIHJlZmVyZW5jZXMKYSB2
YXJpYWJsZSBfX2luaXRkYXRhIHNzdDI1bF9mbGFzaF9pbmZvLgpJZiBzc3QyNWxfZmxhc2hfaW5m
byBpcyBvbmx5IHVzZWQgYnkgc3N0MjVsX21hdGNoX2RldmljZSB0aGVuCmFubm90YXRlIHNzdDI1
bF9mbGFzaF9pbmZvIHdpdGggYSBtYXRjaGluZyBhbm5vdGF0aW9uLgoKV0FSTklORzogZHJpdmVy
cy9tdGQvZGV2aWNlcy9zc3QyNWwubyguZGV2aW5pdC50ZXh0KzB4OWUpOiBTZWN0aW9uIG1pc21h
dGNoIGluIHJlZmVyZW5jZSBmcm9tIHRoZSBmdW5jdGlvbiBzc3QyNWxfbWF0Y2hfZGV2aWNlKCkg
dG8gdGhlICh1bmtub3duIHJlZmVyZW5jZSkgLmluaXQuZGF0YToodW5rbm93bikKVGhlIGZ1bmN0
aW9uIF9fZGV2aW5pdCBzc3QyNWxfbWF0Y2hfZGV2aWNlKCkgcmVmZXJlbmNlcwphICh1bmtub3du
IHJlZmVyZW5jZSkgX19pbml0ZGF0YSAodW5rbm93bikuCklmICh1bmtub3duKSBpcyBvbmx5IHVz
ZWQgYnkgc3N0MjVsX21hdGNoX2RldmljZSB0aGVuCmFubm90YXRlICh1bmtub3duKSB3aXRoIGEg
bWF0Y2hpbmcgYW5ub3RhdGlvbi4KCldBUk5JTkc6IGRyaXZlcnMvbXRkL2RldmljZXMvc3N0MjVs
Lm8oLmRldmluaXQudGV4dCsweGE1KTogU2VjdGlvbiBtaXNtYXRjaCBpbiByZWZlcmVuY2UgZnJv
bSB0aGUgZnVuY3Rpb24gc3N0MjVsX21hdGNoX2RldmljZSgpIHRvIHRoZSAodW5rbm93biByZWZl
cmVuY2UpIC5pbml0LmRhdGE6KHVua25vd24pClRoZSBmdW5jdGlvbiBfX2RldmluaXQgc3N0MjVs
X21hdGNoX2RldmljZSgpIHJlZmVyZW5jZXMKYSAodW5rbm93biByZWZlcmVuY2UpIF9faW5pdGRh
dGEgKHVua25vd24pLgpJZiAodW5rbm93bikgaXMgb25seSB1c2VkIGJ5IHNzdDI1bF9tYXRjaF9k
ZXZpY2UgdGhlbgphbm5vdGF0ZSAodW5rbm93bikgd2l0aCBhIG1hdGNoaW5nIGFubm90YXRpb24u
CgogIE1LUElHR1kgYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL3BpZ2d5LlMKLS0KV0FSTklORzog
ZHJpdmVycy9uZXQvZGVwY2EubyguZGF0YSsweDApOiBTZWN0aW9uIG1pc21hdGNoIGluIHJlZmVy
ZW5jZSBmcm9tIHRoZSB2YXJpYWJsZSBkZXBjYV9pc2FfZHJpdmVyIHRvIHRoZSBmdW5jdGlvbiAu
aW5pdC50ZXh0OmRlcGNhX2lzYV9wcm9iZSgpClRoZSB2YXJpYWJsZSBkZXBjYV9pc2FfZHJpdmVy
IHJlZmVyZW5jZXMKdGhlIGZ1bmN0aW9uIF9faW5pdCBkZXBjYV9pc2FfcHJvYmUoKQpJZiB0aGUg
cmVmZXJlbmNlIGlzIHZhbGlkIHRoZW4gYW5ub3RhdGUgdGhlCnZhcmlhYmxlIHdpdGggX19pbml0
KiBvciBfX3JlZmRhdGEgKHNlZSBsaW51eC9pbml0LmgpIG9yIG5hbWUgdGhlIHZhcmlhYmxlOgoq
X3RlbXBsYXRlLCAqX3RpbWVyLCAqX3NodCwgKl9vcHMsICpfcHJvYmUsICpfcHJvYmVfb25lLCAq
X2NvbnNvbGUsIAoKLS0KZHJpdmVycy9uZXQvaXJkYS9zbXNjLWlyY2MyLm8oLmRhdGErMHgxOCk6
IFNlY3Rpb24gbWlzbWF0Y2ggaW4gcmVmZXJlbmNlIGZyb20gdGhlIHZhcmlhYmxlIHNtc2NfaXJj
Y19wbnBfZHJpdmVyIHRvIHRoZSBmdW5jdGlvbiAuaW5pdC50ZXh0OnNtc2NfaXJjY19wbnBfcHJv
YmUoKQpUaGUgdmFyaWFibGUgc21zY19pcmNjX3BucF9kcml2ZXIgcmVmZXJlbmNlcwp0aGUgZnVu
Y3Rpb24gX19pbml0IHNtc2NfaXJjY19wbnBfcHJvYmUoKQpJZiB0aGUgcmVmZXJlbmNlIGlzIHZh
bGlkIHRoZW4gYW5ub3RhdGUgdGhlCnZhcmlhYmxlIHdpdGggX19pbml0KiBvciBfX3JlZmRhdGEg
KHNlZSBsaW51eC9pbml0LmgpIG9yIG5hbWUgdGhlIHZhcmlhYmxlOgoqX3RlbXBsYXRlLCAqX3Rp
bWVyLCAqX3NodCwgKl9vcHMsICpfcHJvYmUsICpfcHJvYmVfb25lLCAqX2NvbnNvbGUsIAoKLS0K
V0FSTklORzogZHJpdmVycy9uZXQva3N6ODg0eC5vKC5kYXRhKzB4MTgpOiBTZWN0aW9uIG1pc21h
dGNoIGluIHJlZmVyZW5jZSBmcm9tIHRoZSB2YXJpYWJsZSBwY2lfZGV2aWNlX2RyaXZlciB0byB0
aGUgZnVuY3Rpb24gLmluaXQudGV4dDpwY2lkZXZfaW5pdCgpClRoZSB2YXJpYWJsZSBwY2lfZGV2
aWNlX2RyaXZlciByZWZlcmVuY2VzCnRoZSBmdW5jdGlvbiBfX2luaXQgcGNpZGV2X2luaXQoKQpJ
ZiB0aGUgcmVmZXJlbmNlIGlzIHZhbGlkIHRoZW4gYW5ub3RhdGUgdGhlCnZhcmlhYmxlIHdpdGgg
X19pbml0KiBvciBfX3JlZmRhdGEgKHNlZSBsaW51eC9pbml0LmgpIG9yIG5hbWUgdGhlIHZhcmlh
YmxlOgoqX3RlbXBsYXRlLCAqX3RpbWVyLCAqX3NodCwgKl9vcHMsICpfcHJvYmUsICpfcHJvYmVf
b25lLCAqX2NvbnNvbGUsIAoKV0FSTklORzogZHJpdmVycy92aWRlby9nZW9kZS9neDFmYi5vKC5k
YXRhKzB4NTQpOiBTZWN0aW9uIG1pc21hdGNoIGluIHJlZmVyZW5jZSBmcm9tIHRoZSB2YXJpYWJs
ZSBneDFmYl9kcml2ZXIgdG8gdGhlIGZ1bmN0aW9uIC5pbml0LnRleHQ6Z3gxZmJfcHJvYmUoKQpU
aGUgdmFyaWFibGUgZ3gxZmJfZHJpdmVyIHJlZmVyZW5jZXMKdGhlIGZ1bmN0aW9uIF9faW5pdCBn
eDFmYl9wcm9iZSgpCklmIHRoZSByZWZlcmVuY2UgaXMgdmFsaWQgdGhlbiBhbm5vdGF0ZSB0aGUK
dmFyaWFibGUgd2l0aCBfX2luaXQqIG9yIF9fcmVmZGF0YSAoc2VlIGxpbnV4L2luaXQuaCkgb3Ig
bmFtZSB0aGUgdmFyaWFibGU6CipfdGVtcGxhdGUsICpfdGltZXIsICpfc2h0LCAqX29wcywgKl9w
cm9iZSwgKl9wcm9iZV9vbmUsICpfY29uc29sZSwgCgo=
--0016364ed8684430860498ee48bc--
