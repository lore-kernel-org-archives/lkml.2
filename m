Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab0HSKSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 06:18:53 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60186 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab0HSKSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 06:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EdVUzRw5OnSmVKYG2r307cUaCWfnKY/6/AAXs7+SgG57pjiKdvQhq3sFjcpGPC26U+
         47mp/h4W9PRkPrr0KVnhWV7nVRXHLyDkvdZuDxBbae9UOvSD6bp9CLgyPDjqQ1A0wI1I
         7OELGplFUPM7cs2TaYTlpcSYNFAx6FbyvPjsA=
MIME-Version: 1.0
In-Reply-To: <4c5ae57d.d37b0e0a.1ef9.19ba@mx.google.com>
References: <1278974997-27141-1-git-send-email-roel.vannyen@gmail.com>
	<4c5ae57d.d37b0e0a.1ef9.19ba@mx.google.com>
Date: Thu, 19 Aug 2010 12:18:50 +0200
Message-ID: <AANLkTimO1zyyXL6J=aOAQZMtQHPwU8u8NOWjLxgbsovw@mail.gmail.com>
Subject: Re: [PATCH] Staging: vt6656: Remove the ULONG_PTR and DWORD_PTR
 defines from ttype.h
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi greg,

Did you see my previous mail with this patch or did it get lost in the noise ?

Thanks,
Roel

