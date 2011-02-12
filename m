Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab1BLBPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 20:15:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40456 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab1BLBPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 20:15:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QCUOLTlYzDdzJwIJoazucIkVpaS3WtccAfT599PTASyWbLyFUuiDXs1/zK+0EShKpS
         lue59tGRab/nEYFFiVxqCslGxWlnFjv8LGpBoYHSk+1hVg+Dc9P9BKBuAE5f7C59z3zP
         hEMeUGvca4L4sruzqotVuGpXxOVvGQb4IoFqI=
MIME-Version: 1.0
In-Reply-To: <C0E6BA6B-174B-4930-A5C5-7DB87FDFAD1F@gmail.com>
References: <4D51AD03.7030401@gmail.com>
	<AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com>
	<AANLkTimBwM=iacwPosrYXU_jN=DXnEkWL3jvFcarDN23@mail.gmail.com>
	<B44733BE-E28B-441E-9E6B-AE9B0C8D7E45@gmail.com>
	<AANLkTimdE6G=qf+wLLSogma-BbH9J0_DYRv7aJkP9P64@mail.gmail.com>
	<AANLkTi=Ppzicpz5a6AO5rrGkv=j3HPmiB7Er4VGj4OVU@mail.gmail.com>
	<C0E6BA6B-174B-4930-A5C5-7DB87FDFAD1F@gmail.com>
Date: Fri, 11 Feb 2011 20:15:42 -0500
Message-ID: <AANLkTinca2027s9-g0tLabBMj4fr2+e=xgUSymBqvv1o@mail.gmail.com>
Subject: Re: [BISECTED] commit 619efb1059 makes the MacBookPro2,2 screen
 flicker like its broken or half plugged in
From: Alex Deucher <alexdeucher@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@redhat.com
Content-Type: multipart/mixed; boundary=20cf3054a585aa9cb9049c0b8d90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3054a585aa9cb9049c0b8d90
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Feb 11, 2011 at 10:57 AM, Justin Mattock
<justinmattock@gmail.com> wrote:
>
>>
>> Better yet, can you try the attached patch on top of 2.6.38-rc4 or newer?
>>
>> Alex
>>
>
> o.k. applied that patch... unfortunately Im seeing the flickering screen and
> the crud shows up..
> initially during boot everything looked fine, its when I suspended the
> machine, upon wake-up
> the flickering occurred.
> kernel version is the current: 2.6.38-rc4-00107-gaa502b4

Can you try this patch?  Try uncommenting the following lines to see
if either of those flags work any better.  Try them individually and
together if possible and report back which, if any, helps.

/*pll->flags |= RADEON_PLL_PREFER_MINM_OVER_MAXP;*/

/*if (ASIC_IS_AVIVO(rdev))
        pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;*/

Thanks!

Alex

>
> Justin P. Mattock
>

--20cf3054a585aa9cb9049c0b8d90
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-hopefully-fix-pll-issues-for-real-v2.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-hopefully-fix-pll-issues-for-real-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gk1u4a0y0

