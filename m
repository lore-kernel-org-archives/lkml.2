Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0IDQ3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 12:29:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65235 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab0IDQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 12:29:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=xbMXMKcdanScX/We2ua+S6ldPAsXV3Xq6R/XZoKUbd8OYw+dNsmSObUZtaweUOL5wI
         5qCQS5lsysl19f7/Jjqbs863QF8eQ/UkV2E/4Srwklucv7T6L1pKwy3w7UJepsJLKCWo
         f8YvsCB4Ku78gsxD2M8uutxBcDaX0J9RppaFI=
MIME-Version: 1.0
In-Reply-To: <89k83a$9hv9li@azsmga001.ch.intel.com>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org>
	<89k83a$9hv9li@azsmga001.ch.intel.com>
Date: Sat, 4 Sep 2010 19:29:12 +0300
X-Google-Sender-Auth: iKE9653_1AE426i2wpzLhK4mnik
Message-ID: <AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
From: Pekka Enberg <penberg@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: multipart/mixed; boundary=0022150482bb2aaddf048f718c20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0022150482bb2aaddf048f718c20
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, =A04 Sep 2010 11:17:14 +0300, Pekka Enberg <penberg@kernel.org> wro=
te:
>> This reverts commit 9559fcdbff4f93d29af04478bbc48294519424f5. The commit=
 causes
>> wrong screen resolution on some i915 machines such as MacBook which is a
>> regression from 2.6.35. The issue has been reported multiple times but n=
o fix
>> has emerged:

On Sat, Sep 4, 2010 at 12:21 PM, Chris Wilson <chris@chris-wilson.co.uk> wr=
ote:
> NAK. You can't simply hide one bug by introducing a much bigger one.

Dude, it's a nasty regression from 2.6.35. What exactly are you NAK'ing her=
e?

> As you have an affected machine, find which wait_for_vblank() needs to be
> replaced with a msleep(20|50).

The attached patch fixes things here. I'm not a drm developer so I
don't know if it makes technical sense.

--0022150482bb2aaddf048f718c20
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-i915-Fix-wrong-resolution-after-boot-problem.patch"
Content-Disposition: attachment; 
	filename="0001-i915-Fix-wrong-resolution-after-boot-problem.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gdoot16m0

RnJvbSA1M2U1ODQwYTZhYmI1MGYxMmY5ZDJiMzJlZmEyYTQ3MmIyMDNkNTJmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQZWtrYSBFbmJlcmcgPHBlbmJlcmdAa2VybmVsLm9yZz4KRGF0
ZTogU2F0LCA0IFNlcCAyMDEwIDE5OjI0OjA0ICswMzAwClN1YmplY3Q6IFtQQVRDSF0gaTkxNTog
Rml4IHdyb25nIHJlc29sdXRpb24gYWZ0ZXIgYm9vdCBwcm9ibGVtCgpTaWduZWQtb2ZmLWJ5OiBQ
ZWtrYSBFbmJlcmcgPHBlbmJlcmdAa2VybmVsLm9yZz4KLS0tCiBkcml2ZXJzL2dwdS9kcm0vaTkx
NS9pbnRlbF90di5jIHwgICAgNSArKy0tLQogMSBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50
ZWxfdHYuYyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3R2LmMKaW5kZXggZDIwMjllZi4u
Nzc4NGZmOCAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfdHYuYworKysg
Yi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF90di5jCkBAIC0xMjMxLDcgKzEyMzEsNiBAQCBp
bnRlbF90dl9kZXRlY3RfdHlwZSAoc3RydWN0IGludGVsX3R2ICppbnRlbF90dikKIAlzdHJ1Y3Qg
ZHJtX2VuY29kZXIgKmVuY29kZXIgPSAmaW50ZWxfdHYtPmJhc2UuZW5jOwogCXN0cnVjdCBkcm1f
ZGV2aWNlICpkZXYgPSBlbmNvZGVyLT5kZXY7CiAJc3RydWN0IGRybV9pOTE1X3ByaXZhdGUgKmRl
dl9wcml2ID0gZGV2LT5kZXZfcHJpdmF0ZTsKLQlzdHJ1Y3QgaW50ZWxfY3J0YyAqaW50ZWxfY3J0
YyA9IHRvX2ludGVsX2NydGMoZW5jb2Rlci0+Y3J0Yyk7CiAJdW5zaWduZWQgbG9uZyBpcnFmbGFn
czsKIAl1MzIgdHZfY3RsLCBzYXZlX3R2X2N0bDsKIAl1MzIgdHZfZGFjLCBzYXZlX3R2X2RhYzsK
QEAgLTEyNjgsMTEgKzEyNjcsMTEgQEAgaW50ZWxfdHZfZGV0ZWN0X3R5cGUgKHN0cnVjdCBpbnRl
bF90diAqaW50ZWxfdHYpCiAJCSAgIERBQ19DXzBfN19WKTsKIAlJOTE1X1dSSVRFKFRWX0NUTCwg
dHZfY3RsKTsKIAlJOTE1X1dSSVRFKFRWX0RBQywgdHZfZGFjKTsKLQlpbnRlbF93YWl0X2Zvcl92
YmxhbmsoZGV2LCBpbnRlbF9jcnRjLT5waXBlKTsKKwltc2xlZXAoMjApOwogCXR2X2RhYyA9IEk5
MTVfUkVBRChUVl9EQUMpOwogCUk5MTVfV1JJVEUoVFZfREFDLCBzYXZlX3R2X2RhYyk7CiAJSTkx
NV9XUklURShUVl9DVEwsIHNhdmVfdHZfY3RsKTsKLQlpbnRlbF93YWl0X2Zvcl92YmxhbmsoZGV2
LCBpbnRlbF9jcnRjLT5waXBlKTsKKwltc2xlZXAoMjApOwogCS8qCiAJICogIEEgQiBDCiAJICog
IDAgMSAxIENvbXBvc2l0ZQotLSAKMS42LjMuMwoK
--0022150482bb2aaddf048f718c20--
