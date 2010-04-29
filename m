Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0D2DaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 23:30:22 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59208 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0D2DaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 23:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rE6LQeppZulnPhLlFXTkK4BSDmyBrA8eKAaB7CQG3zEw4gN219ZuFUFEM7K6uDuebX
         jmUXMJsYiQZWB9EWrGjNNfId4GtLxttqAjBrXSMlEmeSqvajyRpdG14xL04ch7qdnNlD
         sWnFfY7Xj7Vw0qhkZquEnNNYz4qBPgdCuzoWg=
MIME-Version: 1.0
In-Reply-To: <20100427120516.c18b3bbb.akpm@linux-foundation.org>
References: <90b950fc1003252024i5ba8989bg95f0a81e8e5e708e@mail.gmail.com>
	 <20100330160257.e5f978a9.akpm@linux-foundation.org>
	 <90b950fc1003301941r69dc5ce1ida64b590646049a7@mail.gmail.com>
	 <20100330195501.747515e9.akpm@linux-foundation.org>
	 <20100427120516.c18b3bbb.akpm@linux-foundation.org>
Date: Thu, 29 Apr 2010 12:30:17 +0900
Message-ID: <l2n90b950fc1004282030j173e7c47ua21b92a56881f559@mail.gmail.com>
Subject: Re: [PATCH] added S6E63M0 AMOLED LCD Panel driver.
From: InKi Dae <daeinki@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Content-Type: multipart/mixed; boundary=000e0cd1a588e2847b048557be7d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd1a588e2847b048557be7d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I'm sorry for being late.

this is second patch that your concern is solved.

Please review this patch.

Thank you.

Best Regards,
InKi Dae.

2010/4/28 Andrew Morton <akpm@linux-foundation.org>:
> On Tue, 30 Mar 2010 19:55:01 -0400
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Wed, 31 Mar 2010 11:41:54 +0900 InKi Dae <daeinki@gmail.com> wrote:
>>
>> > Hi Andrew,
>> >
>> > all the calls to s6e63m0_panel_send_sequence() would return -EINVAL.
>> > by api_async() of driver/spi/spi.c
>>
>> No, spi_async() does
>>
>> =A0 =A0 =A0 master->transfer(spi, message);
>>
>> which can return at least EIO, EINPROGRESS, EINVAL or ETIMEDOUT.
>>
>> > so I think that those return values aren't changed to other.
>> >
>> > and final step is to check only whether the return value is 0 or not.
>> > if you still think that this code has minor problem or you want it to
>> > be corrected
>> > then I will patch this code to be corrected anytime.
>>
>> It's a bug.
>>
>> Also s6e63m0_power_on() is sloppy. =A0It again or's together disparate
>> errnos. =A0Then if _anything_ failed it returns hardwired -EIO, but it
>> should instead propagate the callee's errno back up to the caller.
>>
>> And s6e63m0_power_on() can return -EFAULT in several places, which is
>> nonsensical.
>>
>> None of this is very critical, just ... sloppy.
>>
>
> ping?
>

