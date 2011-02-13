Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1BMXrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 18:47:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40585 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab1BMXq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 18:46:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VdJjC3nyJzthhonu7GeM0ddNyVE2Lc+i3733dzTAQ6+KZ1D3qIM/0ROTm+pmIaTE8A
         wLWc7HqTv0o32zHl8ylWMITnJRrIu9PX2TcKlYE9OxFzx1V1s1U8h57mHKY20yDwrpxX
         DD2MxR4wzX1zPS1j4Y1CxUdKhUKI6/06iq5VE=
MIME-Version: 1.0
In-Reply-To: <1838D776-BF70-4ABE-98CB-EFDCF828F6CF@gmail.com>
References: <4D51AD03.7030401@gmail.com>
	<AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com>
	<AANLkTimBwM=iacwPosrYXU_jN=DXnEkWL3jvFcarDN23@mail.gmail.com>
	<B44733BE-E28B-441E-9E6B-AE9B0C8D7E45@gmail.com>
	<AANLkTimdE6G=qf+wLLSogma-BbH9J0_DYRv7aJkP9P64@mail.gmail.com>
	<AANLkTi=Ppzicpz5a6AO5rrGkv=j3HPmiB7Er4VGj4OVU@mail.gmail.com>
	<C0E6BA6B-174B-4930-A5C5-7DB87FDFAD1F@gmail.com>
	<AANLkTinca2027s9-g0tLabBMj4fr2+e=xgUSymBqvv1o@mail.gmail.com>
	<1838D776-BF70-4ABE-98CB-EFDCF828F6CF@gmail.com>
Date: Sun, 13 Feb 2011 18:46:55 -0500
Message-ID: <AANLkTikrZZ6i6di-c0zBav0zT5OOvmOXvX7SAXTW18z+@mail.gmail.com>
Subject: Re: [BISECTED] commit 619efb1059 makes the MacBookPro2,2 screen
 flicker like its broken or half plugged in
From: Alex Deucher <alexdeucher@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@redhat.com
Content-Type: multipart/mixed; boundary=0016e6da98bed9f1d9049c328b34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6da98bed9f1d9049c328b34
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 13, 2011 at 12:28 AM, Justin Mattock
<justinmattock@gmail.com> wrote:
>
> On Feb 11, 2011, at 5:15 PM, Alex Deucher wrote:
>
>> On Fri, Feb 11, 2011 at 10:57 AM, Justin Mattock
>> <justinmattock@gmail.com> wrote:
>>>
>>>>
>>>> Better yet, can you try the attached patch on top of 2.6.38-rc4 or
>>>> newer?
>>>>
>>>> Alex
>>>>
>>>
>>> o.k. applied that patch... unfortunately Im seeing the flickering scree=
n
>>> and
>>> the crud shows up..
>>> initially during boot everything looked fine, its when I suspended the
>>> machine, upon wake-up
>>> the flickering occurred.
>>> kernel version is the current: 2.6.38-rc4-00107-gaa502b4
>>
>> Can you try this patch? =A0Try uncommenting the following lines to see
>> if either of those flags work any better. =A0Try them individually and
>> together if possible and report back which, if any, helps.
>>
>> /*pll->flags |=3D RADEON_PLL_PREFER_MINM_OVER_MAXP;*/
>>
>> /*if (ASIC_IS_AVIVO(rdev))
>> =A0 =A0 =A0 pll->flags |=3D RADEON_PLL_USE_FRAC_FB_DIV;*/
>>
>> Thanks!
>>
>> Alex
>>
>>>
>>> Justin P. Mattock
>>>
>> <0001-drm-radeon-kms-hopefully-fix-pll-issues-for-real-v2.patch>
>
>
> alright.. again out of my office trying to make a living!!
> Anyways I applied the two earlier patches, and added the previous post's
> patch as well
> (everything runs o.k. s2r etc...)
> I can try for the above and see if I can pinpoint the piece of code that =
is
> causing this(hopefully)

The attached patch is what I'm proposing to go upstream.  Please test
and let me know if it works ok for you.

Alex

>
> Justin P. Mattock
>

--0016e6da98bed9f1d9049c328b34
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-hopefully-fix-pll-issues-for-real-v3.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-hopefully-fix-pll-issues-for-real-v3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gk4ls61l0

