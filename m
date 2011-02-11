Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1BKI1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 03:27:05 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39099 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1BKI1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 03:27:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CnSh7vKj2zxRpF7dG3APuKHt6muVXCuvS9E2EvAtBvwZh/58oGXcF+2Tz1GCcrGFa8
         dkNmqQWg1wH01zIoHhMrnoauxi7/eASWz4a4jLAkjfzSY/lXX9eHhq9qUNRl38anek/F
         CSNamBRZMgFpnQORkVE/e7VbbtLeHVYnpf820=
MIME-Version: 1.0
In-Reply-To: <AANLkTimdE6G=qf+wLLSogma-BbH9J0_DYRv7aJkP9P64@mail.gmail.com>
References: <4D51AD03.7030401@gmail.com>
	<AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com>
	<AANLkTimBwM=iacwPosrYXU_jN=DXnEkWL3jvFcarDN23@mail.gmail.com>
	<B44733BE-E28B-441E-9E6B-AE9B0C8D7E45@gmail.com>
	<AANLkTimdE6G=qf+wLLSogma-BbH9J0_DYRv7aJkP9P64@mail.gmail.com>
Date: Fri, 11 Feb 2011 03:27:01 -0500
Message-ID: <AANLkTi=Ppzicpz5a6AO5rrGkv=j3HPmiB7Er4VGj4OVU@mail.gmail.com>
Subject: Re: [BISECTED] commit 619efb1059 makes the MacBookPro2,2 screen
 flicker like its broken or half plugged in
From: Alex Deucher <alexdeucher@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@redhat.com
Content-Type: multipart/mixed; boundary=20cf30433ee85ed5c7049bfd7629
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf30433ee85ed5c7049bfd7629
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 11, 2011 at 1:59 AM, Alex Deucher <alexdeucher@gmail.com> wrote=
:
> On Thu, Feb 10, 2011 at 12:33 AM, Justin Mattock
> <justinmattock@gmail.com> wrote:
>>
>> On Feb 9, 2011, at 2:09 PM, Alex Deucher wrote:
>>
>>> On Tue, Feb 8, 2011 at 4:20 PM, Alex Deucher <alexdeucher@gmail.com>
>>> wrote:
>>>>
>>>> On Tue, Feb 8, 2011 at 3:52 PM, Justin P. Mattock
>>>> <justinmattock@gmail.com> wrote:
>>>>>
>>>>> With the current HEAD Im getting screen flickering really bad to poin=
t
>>>>> where
>>>>> it looks like the screen is damaged and/or half plugged-in etc..
>>>>>
>>>>> the bisect pointed to here:
>>>>>
>>>>> commit 619efb105924d8cafa0c1dd9389e9ab506f5425d
>>>>>
>>>>> doing a git revert 619efb10592
>>>>> gets the screen working properly again.
>>>>> I havent looked much through the code to see if I can fix this. for t=
he
>>>>> time
>>>>> being I'll revert this on my machine with the current, until later on=
.
>>>>
>>>> The attached patch should fix it assuming I got your pci ids correct.
>>>> I'm done with the pll stuff; too may fixes break other boards. =A0Just
>>>> add a quirk table and be done with it.
>>>>
>>>
>>> The attached patch builds on the previous one and fixes an additional
>>> regression.
>>>
>>> Alex
>>>
>>> <0001-drm-radeon-kms-pll-quirk-cleanup.patch>
>>
>> alright... didn't mean to keep you waiting(out of my office for most of =
the
>> day)..
>> Anyways patch applied, and everything looks good no screen jitters or
>> flickering etc..
>>
>> Reported-and-Tested-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> Thanks for sending this my way so my machine works..
>
> Justin, can you try without these patches, but with the following patch i=
nstead?
>

Better yet, can you try the attached patch on top of 2.6.38-rc4 or newer?

Alex

> diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c
> b/drivers/gpu/drm/radeon/atombios_crtc.c
> index cc6bdd8..2f9d113 100644
> --- a/drivers/gpu/drm/radeon/atombios_crtc.c
> +++ b/drivers/gpu/drm/radeon/atombios_crtc.c
> @@ -562,7 +562,7 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0/* this might work properly with the new pll algo */
> -#if 0 /* doesn't work properly on some laptops */
> +#if 1 /* doesn't work properly on some laptops */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* use recommended ref_div=
 for ss */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (radeon_encoder->device=
s &
> (ATOM_DEVICE_LCD_SUPPORT)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ss_ena=
bled) {
>
>
>>
>> cheers,
>>
>> Justin P. Mattock
>>
>

--20cf30433ee85ed5c7049bfd7629
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-hopefully-fix-pll-issues-for-real.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-hopefully-fix-pll-issues-for-real.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gk0u2wg20

RnJvbSBlMWM1NzAzMjIzZDIxNDQxYmNiZGQyMjI1NzJlNTkyOTg0ZTVhZTEwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogRnJpLCAxMSBGZWIgMjAxMSAwMjoyNTo1MSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGRy
bS9yYWRlb24va21zOiBob3BlZnVsbHkgZml4IHBsbCBpc3N1ZXMgZm9yIHJlYWwKClRoZSBwcm9i
bGVtYXRpYyBib2FyZHMgaGF2ZSBhIHJlY29tbWVuZGVkIHJlZmVyZW5jZSBkaXZpZGVyCnRvIGJl
IHVzZWQgd2hlbiBzcHJlYWQgc3BlY3RydW0gaXMgZW5hYmxlZCBvbiB0aGUgbGFwdG9wIHBhbmVs
LgpFbmFibGUgdGhlIHVzZSBvZiB0aGUgcmVjb21tZW5kZWQgcmVmZXJlbmNlIGRpdmlkZXIgYWxv
bmcgd2l0aAp0aGUgbmV3IHBsbCBhbGdvLiAgVGhpcyBzaG91bGQgaG9wZWZ1bGx5IGZpeCB0aGUg
aXNzdWVzIGFjcm9zcwp0aGUgYm9hcmQuCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFs
ZXhkZXVjaGVyQGdtYWlsLmNvbT4KQ2M6IHN0YWJsZUBrZXJuZWwub3JnCi0tLQogZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMgfCAgIDE4ICsrKysrLS0tLS0tLS0tLS0tLQog
MSBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0Yy5jIGIvZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKaW5kZXggZGQ0ZTNhYy4uNjM4ZjkyNiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKKysrIGIvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKQEAgLTU1NSw4ICs1NTUsNyBAQCBz
dGF0aWMgdTMyIGF0b21iaW9zX2FkanVzdF9wbGwoc3RydWN0IGRybV9jcnRjICpjcnRjLAogCQkJ
CQlkcF9jbG9jayA9IGRpZ19jb25uZWN0b3ItPmRwX2Nsb2NrOwogCQkJCX0KIAkJCX0KLS8qIHRo
aXMgbWlnaHQgd29yayBwcm9wZXJseSB3aXRoIHRoZSBuZXcgcGxsIGFsZ28gKi8KLSNpZiAwIC8q
IGRvZXNuJ3Qgd29yayBwcm9wZXJseSBvbiBzb21lIGxhcHRvcHMgKi8KKwogCQkJLyogdXNlIHJl
Y29tbWVuZGVkIHJlZl9kaXYgZm9yIHNzICovCiAJCQlpZiAocmFkZW9uX2VuY29kZXItPmRldmlj
ZXMgJiAoQVRPTV9ERVZJQ0VfTENEX1NVUFBPUlQpKSB7CiAJCQkJaWYgKHNzX2VuYWJsZWQpIHsK
QEAgLTU2NiwxOCArNTY1LDE1IEBAIHN0YXRpYyB1MzIgYXRvbWJpb3NfYWRqdXN0X3BsbChzdHJ1
Y3QgZHJtX2NydGMgKmNydGMsCiAJCQkJCX0KIAkJCQl9CiAJCQl9Ci0jZW5kaWYKKwogCQkJaWYg
KEFTSUNfSVNfQVZJVk8ocmRldikpIHsKIAkJCQkvKiBEVk8gd2FudHMgMnggcGl4ZWwgY2xvY2sg
aWYgdGhlIERWTyBjaGlwIGlzIGluIDEyIGJpdCBtb2RlICovCiAJCQkJaWYgKHJhZGVvbl9lbmNv
ZGVyLT5lbmNvZGVyX2lkID09IEVOQ09ERVJfT0JKRUNUX0lEX0lOVEVSTkFMX0tMRFNDUF9EVk8x
KQogCQkJCQlhZGp1c3RlZF9jbG9jayA9IG1vZGUtPmNsb2NrICogMjsKIAkJCQlpZiAocmFkZW9u
X2VuY29kZXItPmFjdGl2ZV9kZXZpY2UgJiAoQVRPTV9ERVZJQ0VfVFZfU1VQUE9SVCkpCiAJCQkJ
CXBsbC0+ZmxhZ3MgfD0gUkFERU9OX1BMTF9QUkVGRVJfQ0xPU0VTVF9MT1dFUjsKLQkJCQkvKiBy
djUxNSBuZWVkcyBtb3JlIHRlc3Rpbmcgd2l0aCB0aGlzIG9wdGlvbiAqLwotCQkJCWlmIChyZGV2
LT5mYW1pbHkgIT0gQ0hJUF9SVjUxNSkgewotCQkJCQlpZiAocmFkZW9uX2VuY29kZXItPmRldmlj
ZXMgJiAoQVRPTV9ERVZJQ0VfTENEX1NVUFBPUlQpKQotCQkJCQkJcGxsLT5mbGFncyB8PSBSQURF
T05fUExMX0lTX0xDRDsKLQkJCQl9CisJCQkJaWYgKHJhZGVvbl9lbmNvZGVyLT5kZXZpY2VzICYg
KEFUT01fREVWSUNFX0xDRF9TVVBQT1JUKSkKKwkJCQkJcGxsLT5mbGFncyB8PSBSQURFT05fUExM
X0lTX0xDRDsKIAkJCX0gZWxzZSB7CiAJCQkJaWYgKGVuY29kZXItPmVuY29kZXJfdHlwZSAhPSBE
Uk1fTU9ERV9FTkNPREVSX0RBQykKIAkJCQkJcGxsLT5mbGFncyB8PSBSQURFT05fUExMX05PX09E
RF9QT1NUX0RJVjsKQEAgLTk1NywxMSArOTUzLDcgQEAgc3RhdGljIHZvaWQgYXRvbWJpb3NfY3J0
Y19zZXRfcGxsKHN0cnVjdCBkcm1fY3J0YyAqY3J0Yywgc3RydWN0IGRybV9kaXNwbGF5X21vZGUK
IAkvKiBhZGp1c3QgcGl4ZWwgY2xvY2sgYXMgbmVlZGVkICovCiAJYWRqdXN0ZWRfY2xvY2sgPSBh
dG9tYmlvc19hZGp1c3RfcGxsKGNydGMsIG1vZGUsIHBsbCwgc3NfZW5hYmxlZCwgJnNzKTsKIAot
CS8qIHJ2NTE1IHNlZW1zIGhhcHBpZXIgd2l0aCB0aGUgb2xkIGFsZ28gKi8KLQlpZiAocmRldi0+
ZmFtaWx5ID09IENISVBfUlY1MTUpCi0JCXJhZGVvbl9jb21wdXRlX3BsbF9sZWdhY3kocGxsLCBh
ZGp1c3RlZF9jbG9jaywgJnBsbF9jbG9jaywgJmZiX2RpdiwgJmZyYWNfZmJfZGl2LAotCQkJCQkg
ICZyZWZfZGl2LCAmcG9zdF9kaXYpOwotCWVsc2UgaWYgKEFTSUNfSVNfQVZJVk8ocmRldikpCisJ
aWYgKEFTSUNfSVNfQVZJVk8ocmRldikpCiAJCXJhZGVvbl9jb21wdXRlX3BsbF9hdml2byhwbGws
IGFkanVzdGVkX2Nsb2NrLCAmcGxsX2Nsb2NrLCAmZmJfZGl2LCAmZnJhY19mYl9kaXYsCiAJCQkJ
CSAmcmVmX2RpdiwgJnBvc3RfZGl2KTsKIAllbHNlCi0tIAoxLjcuMS4xCgo=
--20cf30433ee85ed5c7049bfd7629--