2010/8/5 Roel Van Nyen <roel.vannyen@gmail.com>:
> On Tue, Jul 13, 2010 at 12:49:57AM +0200, Roel Van Nyen wrote:
>> Remove the ULONG and DWORD PTR defines from ttype.h
>>
>> Signed-of-by: Roel Van Nyen <roel.vannyen@gmail.com>
>> ---
>>  drivers/staging/vt6656/bssdb.c |    8 ++++----
>>  drivers/staging/vt6656/ttype.h |    3 ---
>>  2 files changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
>> index 830dd23..0b8584b 100644
>> --- a/drivers/staging/vt6656/bssdb.c
>> +++ b/drivers/staging/vt6656/bssdb.c
>> @@ -469,7 +469,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
>>       unsigned int uLen = pRSNWPA->len + 2;
>>
>>       if (uLen <= (uIELength -
>> -                  (unsigned int) (ULONG_PTR) ((PBYTE) pRSNWPA - pbyIEs))) {
>> +                  (unsigned int) (unsigned long) ((PBYTE) pRSNWPA - pbyIEs))) {
>>               pBSSList->wWPALen = uLen;
>>               memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
>>               WPA_ParseRSN(pBSSList, pRSNWPA);
>> @@ -482,7 +482,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
>>       unsigned int uLen = pRSN->len + 2;
>>
>>       if (uLen <= (uIELength -
>> -                  (unsigned int) (ULONG_PTR) ((PBYTE) pRSN - pbyIEs))) {
>> +                  (unsigned int) (unsigned long) ((PBYTE) pRSN - pbyIEs))) {
>>               pBSSList->wRSNLen = uLen;
>>               memcpy(pBSSList->byRSNIE, pRSN, uLen);
>>               WPA2vParseRSN(pBSSList, pRSN);
>> @@ -674,7 +674,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
>>     if (pRSNWPA != NULL) {
>>       unsigned int uLen = pRSNWPA->len + 2;
>>       if (uLen <= (uIELength -
>> -                  (unsigned int) (ULONG_PTR) ((PBYTE) pRSNWPA - pbyIEs))) {
>> +                  (unsigned int) (unsigned long) ((PBYTE) pRSNWPA - pbyIEs))) {
>>               pBSSList->wWPALen = uLen;
>>               memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
>>               WPA_ParseRSN(pBSSList, pRSNWPA);
>> @@ -686,7 +686,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
>>      if (pRSN != NULL) {
>>       unsigned int uLen = pRSN->len + 2;
>>       if (uLen <= (uIELength -
>> -                     (unsigned int) (ULONG_PTR) ((PBYTE) pRSN - pbyIEs))) {
>> +                     (unsigned int) (unsigned long) ((PBYTE) pRSN - pbyIEs))) {
>>               pBSSList->wRSNLen = uLen;
>>               memcpy(pBSSList->byRSNIE, pRSN, uLen);
>>               WPA2vParseRSN(pBSSList, pRSN);
>> diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
>> index 3425773..42091c4 100644
>> --- a/drivers/staging/vt6656/ttype.h
>> +++ b/drivers/staging/vt6656/ttype.h
>> @@ -83,9 +83,6 @@ typedef UQuadWord       QWORD;          // 64-bit
>>
>>  /****** Common pointer types ***********************************************/
>>
>> -typedef unsigned long   ULONG_PTR;      // 32-bit
>> -typedef unsigned long   DWORD_PTR;      // 32-bit
>> -
>>  // boolean pointer
>>  typedef unsigned int *   PUINT;
>>
>> --
>> 1.7.0.4
>>
>
> Hi Greg,
>
> I have re-done my patch and this time without any checkpatch.pl errors.
>
> Remove DWORD_PTR and ULONG_PTR from ttype.h
>
> Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>
> ---
>  drivers/staging/vt6656/bssdb.c |    8 ++++----
>  drivers/staging/vt6656/ttype.h |    4 ----
>  2 files changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
> index a9f68bd..024dff3 100644
> --- a/drivers/staging/vt6656/bssdb.c
> +++ b/drivers/staging/vt6656/bssdb.c
> @@ -466,7 +466,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
>        unsigned int uLen = pRSNWPA->len + 2;
>
>        if (uLen <= (uIELength -
> -                    (unsigned int) (ULONG_PTR) ((PBYTE) pRSNWPA - pbyIEs))) {
> +       (unsigned int) (unsigned long) ((PBYTE) pRSNWPA - pbyIEs))) {
>                pBSSList->wWPALen = uLen;
>                memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
>                WPA_ParseRSN(pBSSList, pRSNWPA);
> @@ -479,7 +479,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
>        unsigned int uLen = pRSN->len + 2;
>
>        if (uLen <= (uIELength -
> -                    (unsigned int) (ULONG_PTR) ((PBYTE) pRSN - pbyIEs))) {
> +       (unsigned int) (unsigned long) ((PBYTE) pRSN - pbyIEs))) {
>                pBSSList->wRSNLen = uLen;
>                memcpy(pBSSList->byRSNIE, pRSN, uLen);
>                WPA2vParseRSN(pBSSList, pRSN);
> @@ -671,7 +671,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
>    if (pRSNWPA != NULL) {
>        unsigned int uLen = pRSNWPA->len + 2;
>        if (uLen <= (uIELength -
> -                    (unsigned int) (ULONG_PTR) ((PBYTE) pRSNWPA - pbyIEs))) {
> +       (unsigned int) (unsigned long) ((PBYTE) pRSNWPA - pbyIEs))) {
>                pBSSList->wWPALen = uLen;
>                memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
>                WPA_ParseRSN(pBSSList, pRSNWPA);
> @@ -683,7 +683,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
>     if (pRSN != NULL) {
>        unsigned int uLen = pRSN->len + 2;
>        if (uLen <= (uIELength -
> -                       (unsigned int) (ULONG_PTR) ((PBYTE) pRSN - pbyIEs))) {
> +       (unsigned int) (unsigned long) ((PBYTE) pRSN - pbyIEs))) {
>                pBSSList->wRSNLen = uLen;
>                memcpy(pBSSList->byRSNIE, pRSN, uLen);
>                WPA2vParseRSN(pBSSList, pRSN);
> diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
> index 8e9450e..e8ed3ff 100644
> --- a/drivers/staging/vt6656/ttype.h
> +++ b/drivers/staging/vt6656/ttype.h
> @@ -59,10 +59,6 @@ typedef union tagUQuadWord {
>  typedef UQuadWord       QWORD;          // 64-bit
>
>  /****** Common pointer types ***********************************************/
> -
> -typedef unsigned long   ULONG_PTR;      // 32-bit
> -typedef unsigned long   DWORD_PTR;      // 32-bit
> -
>  // boolean pointer
>
>  typedef BYTE *           PBYTE;
> --
> 1.7.0.4
>
>