RnJvbSAzMmY1MTlkMzJjYTljYTBmODRlODE5NTNjOGQ5ZGRlZmRiNzc3MWQzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogU3VuLCAxMyBGZWIgMjAxMSAxODozODoyMyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGRy
bS9yYWRlb24va21zOiBob3BlZnVsbHkgZml4IHBsbCBpc3N1ZXMgZm9yIHJlYWwgKHYzKQoKVGhl
IHByb2JsZW1hdGljIGJvYXJkcyBoYXZlIGEgcmVjb21tZW5kZWQgcmVmZXJlbmNlIGRpdmlkZXIK
dG8gYmUgdXNlZCB3aGVuIHNwcmVhZCBzcGVjdHJ1bSBpcyBlbmFibGVkIG9uIHRoZSBsYXB0b3Ag
cGFuZWwuCkVuYWJsZSB0aGUgdXNlIG9mIHRoZSByZWNvbW1lbmRlZCByZWZlcmVuY2UgZGl2aWRl
ciBhbG9uZyB3aXRoCnRoZSBuZXcgcGxsIGFsZ28uCgp2MjogdGVzdGluZyBvcHRpb25zCgp2Mzog
V2hlbiB1c2luZyB0aGUgZml4ZWQgcmVmZXJlbmNlIGRpdmlkZXIgd2l0aApMVkRTLCBwcmVmZXIg
bWluIG0gdG8gbWF4IHAgYW5kIHVzZSBmcmFjdGlvbmFsIGZlZWRiYWNrIGRpdmlkZXJzLgoKU2ln
bmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4ZGV1Y2hlckBnbWFpbC5jb20+CkNjOiBzdGFi
bGVAa2VybmVsLm9yZwotLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0Yy5j
IHwgICAyMiArKysrKysrKy0tLS0tLS0tLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0
aW9ucygrKSwgMTQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3Jh
ZGVvbi9hdG9tYmlvc19jcnRjLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2Ny
dGMuYwppbmRleCAxYmY2MTIyLi4zMTI3YTI4IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0v
cmFkZW9uL2F0b21iaW9zX2NydGMuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21i
aW9zX2NydGMuYwpAQCAtNTM4LDcgKzUzOCw2IEBAIHN0YXRpYyB1MzIgYXRvbWJpb3NfYWRqdXN0
X3BsbChzdHJ1Y3QgZHJtX2NydGMgKmNydGMsCiAJCQlwbGwtPmZsYWdzIHw9IFJBREVPTl9QTExf
UFJFRkVSX0hJR0hfRkJfRElWOwogCQllbHNlCiAJCQlwbGwtPmZsYWdzIHw9IFJBREVPTl9QTExf
UFJFRkVSX0xPV19SRUZfRElWOwotCiAJfQogCiAJbGlzdF9mb3JfZWFjaF9lbnRyeShlbmNvZGVy
LCAmZGV2LT5tb2RlX2NvbmZpZy5lbmNvZGVyX2xpc3QsIGhlYWQpIHsKQEAgLTU1NSwyOSArNTU0
LDI4IEBAIHN0YXRpYyB1MzIgYXRvbWJpb3NfYWRqdXN0X3BsbChzdHJ1Y3QgZHJtX2NydGMgKmNy
dGMsCiAJCQkJCWRwX2Nsb2NrID0gZGlnX2Nvbm5lY3Rvci0+ZHBfY2xvY2s7CiAJCQkJfQogCQkJ
fQotLyogdGhpcyBtaWdodCB3b3JrIHByb3Blcmx5IHdpdGggdGhlIG5ldyBwbGwgYWxnbyAqLwot
I2lmIDAgLyogZG9lc24ndCB3b3JrIHByb3Blcmx5IG9uIHNvbWUgbGFwdG9wcyAqLworCiAJCQkv
KiB1c2UgcmVjb21tZW5kZWQgcmVmX2RpdiBmb3Igc3MgKi8KIAkJCWlmIChyYWRlb25fZW5jb2Rl
ci0+ZGV2aWNlcyAmIChBVE9NX0RFVklDRV9MQ0RfU1VQUE9SVCkpIHsKKwkJCQlwbGwtPmZsYWdz
IHw9IFJBREVPTl9QTExfUFJFRkVSX01JTk1fT1ZFUl9NQVhQOwogCQkJCWlmIChzc19lbmFibGVk
KSB7CiAJCQkJCWlmIChzcy0+cmVmZGl2KSB7CiAJCQkJCQlwbGwtPmZsYWdzIHw9IFJBREVPTl9Q
TExfVVNFX1JFRl9ESVY7CiAJCQkJCQlwbGwtPnJlZmVyZW5jZV9kaXYgPSBzcy0+cmVmZGl2Owor
CQkJCQkJaWYgKEFTSUNfSVNfQVZJVk8ocmRldikpCisJCQkJCQkJcGxsLT5mbGFncyB8PSBSQURF
T05fUExMX1VTRV9GUkFDX0ZCX0RJVjsKIAkJCQkJfQogCQkJCX0KIAkJCX0KLSNlbmRpZgorCiAJ
CQlpZiAoQVNJQ19JU19BVklWTyhyZGV2KSkgewogCQkJCS8qIERWTyB3YW50cyAyeCBwaXhlbCBj
bG9jayBpZiB0aGUgRFZPIGNoaXAgaXMgaW4gMTIgYml0IG1vZGUgKi8KIAkJCQlpZiAocmFkZW9u
X2VuY29kZXItPmVuY29kZXJfaWQgPT0gRU5DT0RFUl9PQkpFQ1RfSURfSU5URVJOQUxfS0xEU0NQ
X0RWTzEpCiAJCQkJCWFkanVzdGVkX2Nsb2NrID0gbW9kZS0+Y2xvY2sgKiAyOwogCQkJCWlmIChy
YWRlb25fZW5jb2Rlci0+YWN0aXZlX2RldmljZSAmIChBVE9NX0RFVklDRV9UVl9TVVBQT1JUKSkK
IAkJCQkJcGxsLT5mbGFncyB8PSBSQURFT05fUExMX1BSRUZFUl9DTE9TRVNUX0xPV0VSOwotCQkJ
CS8qIHJ2NTE1IG5lZWRzIG1vcmUgdGVzdGluZyB3aXRoIHRoaXMgb3B0aW9uICovCi0JCQkJaWYg
KHJkZXYtPmZhbWlseSAhPSBDSElQX1JWNTE1KSB7Ci0JCQkJCWlmIChyYWRlb25fZW5jb2Rlci0+
ZGV2aWNlcyAmIChBVE9NX0RFVklDRV9MQ0RfU1VQUE9SVCkpCi0JCQkJCQlwbGwtPmZsYWdzIHw9
IFJBREVPTl9QTExfSVNfTENEOwotCQkJCX0KKwkJCQlpZiAocmFkZW9uX2VuY29kZXItPmRldmlj
ZXMgJiAoQVRPTV9ERVZJQ0VfTENEX1NVUFBPUlQpKQorCQkJCQlwbGwtPmZsYWdzIHw9IFJBREVP
Tl9QTExfSVNfTENEOwogCQkJfSBlbHNlIHsKIAkJCQlpZiAoZW5jb2Rlci0+ZW5jb2Rlcl90eXBl
ICE9IERSTV9NT0RFX0VOQ09ERVJfREFDKQogCQkJCQlwbGwtPmZsYWdzIHw9IFJBREVPTl9QTExf
Tk9fT0REX1BPU1RfRElWOwpAQCAtOTU3LDExICs5NTUsNyBAQCBzdGF0aWMgdm9pZCBhdG9tYmlv
c19jcnRjX3NldF9wbGwoc3RydWN0IGRybV9jcnRjICpjcnRjLCBzdHJ1Y3QgZHJtX2Rpc3BsYXlf
bW9kZQogCS8qIGFkanVzdCBwaXhlbCBjbG9jayBhcyBuZWVkZWQgKi8KIAlhZGp1c3RlZF9jbG9j
ayA9IGF0b21iaW9zX2FkanVzdF9wbGwoY3J0YywgbW9kZSwgcGxsLCBzc19lbmFibGVkLCAmc3Mp
OwogCi0JLyogcnY1MTUgc2VlbXMgaGFwcGllciB3aXRoIHRoZSBvbGQgYWxnbyAqLwotCWlmIChy
ZGV2LT5mYW1pbHkgPT0gQ0hJUF9SVjUxNSkKLQkJcmFkZW9uX2NvbXB1dGVfcGxsX2xlZ2FjeShw
bGwsIGFkanVzdGVkX2Nsb2NrLCAmcGxsX2Nsb2NrLCAmZmJfZGl2LCAmZnJhY19mYl9kaXYsCi0J
CQkJCSAgJnJlZl9kaXYsICZwb3N0X2Rpdik7Ci0JZWxzZSBpZiAoQVNJQ19JU19BVklWTyhyZGV2
KSkKKwlpZiAoQVNJQ19JU19BVklWTyhyZGV2KSkKIAkJcmFkZW9uX2NvbXB1dGVfcGxsX2F2aXZv
KHBsbCwgYWRqdXN0ZWRfY2xvY2ssICZwbGxfY2xvY2ssICZmYl9kaXYsICZmcmFjX2ZiX2RpdiwK
IAkJCQkJICZyZWZfZGl2LCAmcG9zdF9kaXYpOwogCWVsc2UKLS0gCjEuNy4xLjEKCg==
--0016e6da98bed9f1d9049c328b34--
