Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab1JPV5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 17:57:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35155 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1JPV53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 17:57:29 -0400
Message-ID: <0e9ef9174a0089187fde0b3d084672ad.squirrel@www.firstfloor.org>
In-Reply-To: <1318799006.2995.1.camel@dabdike.int.hansenpartnership.com>
References: <20111013233818.GB26654@one.firstfloor.org>
    <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
    <20111016033514.GC26654@one.firstfloor.org>
    <1318799006.2995.1.camel@dabdike.int.hansenpartnership.com>
Date: Sun, 16 Oct 2011 23:57:25 +0200
Subject: Re: Please include const-sections into linux-next
From: "Andi Kleen" <andi@firstfloor.org>
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Andi Kleen" <andi@firstfloor.org>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20111016235725_38372"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20111016235725_38372
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

vate email?
>
> OK, so after fixing up that one, the next failure is:
>
> drivers/net/fealnx.c:95: error: version causes a section type conflict
> drivers/net/fealnx.c:1944: error: fealnx_pci_tbl causes a section type
> conflict

Hmm, this is weird (just like the other error)
I wonder if the pa-risc tool chain has some general problems with sections

On a successful build with the same config could you send me the output of

make drivers/net/fealnx.s
and
make drivers/net/fealnx.i

in the same config privately? From that I can see if there's something else
in init.rodata that does not match my i386 build.

One alternative to track it down would be to apply the attached
patch to the gcc, then gcc would print it out.

-Andi

------=_20111016235725_38372
Content-Type: application/octet-stream; name="section-conflict"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="section-conflict"

Y29tbWl0IGI3NGQ5ZTdhNGE3NmFmZTRmZDc2OTg4MTUyNWY4OWY4OTMyNGJlOGMKQXV0aG9yOiBh
ayA8YWtAMTM4YmM3NWQtMGQwNC0wNDEwLTk2MWYtODJlZTcyYjA1NGE0PgpEYXRlOiAgIFRodSBK
dW4gOSAwNjoyMjoxNyAyMDExICswMDAwCgogICAgYmV0dGVyIHdhcm5pbmcgZm9yIHNlY3Rpb24g
Y29uZmxpY3QKICAgIAogICAgZ2NjLzoKICAgIAogICAgMjAxMS0wNi0wOCAgQW5kaSBLbGVlbiAg
PGFrQGxpbnV4LmludGVsLmNvbT4KICAgIAogICAgCSogdmFyYXNtLmMgKGdldF9zZWN0aW9uKTog
UHJpbnQgbG9jYXRpb24gb2Ygb3RoZXIgY29uZmxpY3QKICAgIAlmb3Igc2VjdGlvbiBjb25mbGlj
dHMuCiAgICAKICAgIGdpdC1zdm4taWQ6IHN2bitzc2g6Ly9nY2MuZ251Lm9yZy9zdm4vZ2NjL3Ry
dW5rQDE3NDgzNiAxMzhiYzc1ZC0wZDA0LTA0MTAtOTYxZi04MmVlNzJiMDU0YTQKCmRpZmYgLS1n
aXQgYS9nY2MvQ2hhbmdlTG9nIGIvZ2NjL0NoYW5nZUxvZwppbmRleCA4MjBiY2JkLi4xYzlmYTAy
IDEwMDY0NAotLS0gYS9nY2MvQ2hhbmdlTG9nCisrKyBiL2djYy9DaGFuZ2VMb2cKQEAgLTEsNSAr
MSwxMCBAQAogMjAxMS0wNi0wOCAgQW5kaSBLbGVlbiAgPGFrQGxpbnV4LmludGVsLmNvbT4KIAor
CSogdmFyYXNtLmMgKGdldF9zZWN0aW9uKTogUHJpbnQgbG9jYXRpb24gb2Ygb3RoZXIgY29uZmxp
Y3QKKwlmb3Igc2VjdGlvbiBjb25mbGljdHMuCisKKzIwMTEtMDYtMDggIEFuZGkgS2xlZW4gIDxh
a0BsaW51eC5pbnRlbC5jb20+CisKIAkqIGNvbmZpZy9pMzg2L2RyaXZlci1pMzg2LmMgKGhvc3Rf
ZGV0ZWN0X2xvY2FsX2NwdSk6CiAJQWRkIG1vZGVsIDB4MmQgSW50ZWwgQ1BVLgogCmRpZmYgLS1n
aXQgYS9nY2MvdmFyYXNtLmMgYi9nY2MvdmFyYXNtLmMKaW5kZXggMzMxMWM4Ni4uYTBhMDU4MiAx
MDA2NDQKLS0tIGEvZ2NjL3ZhcmFzbS5jCisrKyBiL2djYy92YXJhc20uYwpAQCAtMzEzLDcgKzMx
MywxMSBAQCBnZXRfc2VjdGlvbiAoY29uc3QgY2hhciAqbmFtZSwgdW5zaWduZWQgaW50IGZsYWdz
LCB0cmVlIGRlY2wpCiAJICBpZiAoZGVjbCA9PSAwKQogCSAgICBkZWNsID0gc2VjdC0+bmFtZWQu
ZGVjbDsKIAkgIGdjY19hc3NlcnQgKGRlY2wpOwotCSAgZXJyb3IgKCIlK0QgY2F1c2VzIGEgc2Vj
dGlvbiB0eXBlIGNvbmZsaWN0IiwgZGVjbCk7CisJICBlcnJvciAoIiUrRCBjYXVzZXMgYSBzZWN0
aW9uIHR5cGUgY29uZmxpY3Qgd2l0aCAlRCIsIAorCQkJZGVjbCwgc2VjdC0+bmFtZWQuZGVjbCk7
CisJICBpZiAoZGVjbCAhPSBzZWN0LT5uYW1lZC5kZWNsKQorICAgICAgICAgICAgaW5mb3JtIChE
RUNMX1NPVVJDRV9MT0NBVElPTiAoc2VjdC0+bmFtZWQuZGVjbCksIAorCQkgICAgIiVxRCB3YXMg
ZGVjbGFyZWQgaGVyZSIsIHNlY3QtPm5hbWVkLmRlY2wpOwogCSAgLyogTWFrZSBzdXJlIHdlIGRv
bid0IGVycm9yIGFib3V0IG9uZSBzZWN0aW9uIG11bHRpcGxlIHRpbWVzLiAgKi8KIAkgIHNlY3Qt
PmNvbW1vbi5mbGFncyB8PSBTRUNUSU9OX09WRVJSSURFOwogCX0K
------=_20111016235725_38372--

