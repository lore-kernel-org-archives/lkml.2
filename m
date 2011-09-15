Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934380Ab1IOSXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:23:41 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:61813 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934312Ab1IOSXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:23:40 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxmW7rFEpanD-ngB-Egx5j1q8b_u31Keo3+s-TJ13UZGA@mail.gmail.com>
References: <web-606439650@zbackend1.aha.ru> <CA+55aFwyC7s=YK10Wkpr+GzdukXp-JUtf_=MgWcrhBOtTg4eTg@mail.gmail.com>
 <web-606798161@zbackend1.aha.ru> <CA+55aFwBuySWa2VErrfud_SFqyfT5ib+Qfq9gWBaBz=cQ6VcHg@mail.gmail.com>
 <web-606831561@zbackend1.aha.ru> <CAObL_7F2Pu0K1Oe3oLe5Pef2kaGE8vdO2qgfc0KEt8TJdUaOWg@mail.gmail.com>
 <CAObL_7E0iyinOyXU=uQHyQN+TBNmVVB89r_hQUb8LTqJ2ix_5A@mail.gmail.com>
 <CA+55aFzay+U5JA0Q6vdjmV73yG0OUXnO_zi6Q0c6iTkmozSSiw@mail.gmail.com>
 <web-607296211@zbackend1.aha.ru> <CAObL_7HAxg0j3ywpTy1-5Y5vBBQLSTiF7AZ0bctRsPOLKA8ZNA@mail.gmail.com>
 <CA+55aFwEKNEN8QPpBhAkDQ4UGFtSDtpdwFRSkTvnhaYRTmrsOA@mail.gmail.com>
 <CAObL_7Gjk91MFSwbaMnfdxwrM0mDGxWtDBaKMoimg2FSUqjAUg@mail.gmail.com> <CA+55aFxmW7rFEpanD-ngB-Egx5j1q8b_u31Keo3+s-TJ13UZGA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 15 Sep 2011 11:23:18 -0700
X-Google-Sender-Auth: UPZQSIYdipTYP8VyKdCZHAAQIYA
Message-ID: <CA+55aFxcibMZbEpJzP-LfV1aYFM-n9ctEqNMZ_k4XJxoZPfbrg@mail.gmail.com>
Subject: Re: 3.1-rc6 boot problem reason searching
To: Andrew Lutomirski <luto@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: werner <w.landgraf@ru.ru>
Content-Type: multipart/mixed; boundary=0016367b6a1ec882ba04acfef975
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016367b6a1ec882ba04acfef975
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Sep 15, 2011 at 11:15 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It *used* to have an alignment of 8 back before your patch to make the
> pointers be relative due to the 64-bit pointers. But now all fields
> are 32-bit, and it could easily have a size of just 12 bytes, getting
> rid of the 'pad2' field, and getting rid of the '.balign 8's.

IOW, maybe the correct patch is just the attached one.

Werner, does this fix the boot for you? It gets rid of all the bogus
alignment stuff, it's all wrong anyway, the altinstructions section
entries are all 12 bytes long so it starts out sufficiently aligned,
and it *stays* aligned because if anybody ever adds a non-12-byte
entry that would be a huge bug regardless. So any extra alignment is
just likely to be buggy and hide much bigger issues.

This is COMPLETELY UNTESTED, just looking at the source.

                     Linus

--0016367b6a1ec882ba04acfef975
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsm2hch10

