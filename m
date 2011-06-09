Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1FIOFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:05:14 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65327 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1FIOFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gJXwG03JcBKDGXTqZVz8F0EwE4BYNKMUTcA090bHMxsoQvbdUcDvpofK01UXjUqXgp
         oGDY/oDEBEKRGssFbFBvYyAdY7sDgjTsT3LDy9u/vCZYK61MUuBc01J1jR/gjXXIb66L
         UxFHQuoTUXl3ejo0kmGRC3xuQVz5ab1xRW7ZU=
MIME-Version: 1.0
In-Reply-To: <BANLkTikNC8uh-X_0iJZH3tYd_kf46W1Rwg@mail.gmail.com>
References: <1307617752-23426-1-git-send-email-gxt@mprc.pku.edu.cn>
	<BANLkTikNC8uh-X_0iJZH3tYd_kf46W1Rwg@mail.gmail.com>
Date: Thu, 9 Jun 2011 23:05:10 +0900
Message-ID: <BANLkTimWYjzxhQBH2A76D590KBfjKbguTA@mail.gmail.com>
Subject: Re: [PATCH] unicore32: fix build error for find bitops
From: Akinobu Mita <akinobu.mita@gmail.com>
To: GuanXuetao <gxt@mprc.pku.edu.cn>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        greg@kroah.com
Content-Type: multipart/mixed; boundary=bcaec5486102f6d4a404a547f088
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec5486102f6d4a404a547f088
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2011/6/9 Akinobu Mita <akinobu.mita@gmail.com>:
> 2011/6/9 GuanXuetao <gxt@mprc.pku.edu.cn>:
>> From: Guan Xuetao <gxt@mprc.pku.edu.cn>
>>
>> Remove the __uc32_ prefix in find bitops functions.
>> see commit <19de85ef574c3a2182e3ccad9581805052f14946>
>> =A0bitops: add #ifndef for each of find bitops
>>
>> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
>> Cc: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>> =A0arch/unicore32/include/asm/bitops.h | =A0 =A06 ------
>> =A0arch/unicore32/kernel/ksyms.c =A0 =A0 =A0 | =A0 =A04 ++--
>> =A0arch/unicore32/lib/findbit.S =A0 =A0 =A0 =A0| =A0 14 ++++++++------
>> =A03 files changed, 10 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/unicore32/include/asm/bitops.h b/arch/unicore32/includ=
e/asm/bitops.h
>> index 1628a63..a9653f0 100644
>> --- a/arch/unicore32/include/asm/bitops.h
>> +++ b/arch/unicore32/include/asm/bitops.h
>> @@ -13,12 +13,6 @@
>> =A0#ifndef __UNICORE_BITOPS_H__
>> =A0#define __UNICORE_BITOPS_H__
>>
>> -#define find_next_bit =A0 =A0 =A0 =A0 =A0__uc32_find_next_bit
>> -#define find_next_zero_bit =A0 =A0 __uc32_find_next_zero_bit
>> -
>> -#define find_first_bit =A0 =A0 =A0 =A0 __uc32_find_first_bit
>> -#define find_first_zero_bit =A0 =A0__uc32_find_first_zero_bit
>> -
>
> Is this patch really fix the build error?
>
> If these find_*_bit macros are removed, vmlinux will have multiple
> definisions of find_*_bit. Because lib/find_next_bit.c is built
> unconditionally after the commit 63e424c84429903c92a0f1e9654c31ccaf6694d0
> ("arch: remove CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}".

The attached patch hopefully fix the build error but it is untested
because I can't find crosstool for unicore32. So could you apply
this patch on top of your patch and check whether it fixes?

--bcaec5486102f6d4a404a547f088
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-unicore32-fix-build-error-for-find-bitops.patch"
Content-Disposition: attachment; 
	filename="0001-unicore32-fix-build-error-for-find-bitops.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gops5jlc0

RnJvbSAxMzMzMzFlOTMxNDM4OGU3ODYxOWVkNzdjYzYyZjZhZDA0MjMzMjk5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBa2lub2J1IE1pdGEgPGFraW5vYnUubWl0YUBnbWFpbC5jb20+
CkRhdGU6IFRodSwgOSBKdW4gMjAxMSAyMjoyODozNyArMDkwMApTdWJqZWN0OiBbUEFUQ0hdIHVu
aWNvcmUzMjogZml4IGJ1aWxkIGVycm9yIGZvciBmaW5kIGJpdG9wcwoKU2lnbmVkLW9mZi1ieTog
QWtpbm9idSBNaXRhIDxha2lub2J1Lm1pdGFAZ21haWwuY29tPgotLS0KIGFyY2gvdW5pY29yZTMy
L2luY2x1ZGUvYXNtL2JpdG9wcy5oIHwgICAxNyArKysrKysrKysrKysrKysrKwogMSBmaWxlcyBj
aGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Fy
Y2gvdW5pY29yZTMyL2luY2x1ZGUvYXNtL2JpdG9wcy5oIGIvYXJjaC91bmljb3JlMzIvaW5jbHVk
ZS9hc20vYml0b3BzLmgKaW5kZXggYTk2NTNmMC4uZmI4YTI5YyAxMDA2NDQKLS0tIGEvYXJjaC91
bmljb3JlMzIvaW5jbHVkZS9hc20vYml0b3BzLmgKKysrIGIvYXJjaC91bmljb3JlMzIvaW5jbHVk
ZS9hc20vYml0b3BzLmgKQEAgLTE3LDYgKzE3LDcgQEAKICNkZWZpbmUgX0FTTV9HRU5FUklDX0JJ
VE9QU19fX0ZMU19IXwogI2RlZmluZSBfQVNNX0dFTkVSSUNfQklUT1BTX0ZGU19IXwogI2RlZmlu
ZSBfQVNNX0dFTkVSSUNfQklUT1BTX19fRkZTX0hfCisjZGVmaW5lIF9BU01fR0VORVJJQ19CSVRP
UFNfRklORF9IXwogLyoKICAqIE9uIFVOSUNPUkUsIHRob3NlIGZ1bmN0aW9ucyBjYW4gYmUgaW1w
bGVtZW50ZWQgYXJvdW5kCiAgKiB0aGUgY250bHogaW5zdHJ1Y3Rpb24gZm9yIG11Y2ggYmV0dGVy
IGNvZGUgZWZmaWNpZW5jeS4KQEAgLTM2LDYgKzM3LDIyIEBAIHN0YXRpYyBpbmxpbmUgaW50IGZs
cyhpbnQgeCkKICNkZWZpbmUgZmZzKHgpICh7IHVuc2lnbmVkIGxvbmcgX190ID0gKHgpOyBmbHMo
X190ICYgLV9fdCk7IH0pCiAjZGVmaW5lIF9fZmZzKHgpIChmZnMoeCkgLSAxKQogCitleHRlcm4g
dW5zaWduZWQgbG9uZyBmaW5kX25leHRfYml0KGNvbnN0IHVuc2lnbmVkIGxvbmcgKmFkZHIsIHVu
c2lnbmVkIGxvbmcKKwkJc2l6ZSwgdW5zaWduZWQgbG9uZyBvZmZzZXQpOworI2RlZmluZSBmaW5k
X25leHRfYml0IGZpbmRfbmV4dF9iaXQKKworZXh0ZXJuIHVuc2lnbmVkIGxvbmcgZmluZF9uZXh0
X3plcm9fYml0KGNvbnN0IHVuc2lnbmVkIGxvbmcgKmFkZHIsIHVuc2lnbmVkCisJCWxvbmcgc2l6
ZSwgdW5zaWduZWQgbG9uZyBvZmZzZXQpOworI2RlZmluZSBmaW5kX25leHRfemVyb19iaXQgZmlu
ZF9uZXh0X3plcm9fYml0CisKK2V4dGVybiB1bnNpZ25lZCBsb25nIGZpbmRfZmlyc3RfYml0KGNv
bnN0IHVuc2lnbmVkIGxvbmcgKmFkZHIsCisJCQkJICAgIHVuc2lnbmVkIGxvbmcgc2l6ZSk7Cisj
ZGVmaW5lIGZpbmRfZmlyc3RfYml0IGZpbmRfZmlyc3RfYml0CisKK2V4dGVybiB1bnNpZ25lZCBs
b25nIGZpbmRfZmlyc3RfemVyb19iaXQoY29uc3QgdW5zaWduZWQgbG9uZyAqYWRkciwKKwkJCQkJ
IHVuc2lnbmVkIGxvbmcgc2l6ZSk7CisjZGVmaW5lIGZpbmRfZmlyc3RfemVyb19iaXQgZmluZF9m
aXJzdF96ZXJvX2JpdAorCiAjaW5jbHVkZSA8YXNtLWdlbmVyaWMvYml0b3BzLmg+CiAKICNlbmRp
ZiAvKiBfX1VOSUNPUkVfQklUT1BTX0hfXyAqLwotLSAKMS43LjQuNAoK
--bcaec5486102f6d4a404a547f088--
