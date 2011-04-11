Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1DKRs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:48:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754720Ab1DKRs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:48:58 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=R_D9ujCFeKv_o_U83GAR35X3TOQ@mail.gmail.com>
References: <BANLkTi=n+ckDXVk6rN=Mgh+BApbrPqPfmg@mail.gmail.com> <BANLkTi=R_D9ujCFeKv_o_U83GAR35X3TOQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Apr 2011 10:48:08 -0700
Message-ID: <BANLkTimfpRwsBUWcoNA1uDb8QfQP6USKEA@mail.gmail.com>
Subject: Re: Crash with kfree(null) on MacBook? kobject_set_name_vargs
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Botting <andy@andybotting.com>
Content-Type: multipart/mixed; boundary=0022154012faddd82104a0a82ecb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0022154012faddd82104a0a82ecb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2011/4/11 Linus Torvalds <torvalds@linux-foundation.org>:
>
> prints out NULL is because the string printout code does this:
>
> =A0 =A0 =A0 =A0if ((unsigned long)s < PAGE_SIZE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s =3D "(null)";
>
> which admittedly is not very helpful in this case (but it's usually
> nicer than just oopsing).

You could try this (UNTESTED!) patch to avoid this particular issue.
It will (well, unless I screwed up) print non-NULL pointers as the hex
value they have. So you should see "0x202" instead of "(null)" in that
case.

Of course, it sounds like _you_ don't actually see the bug at all,
because for you it probably really _is_ NULL. The people who see the
bug have some random non-null value, probably because of the field
just not being initialized properly, and containing some crud.

                                       Linus

--0022154012faddd82104a0a82ecb
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmdp3x0v0

IGxpYi92c3ByaW50Zi5jIHwgICAgOCArKysrKysrLQogMSBmaWxlcyBjaGFuZ2VkLCA3IGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbGliL3ZzcHJpbnRmLmMgYi9s
aWIvdnNwcmludGYuYwppbmRleCBiYzBhYzZiMzMzZGMuLmRhYmMzMTA2ODRiZiAxMDA2NDQKLS0t
IGEvbGliL3ZzcHJpbnRmLmMKKysrIGIvbGliL3ZzcHJpbnRmLmMKQEAgLTQwMCw4ICs0MDAsMTQg
QEAgY2hhciAqc3RyaW5nKGNoYXIgKmJ1ZiwgY2hhciAqZW5kLCBjb25zdCBjaGFyICpzLCBzdHJ1
Y3QgcHJpbnRmX3NwZWMgc3BlYykKIHsKIAlpbnQgbGVuLCBpOwogCi0JaWYgKCh1bnNpZ25lZCBs
b25nKXMgPCBQQUdFX1NJWkUpCisJaWYgKCh1bnNpZ25lZCBsb25nKXMgPCBQQUdFX1NJWkUpIHsK
KwkJaWYgKHMpIHsKKwkJCXNwZWMuYmFzZSA9IDE2OworCQkJc3BlYy5mbGFncyB8PSBTUEVDSUFM
OworCQkJcmV0dXJuIG51bWJlcihidWYsIGVuZCwgKHVuc2lnbmVkIGxvbmcpcywgc3BlYyk7CisJ
CX0KIAkJcyA9ICIobnVsbCkiOworCX0KIAogCWxlbiA9IHN0cm5sZW4ocywgc3BlYy5wcmVjaXNp
b24pOwogCg==
--0022154012faddd82104a0a82ecb--