IGFyY2gveDg2L2luY2x1ZGUvYXNtL2FsdGVybmF0aXZlLWFzbS5oIHwgICAgMSAtCiBhcmNoL3g4
Ni9pbmNsdWRlL2FzbS9hbHRlcm5hdGl2ZS5oICAgICB8ICAgIDQgLS0tLQogYXJjaC94ODYvaW5j
bHVkZS9hc20vY3B1ZmVhdHVyZS5oICAgICAgfCAgICAyIC0tCiAzIGZpbGVzIGNoYW5nZWQsIDAg
aW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS9hbHRlcm5hdGl2ZS1hc20uaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2FsdGVybmF0
aXZlLWFzbS5oCmluZGV4IDQ1NTRjYzZmYjk2YS4uMDkxNTA4YjUzM2I0IDEwMDY0NAotLS0gYS9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS9hbHRlcm5hdGl2ZS1hc20uaAorKysgYi9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS9hbHRlcm5hdGl2ZS1hc20uaApAQCAtMTYsNyArMTYsNiBAQAogI2VuZGlmCiAKIC5t
YWNybyBhbHRpbnN0cnVjdGlvbl9lbnRyeSBvcmlnIGFsdCBmZWF0dXJlIG9yaWdfbGVuIGFsdF9s
ZW4KLQkuYWxpZ24gOAogCS5sb25nIFxvcmlnIC0gLgogCS5sb25nIFxhbHQgLSAuCiAJLndvcmQg
XGZlYXR1cmUKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2FsdGVybmF0aXZlLmgg
Yi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9hbHRlcm5hdGl2ZS5oCmluZGV4IDIzZmI2ZDc5ZjIwOS4u
MzdhZDEwMGEyMjEwIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9hbHRlcm5hdGl2
ZS5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2FsdGVybmF0aXZlLmgKQEAgLTQ4LDkgKzQ4
LDYgQEAgc3RydWN0IGFsdF9pbnN0ciB7CiAJdTE2IGNwdWlkOwkJLyogY3B1aWQgYml0IHNldCBm
b3IgcmVwbGFjZW1lbnQgKi8KIAl1OCAgaW5zdHJsZW47CQkvKiBsZW5ndGggb2Ygb3JpZ2luYWwg
aW5zdHJ1Y3Rpb24gKi8KIAl1OCAgcmVwbGFjZW1lbnRsZW47CS8qIGxlbmd0aCBvZiBuZXcgaW5z
dHJ1Y3Rpb24sIDw9IGluc3RybGVuICovCi0jaWZkZWYgQ09ORklHX1g4Nl82NAotCXUzMiBwYWQy
OwotI2VuZGlmCiB9OwogCiBleHRlcm4gdm9pZCBhbHRlcm5hdGl2ZV9pbnN0cnVjdGlvbnModm9p
ZCk7CkBAIC04Myw3ICs4MCw2IEBAIHN0YXRpYyBpbmxpbmUgaW50IGFsdGVybmF0aXZlc190ZXh0
X3Jlc2VydmVkKHZvaWQgKnN0YXJ0LCB2b2lkICplbmQpCiAJCQkJCQkJCQlcCiAgICAgICAiNjYx
OlxuXHQiIG9sZGluc3RyICJcbjY2MjpcbiIJCQkJCVwKICAgICAgICIuc2VjdGlvbiAuYWx0aW5z
dHJ1Y3Rpb25zLFwiYVwiXG4iCQkJCVwKLSAgICAgIF9BU01fQUxJR04gIlxuIgkJCQkJCQlcCiAg
ICAgICAiCSAubG9uZyA2NjFiIC0gLlxuIgkJCS8qIGxhYmVsICAgICAgICAgICAqLwlcCiAgICAg
ICAiCSAubG9uZyA2NjNmIC0gLlxuIgkJCS8qIG5ldyBpbnN0cnVjdGlvbiAqLwlcCiAgICAgICAi
CSAud29yZCAiIF9fc3RyaW5naWZ5KGZlYXR1cmUpICJcbiIJLyogZmVhdHVyZSBiaXQgICAgICov
CVwKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmUuaCBiL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmUuaAppbmRleCA0MjU4YWFjOTlhNmUuLjg4YjIzYTQz
ZjM0MCAxMDA2NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZS5oCisrKyBi
L2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmUuaApAQCAtMzMyLDcgKzMzMiw2IEBAIHN0
YXRpYyBfX2Fsd2F5c19pbmxpbmUgX19wdXJlIGJvb2wgX19zdGF0aWNfY3B1X2hhcyh1MTYgYml0
KQogCQlhc20gZ290bygiMTogam1wICVsW3Rfbm9dXG4iCiAJCQkgIjI6XG4iCiAJCQkgIi5zZWN0
aW9uIC5hbHRpbnN0cnVjdGlvbnMsXCJhXCJcbiIKLQkJCSBfQVNNX0FMSUdOICJcbiIKIAkJCSAi
IC5sb25nIDFiIC0gLlxuIgogCQkJICIgLmxvbmcgMFxuIgkJLyogbm8gcmVwbGFjZW1lbnQgKi8K
IAkJCSAiIC53b3JkICVQMFxuIgkJLyogZmVhdHVyZSBiaXQgKi8KQEAgLTM1MCw3ICszNDksNiBA
QCBzdGF0aWMgX19hbHdheXNfaW5saW5lIF9fcHVyZSBib29sIF9fc3RhdGljX2NwdV9oYXModTE2
IGJpdCkKIAkJYXNtIHZvbGF0aWxlKCIxOiBtb3ZiICQwLCUwXG4iCiAJCQkgICAgICIyOlxuIgog
CQkJICAgICAiLnNlY3Rpb24gLmFsdGluc3RydWN0aW9ucyxcImFcIlxuIgotCQkJICAgICBfQVNN
X0FMSUdOICJcbiIKIAkJCSAgICAgIiAubG9uZyAxYiAtIC5cbiIKIAkJCSAgICAgIiAubG9uZyAz
ZiAtIC5cbiIKIAkJCSAgICAgIiAud29yZCAlUDFcbiIJCS8qIGZlYXR1cmUgYml0ICovCg==
--0016367b6a1ec882ba04acfef975--