RnJvbSBiOTJiZjY0YTRmYzE4MWM2YTc4M2NjMGQ1MWE2ODgxZmM4YTM1M2E3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogRnJpLCAxMSBGZWIgMjAxMSAyMDoxMDoxMSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGRy
bS9yYWRlb24va21zOiBob3BlZnVsbHkgZml4IHBsbCBpc3N1ZXMgZm9yIHJlYWwgKHYyKQoKVGhl
IHByb2JsZW1hdGljIGJvYXJkcyBoYXZlIGEgcmVjb21tZW5kZWQgcmVmZXJlbmNlIGRpdmlkZXIK
dG8gYmUgdXNlZCB3aGVuIHNwcmVhZCBzcGVjdHJ1bSBpcyBlbmFibGVkIG9uIHRoZSBsYXB0b3Ag
cGFuZWwuCkVuYWJsZSB0aGUgdXNlIG9mIHRoZSByZWNvbW1lbmRlZCByZWZlcmVuY2UgZGl2aWRl
ciBhbG9uZyB3aXRoCnRoZSBuZXcgcGxsIGFsZ28uICBUaGlzIHNob3VsZCBob3BlZnVsbHkgZml4
IHRoZSBpc3N1ZXMgYWNyb3NzCnRoZSBib2FyZC4KCnYyOiBhZGQgc29tZSBvcHRpb25zIHRvIHVu
Y29tbWVudCBhbmQgdHJ5CgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVy
QGdtYWlsLmNvbT4KQ2M6IHN0YWJsZUBrZXJuZWwub3JnCi0tLQogZHJpdmVycy9ncHUvZHJtL3Jh
ZGVvbi9hdG9tYmlvc19jcnRjLmMgfCAgIDIxICsrKysrKysrLS0tLS0tLS0tLS0tLQogMSBmaWxl
cyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0Yy5jIGIvZHJpdmVycy9ncHUvZHJt
L3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKaW5kZXggMWJmNjEyMi4uYWZhNGMzNCAxMDA2NDQKLS0t
IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKKysrIGIvZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKQEAgLTUzMSw2ICs1MzEsNyBAQCBzdGF0aWMg
dTMyIGF0b21iaW9zX2FkanVzdF9wbGwoc3RydWN0IGRybV9jcnRjICpjcnRjLAogCQkJcGxsLT5m
bGFncyB8PSBSQURFT05fUExMX1BSRUZFUl9ISUdIX0ZCX0RJVjsKIAkJZWxzZQogCQkJcGxsLT5m
bGFncyB8PSBSQURFT05fUExMX1BSRUZFUl9MT1dfUkVGX0RJVjsKKwkJLypwbGwtPmZsYWdzIHw9
IFJBREVPTl9QTExfUFJFRkVSX01JTk1fT1ZFUl9NQVhQOyovCiAJfSBlbHNlIHsKIAkJcGxsLT5m
bGFncyB8PSBSQURFT05fUExMX0xFR0FDWTsKIApAQCAtNTU1LDI5ICs1NTYsMjcgQEAgc3RhdGlj
IHUzMiBhdG9tYmlvc19hZGp1c3RfcGxsKHN0cnVjdCBkcm1fY3J0YyAqY3J0YywKIAkJCQkJZHBf
Y2xvY2sgPSBkaWdfY29ubmVjdG9yLT5kcF9jbG9jazsKIAkJCQl9CiAJCQl9Ci0vKiB0aGlzIG1p
Z2h0IHdvcmsgcHJvcGVybHkgd2l0aCB0aGUgbmV3IHBsbCBhbGdvICovCi0jaWYgMCAvKiBkb2Vz
bid0IHdvcmsgcHJvcGVybHkgb24gc29tZSBsYXB0b3BzICovCisKIAkJCS8qIHVzZSByZWNvbW1l
bmRlZCByZWZfZGl2IGZvciBzcyAqLwogCQkJaWYgKHJhZGVvbl9lbmNvZGVyLT5kZXZpY2VzICYg
KEFUT01fREVWSUNFX0xDRF9TVVBQT1JUKSkgewogCQkJCWlmIChzc19lbmFibGVkKSB7CiAJCQkJ
CWlmIChzcy0+cmVmZGl2KSB7CiAJCQkJCQlwbGwtPmZsYWdzIHw9IFJBREVPTl9QTExfVVNFX1JF
Rl9ESVY7CiAJCQkJCQlwbGwtPnJlZmVyZW5jZV9kaXYgPSBzcy0+cmVmZGl2OworCQkJCQkJLypp
ZiAoQVNJQ19JU19BVklWTyhyZGV2KSkKKwkJCQkJCQlwbGwtPmZsYWdzIHw9IFJBREVPTl9QTExf
VVNFX0ZSQUNfRkJfRElWOyovCiAJCQkJCX0KIAkJCQl9CiAJCQl9Ci0jZW5kaWYKKwogCQkJaWYg
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
RF9QT1NUX0RJVjsKQEAgLTk1NywxMSArOTU2LDcgQEAgc3RhdGljIHZvaWQgYXRvbWJpb3NfY3J0
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
--20cf3054a585aa9cb9049c0b8d90--
