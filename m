Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab0I0DG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 23:06:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43320 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab0I0DG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 23:06:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wp+vARyKOr7xKbjddkbHEcCVu0VSATytU6XltvfeSLCXaL5ayZlTCAegpFryHQQsJU
         LjlLbRiZvZXMuSDmkpVDyUqL6ulf2fJ1JuZNEp7yDfxx57lF1RBm34k/lFWbt3smdqXy
         aPoQiVr+4w9J78HZ5OtzTXEAk94AftE1Aeno4=
MIME-Version: 1.0
In-Reply-To: <1285502719.13050.17.camel@brekeke>
References: <1285328063-7982-1-git-send-email-shijie8@gmail.com>
	<1285502719.13050.17.camel@brekeke>
Date: Mon, 27 Sep 2010 11:06:55 +0800
Message-ID: <AANLkTi=6zROsDs2zkCJOXJdiPDh53A=x7WXGZKTyHDoO@mail.gmail.com>
Subject: Re: [PATCH] mtd : add init_size hook for NAND driver
From: Huang Shijie <shijie8@gmail.com>
To: dedekind1@gmail.com
Cc: David.Woodhouse@intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: multipart/mixed; boundary=0050450160015b157d049135052c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0050450160015b157d049135052c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Artem:
    I think the new patch is better.

The new patch will reuse the id_data.
Even if the additional id byte does not have all the information in
some case, but other infomation such as manufacture id and device id
are also useful to the NAND driver.

Best regards
Huang Shijie


2010/9/26 Artem Bityutskiy <dedekind1@gmail.com>:
> On Fri, 2010-09-24 at 19:34 +0800, Huang Shijie wrote:
>> Not all the NAND devices have all the information in additional
>> id bytes.
>>
>> So add a hook in the nand_chip{} is a good method to calculate the
>> right value of oobsize, erasesize and so on.
>>
>> Without the hook,you will get the wrong value, and you have to hack
>> in the ->scan_bbt() to change the wrong value which make the code
>> mess.
>>
>> Signed-off-by: Huang Shijie <shijie8@gmail.com>
>> ---
>> =C2=A0drivers/mtd/nand/nand_base.c | =C2=A0 =C2=A06 ++++--
>> =C2=A0include/linux/mtd/nand.h =C2=A0 =C2=A0 | =C2=A0 =C2=A05 +++++
>> =C2=A02 files changed, 9 insertions(+), 2 deletions(-)
>
> Taken to l2-mtd-2.6.git, thanks.
>
> --
> Best Regards,
> Artem Bityutskiy (=D0=91=D0=B8=D1=82=D1=8E=D1=86=D0=BA=D0=B8=D0=B9 =D0=90=
=D1=80=D1=82=D1=91=D0=BC)
>
>

--0050450160015b157d049135052c
Content-Type: application/octet-stream; 
	name="0001-mtd-add-init_size-hook-for-NAND-driver.patch"
Content-Disposition: attachment; 
	filename="0001-mtd-add-init_size-hook-for-NAND-driver.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gekr7uc50

