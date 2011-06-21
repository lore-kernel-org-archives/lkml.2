Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab1FUGLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 02:11:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37834 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1FUGLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 02:11:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=oyFWZA1ItQlBVwn4ndjg550ngFCkynVZ1iYjvvHZsq+dUdpGrWk/+KzEsrap9I4HLr
         hsITIXNTYRnYwUghMLsP+sH1PFEwlVzXb/cARKyNJic9Q99dIEgHPcLT94FohQtlTzN3
         55/vZWaw07xRMyriGeD9PKetG6QA0spe/73QQ=
MIME-Version: 1.0
In-Reply-To: <201106201500.58617.arnd@arndb.de>
References: <BANLkTi=ETn+LXtd20qkfcgrUngjqwVrVPg@mail.gmail.com>
	<201106201500.58617.arnd@arndb.de>
Date: Tue, 21 Jun 2011 15:11:47 +0900
Message-ID: <BANLkTimhGiXaru3a1_rgUeDL9RZ4vqHjpQ@mail.gmail.com>
Subject: Re: 'hweight_long' include/linux/bitops.h compile warning problem.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd.

I attached patch for this warning issue.

If there is a problem of patch, plz reply ....

Thanks.


--------------------------------------------------------------------------------------------------------------------------------------

>From 28589ea9aabb080020ab3c79adcecad5d7315f39 Mon Sep 17 00:00:00 2001
From: Namjae Jeon <linkinjeon@gmail.com>
Date: Tue, 21 Jun 2011 14:39:03 +0900
Subject: [PATCH] compilation warning is caused when using hweight_long
with -Wsign-compare option.
 Warning message is '
 include/linux/bitops.h: In function 'hweight_long':
 include/linux/bitops.h:49: warning: signed and unsigned type in
conditional expression
 The reason is that the default return value of this macro is signed.
So, need type casting to remove warning.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 include/asm-generic/bitops/const_hweight.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/bitops/const_hweight.h
b/include/asm-generic/bitops/const_hweight.h
index fa2a50b..d91b1aa 100644
--- a/include/asm-generic/bitops/const_hweight.h
+++ b/include/asm-generic/bitops/const_hweight.h
@@ -4,7 +4,7 @@
 /*
  * Compile time versions of __arch_hweightN()
  */
-#define __const_hweight8(w)            \
+#define __const_hweight8(w) (unsigned long)    \
       (        (!!((w) & (1ULL << 0))) +       \
        (!!((w) & (1ULL << 1))) +       \
        (!!((w) & (1ULL << 2))) +       \
--
1.7.4-rc2



--------------------------------------------------------------------------------------------------------------------------------------
2011/6/20 Arnd Bergmann <arnd@arndb.de>:
> On Monday 20 June 2011, NamJae Jeon wrote:
>> I found compile warning while compiling module when using -Wsign-compare option.
>>
>> include/linux/bitops.h: In function 'hweight_long':
>> include/linux/bitops.h:49: warning: signed and unsigned type in
>> conditional expression
>>
>> I found the reason of this problem that the default return value of
>> the below macro is signed.
>>
>> #define __const_hweight8(w)        \
>>       ( (!!((w) & (1ULL << 0))) +       \
>>         (!!((w) & (1ULL << 1))) +       \
>>         (!!((w) & (1ULL << 2))) +       \
>>         (!!((w) & (1ULL << 3))) +       \
>>         (!!((w) & (1ULL << 4))) +       \
>>         (!!((w) & (1ULL << 5))) +       \
>>         (!!((w) & (1ULL << 6))) +       \
>>         (!!((w) & (1ULL << 7))) )
>>
>> So, I try to add (unsigned long) in __const_hweight8 like this.
>>
>> #define __const_hweight8(w)     (unsigned long )        \
>>       ( (!!((w) & (1ULL << 0))) +       \
>>         (!!((w) & (1ULL << 1))) +       \
>>         (!!((w) & (1ULL << 2))) +       \
>>         (!!((w) & (1ULL << 3))) +       \
>>         (!!((w) & (1ULL << 4))) +       \
>>         (!!((w) & (1ULL << 5))) +       \
>>         (!!((w) & (1ULL << 6))) +       \
>>         (!!((w) & (1ULL << 7))) )
>>
>> so, I can't see compile warning after fixing it, Would you plz check this ?
>
> Yes, this looks correct to me. Could you send the change as a proper patch
> with your Signed-off-by:?
>
>        Arnd
>