--000e0cd1a588e2847b048557be7d
Content-Type: application/octet-stream; name="s6e63m0_second.patch"
Content-Disposition: attachment; filename="s6e63m0_second.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g8l0m1m60

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vYmFja2xpZ2h0L3M2ZTYzbTAuYyBiL2RyaXZlcnMv
dmlkZW8vYmFja2xpZ2h0L3M2ZTYzbTAuYwppbmRleCBlNDc5M2RmLi4yNTRhMDk5IDEwMDY0NAot
LS0gYS9kcml2ZXJzL3ZpZGVvL2JhY2tsaWdodC9zNmU2M20wLmMKKysrIGIvZHJpdmVycy92aWRl
by9iYWNrbGlnaHQvczZlNjNtMC5jCkBAIC00MjAsMTMgKzQyMCwyNSBAQCBzdGF0aWMgaW50IF9z
NmU2M20wX2dhbW1hX2N0bChzdHJ1Y3QgczZlNjNtMCAqbGNkLCBjb25zdCB1bnNpZ25lZCBpbnQg
KmdhbW1hKQogCiAJLyogZGlzYWJsZSBnYW1tYSB0YWJsZSB1cGRhdGluZy4gKi8KIAlyZXQgPSBz
NmU2M20wX3NwaV93cml0ZShsY2QsIDB4ZmEsIDB4MDApOworCWlmIChyZXQpIHsKKwkJZGV2X2Vy
cihsY2QtPmRldiwgImZhaWxlZCB0byBkaXNhYmxlIGdhbW1hIHRhYmxlIHVwZGF0aW5nLlxuIik7
CisJCWdvdG8gZ2FtbWFfZXJyOworCX0KIAotCWZvciAoaSA9IDAgOyBpIDwgR0FNTUFfVEFCTEVf
Q09VTlQ7IGkrKykKLQkJcmV0IHw9IHM2ZTYzbTBfc3BpX3dyaXRlKGxjZCwgREFUQV9PTkxZLCBn
YW1tYVtpXSk7CisJZm9yIChpID0gMCA7IGkgPCBHQU1NQV9UQUJMRV9DT1VOVDsgaSsrKSB7CisJ
CXJldCA9IHM2ZTYzbTBfc3BpX3dyaXRlKGxjZCwgREFUQV9PTkxZLCBnYW1tYVtpXSk7CisJCWlm
IChyZXQpIHsKKwkJCWRldl9lcnIobGNkLT5kZXYsICJmYWlsZWQgdG8gc2V0IGdhbW1hIHRhYmxl
LlxuIik7CisJCQlnb3RvIGdhbW1hX2VycjsKKwkJfQorCX0KIAogCS8qIHVwZGF0ZSBnYW1tYSB0
YWJsZS4gKi8KLQlyZXQgfD0gczZlNjNtMF9zcGlfd3JpdGUobGNkLCAweGZhLCAweDAxKTsKKwly
ZXQgPSBzNmU2M20wX3NwaV93cml0ZShsY2QsIDB4ZmEsIDB4MDEpOworCWlmIChyZXQpCisJCWRl
dl9lcnIobGNkLT5kZXYsICJmYWlsZWQgdG8gdXBkYXRlIGdhbW1hIHRhYmxlLlxuIik7CiAKK2dh
bW1hX2VycjoKIAlyZXR1cm4gcmV0OwogfQogCkBAIC00NDIsMjQgKzQ1NCwzOCBAQCBzdGF0aWMg
aW50IHM2ZTYzbTBfZ2FtbWFfY3RsKHN0cnVjdCBzNmU2M20wICpsY2QsIGludCBnYW1tYSkKIAog
c3RhdGljIGludCBzNmU2M20wX2xkaV9pbml0KHN0cnVjdCBzNmU2M20wICpsY2QpCiB7Ci0JaW50
IHJldDsKKwlpbnQgcmV0LCBpOworCWNvbnN0IHVuc2lnbmVkIHNob3J0ICppbml0X3NlcVtdID0g
eworCQlTRVFfUEFORUxfQ09ORElUSU9OX1NFVCwKKwkJU0VRX0RJU1BMQVlfQ09ORElUSU9OX1NF
VCwKKwkJU0VRX0dBTU1BX1NFVFRJTkcsCisJCVNFUV9FVENfQ09ORElUSU9OX1NFVCwKKwkJU0VR
X0FDTF9PTiwKKwkJU0VRX0VMVlNTX09OLAorCX07CiAKLQlyZXQgPSBzNmU2M20wX3BhbmVsX3Nl
bmRfc2VxdWVuY2UobGNkLCBTRVFfUEFORUxfQ09ORElUSU9OX1NFVCk7Ci0JcmV0IHw9IHM2ZTYz
bTBfcGFuZWxfc2VuZF9zZXF1ZW5jZShsY2QsIFNFUV9ESVNQTEFZX0NPTkRJVElPTl9TRVQpOwot
CXJldCB8PSBzNmU2M20wX3BhbmVsX3NlbmRfc2VxdWVuY2UobGNkLCBTRVFfR0FNTUFfU0VUVElO
Ryk7Ci0JcmV0IHw9IHM2ZTYzbTBfcGFuZWxfc2VuZF9zZXF1ZW5jZShsY2QsIFNFUV9FVENfQ09O
RElUSU9OX1NFVCk7Ci0JcmV0IHw9IHM2ZTYzbTBfcGFuZWxfc2VuZF9zZXF1ZW5jZShsY2QsIFNF
UV9BQ0xfT04pOwotCXJldCB8PSBzNmU2M20wX3BhbmVsX3NlbmRfc2VxdWVuY2UobGNkLCBTRVFf
RUxWU1NfT04pOworCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKGluaXRfc2VxKTsgaSsrKSB7
CisJCXJldCA9IHM2ZTYzbTBfcGFuZWxfc2VuZF9zZXF1ZW5jZShsY2QsIGluaXRfc2VxW2ldKTsK
KwkJaWYgKHJldCkKKwkJCWJyZWFrOworCX0KIAogCXJldHVybiByZXQ7CiB9CiAKIHN0YXRpYyBp
bnQgczZlNjNtMF9sZGlfZW5hYmxlKHN0cnVjdCBzNmU2M20wICpsY2QpCiB7Ci0JaW50IHJldCA9
IDA7CisJaW50IHJldCA9IDAsIGk7CisJY29uc3QgdW5zaWduZWQgc2hvcnQgKmVuYWJsZV9zZXFb
XSA9IHsKKwkJU0VRX1NUQU5EX0JZX09GRiwKKwkJU0VRX0RJU1BMQVlfT04sCisJfTsKIAotCXJl
dCA9IHM2ZTYzbTBfcGFuZWxfc2VuZF9zZXF1ZW5jZShsY2QsIFNFUV9TVEFORF9CWV9PRkYpOwot
CXJldCA9IHM2ZTYzbTBfcGFuZWxfc2VuZF9zZXF1ZW5jZShsY2QsIFNFUV9ESVNQTEFZX09OKTsK
Kwlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRShlbmFibGVfc2VxKTsgaSsrKSB7CisJCXJldCA9
IHM2ZTYzbTBfcGFuZWxfc2VuZF9zZXF1ZW5jZShsY2QsIGVuYWJsZV9zZXFbaV0pOworCQlpZiAo
cmV0KQorCQkJYnJlYWs7CisJfQogCiAJcmV0dXJuIHJldDsKIH0KQEAgLTUwOCwxMiArNTM0LDIy
IEBAIHN0YXRpYyBpbnQgczZlNjNtMF9wb3dlcl9vbihzdHJ1Y3QgczZlNjNtMCAqbGNkKQogCX0K
IAogCXJldCA9IHM2ZTYzbTBfbGRpX2luaXQobGNkKTsKLQlyZXQgfD0gczZlNjNtMF9sZGlfZW5h
YmxlKGxjZCk7CisJaWYgKHJldCkgeworCQlkZXZfZXJyKGxjZC0+ZGV2LCAiZmFpbGVkIHRvIGlu
aXRpYWxpemUgbGRpLlxuIik7CisJCXJldHVybiByZXQ7CisJfQorCisJcmV0ID0gczZlNjNtMF9s
ZGlfZW5hYmxlKGxjZCk7CisJaWYgKHJldCkgeworCQlkZXZfZXJyKGxjZC0+ZGV2LCAiZmFpbGVk
IHRvIGVuYWJsZSBsZGkuXG4iKTsKKwkJcmV0dXJuIHJldDsKKwl9CisKIAkvKiBzZXQgYnJpZ2h0
bmVzcyB0byBjdXJyZW50IHZhbHVlIGFmdGVyIHBvd2VyIG9uIG9yIHJlc3VtZS4gKi8KLQlyZXQg
fD0gczZlNjNtMF9nYW1tYV9jdGwobGNkLCBiZC0+cHJvcHMuYnJpZ2h0bmVzcyk7CisJcmV0ID0g
czZlNjNtMF9nYW1tYV9jdGwobGNkLCBiZC0+cHJvcHMuYnJpZ2h0bmVzcyk7CiAJaWYgKHJldCkg
ewogCQlkZXZfZXJyKGxjZC0+ZGV2LCAibGNkIGdhbW1hIHNldHRpbmcgZmFpbGVkLlxuIik7Ci0J
CXJldHVybiAtRUlPOworCQlyZXR1cm4gcmV0OwogCX0KIAogCXJldHVybiAwOwo=
--000e0cd1a588e2847b048557be7d--