RnJvbSBiMTFhOWI5OWY3Nzc1ZGEzMmEzZjRjNzFhMjgxZmFjNjYxYWY2YWQ0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBIdWFuZyBTaGlqaWUgPHNoaWppZThAZ21haWwuY29tPgpEYXRl
OiBNb24sIDI3IFNlcCAyMDEwIDEwOjQzOjUzICswODAwClN1YmplY3Q6IFtQQVRDSF0gbXRkIDog
YWRkIGluaXRfc2l6ZSBob29rIGZvciBOQU5EIGRyaXZlcgoKTm90IGFsbCB0aGUgTkFORCBkZXZp
Y2VzIGhhdmUgYWxsIHRoZSBpbmZvcm1hdGlvbiBpbiBhZGRpdGlvbmFsCmlkIGJ5dGVzLgoKU28g
YWRkIGEgaG9vayBpbiB0aGUgbmFuZF9jaGlwe30gaXMgYSBnb29kIG1ldGhvZCB0byBjYWxjdWxh
dGUgdGhlCnJpZ2h0IHZhbHVlIG9mIG9vYnNpemUsIGVyYXNlc2l6ZSBhbmQgc28gb24uCgpXaXRo
b3V0IHRoZSBob29rLHlvdSB3aWxsIGdldCB0aGUgd3JvbmcgdmFsdWUsIGFuZCB5b3UgaGF2ZSB0
byBoYWNrCmluIHRoZSAtPnNjYW5fYmJ0KCkgdG8gY2hhbmdlIHRoZSB3cm9uZyB2YWx1ZSB3aGlj
aCBtYWtlIHRoZSBjb2RlCm1lc3MuCgpTaWduZWQtb2ZmLWJ5OiBIdWFuZyBTaGlqaWUgPHNoaWpp
ZThAZ21haWwuY29tPgotLS0KIGRyaXZlcnMvbXRkL25hbmQvbmFuZF9iYXNlLmMgfCAgICA2ICsr
KystLQogaW5jbHVkZS9saW51eC9tdGQvbmFuZC5oICAgICB8ICAgIDYgKysrKysrCiAyIGZpbGVz
IGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9tdGQvbmFuZC9uYW5kX2Jhc2UuYyBiL2RyaXZlcnMvbXRkL25hbmQvbmFuZF9iYXNl
LmMKaW5kZXggZDU1MWRkZC4uYmYzMWUyYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9tdGQvbmFuZC9u
YW5kX2Jhc2UuYworKysgYi9kcml2ZXJzL210ZC9uYW5kL25hbmRfYmFzZS5jCkBAIC0yODQ4LDgg
KzI4NDgsMTAgQEAgc3RhdGljIHN0cnVjdCBuYW5kX2ZsYXNoX2RldiAqbmFuZF9nZXRfZmxhc2hf
dHlwZShzdHJ1Y3QgbXRkX2luZm8gKm10ZCwKIAogCWNoaXAtPmNoaXBzaXplID0gKHVpbnQ2NF90
KXR5cGUtPmNoaXBzaXplIDw8IDIwOwogCi0JLyogTmV3ZXIgZGV2aWNlcyBoYXZlIGFsbCB0aGUg
aW5mb3JtYXRpb24gaW4gYWRkaXRpb25hbCBpZCBieXRlcyAqLwotCWlmICghdHlwZS0+cGFnZXNp
emUpIHsKKwlpZiAoIXR5cGUtPnBhZ2VzaXplICYmIGNoaXAtPmluaXRfc2l6ZSkgeworCQkvKiBz
ZXQgdGhlIHBhZ2VzaXplLCBvb2JzaXplLCBlcmFzZXNpemUgYnkgdGhlIGRyaXZlciovCisJCWJ1
c3cgPSBjaGlwLT5pbml0X3NpemUobXRkLCBjaGlwLCBpZF9kYXRhKTsKKwl9IGVsc2UgaWYgKCF0
eXBlLT5wYWdlc2l6ZSkgewogCQlpbnQgZXh0aWQ7CiAJCS8qIFRoZSAzcmQgaWQgYnl0ZSBob2xk
cyBNTEMgLyBtdWx0aWNoaXAgZGF0YSAqLwogCQljaGlwLT5jZWxsaW5mbyA9IGlkX2RhdGFbMl07
CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L210ZC9uYW5kLmggYi9pbmNsdWRlL2xpbnV4L210
ZC9uYW5kLmgKaW5kZXggMTAyZTEyYy4uMWIzOWVkZCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51
eC9tdGQvbmFuZC5oCisrKyBiL2luY2x1ZGUvbGludXgvbXRkL25hbmQuaApAQCAtMzMyLDYgKzMz
MiwxMCBAQCBzdHJ1Y3QgbmFuZF9idWZmZXJzIHsKICAqIEBibG9ja19tYXJrYmFkOglbUkVQTEFD
RUFCTEVdIG1hcmsgdGhlIGJsb2NrIGJhZAogICogQGNtZF9jdHJsOgkJW0JPQVJEU1BFQ0lGSUNd
IGhhcmR3YXJlc3BlY2lmaWMgZnVudGlvbiBmb3IgY29udHJvbGxpbmcKICAqCQkJQUxFL0NMRS9u
Q0UuIEFsc28gdXNlZCB0byB3cml0ZSBjb21tYW5kIGFuZCBhZGRyZXNzCisgKiBAaW5pdF9zaXpl
OgkJW0JPQVJEU1BFQ0lGSUNdIGhhcmR3YXJlc3BlY2lmaWMgZnVudGlvbiBmb3Igc2V0dGluZwor
ICoJCQltdGQtPm9vYnNpemUsIG10ZC0+d3JpdGVzaXplIGFuZCBzbyBvbi4KKyAqCQkJQGlkX2Rh
dGEgY29udGFpbnMgdGhlIDggYnl0ZXMgdmFsdWVzIG9mIE5BTkRfQ01EX1JFQURJRC4KKyAqCQkJ
UmV0dXJuIHdpdGggdGhlIGJ1cyB3aWR0aC4KICAqIEBkZXZfcmVhZHk6CQlbQk9BUkRTUEVDSUZJ
Q10gaGFyZHdhcmVzcGVjaWZpYyBmdW5jdGlvbiBmb3IgYWNjZXNpbmcgZGV2aWNlIHJlYWR5L2J1
c3kgbGluZQogICoJCQlJZiBzZXQgdG8gTlVMTCBubyBhY2Nlc3MgdG8gcmVhZHkvYnVzeSBpcyBh
dmFpbGFibGUgYW5kIHRoZSByZWFkeS9idXN5IGluZm9ybWF0aW9uCiAgKgkJCWlzIHJlYWQgZnJv
bSB0aGUgY2hpcCBzdGF0dXMgcmVnaXN0ZXIKQEAgLTM4Niw2ICszOTAsOCBAQCBzdHJ1Y3QgbmFu
ZF9jaGlwIHsKIAlpbnQJCSgqYmxvY2tfbWFya2JhZCkoc3RydWN0IG10ZF9pbmZvICptdGQsIGxv
ZmZfdCBvZnMpOwogCXZvaWQJCSgqY21kX2N0cmwpKHN0cnVjdCBtdGRfaW5mbyAqbXRkLCBpbnQg
ZGF0LAogCQkJCSAgICB1bnNpZ25lZCBpbnQgY3RybCk7CisJaW50CQkoKmluaXRfc2l6ZSkoc3Ry
dWN0IG10ZF9pbmZvICptdGQsCisJCQkJCXN0cnVjdCBuYW5kX2NoaXAgKnRoaXMsIHU4ICppZF9k
YXRhKTsKIAlpbnQJCSgqZGV2X3JlYWR5KShzdHJ1Y3QgbXRkX2luZm8gKm10ZCk7CiAJdm9pZAkJ
KCpjbWRmdW5jKShzdHJ1Y3QgbXRkX2luZm8gKm10ZCwgdW5zaWduZWQgY29tbWFuZCwgaW50IGNv
bHVtbiwgaW50IHBhZ2VfYWRkcik7CiAJaW50CQkoKndhaXRmdW5jKShzdHJ1Y3QgbXRkX2luZm8g
Km10ZCwgc3RydWN0IG5hbmRfY2hpcCAqdGhpcyk7Ci0tIAoxLjYuMy4zCgo=
--0050450160015b157d049135052c--
