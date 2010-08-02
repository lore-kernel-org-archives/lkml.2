Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab0HBSAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:00:15 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38239 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab0HBSAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:00:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VNFVT1Is1oCYLs7UI8dhsbawx1un5Fc3pFfJDxqywnMwOGF+2aXGfmXOa7GaT+Y9i+
         9ubmriu3pX8+SKp8c2NMYid80bMjoN9Up9+Q+VPvwKo5hxvyEXHScd/aA31JA2Pm3orM
         TH203ZYKeajSLhUzcd7QrbznGt76WcBIaF68Y=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=r-vt=Pr+xchiR+s12RDU9xQbXnmCB4pTJcc2_@mail.gmail.com>
References: <4C56701B.1030000@kernel.org>
	<AANLkTi=r-vt=Pr+xchiR+s12RDU9xQbXnmCB4pTJcc2_@mail.gmail.com>
Date: Mon, 2 Aug 2010 15:00:12 -0300
Message-ID: <AANLkTim395uq5kwPxwY111sXRGgmZ=w6jAfkeHwVDtRC@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86, setup: reorgize the early_console_setup
From: Thiago Farina <tfransosi@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 2:56 PM, Thiago Farina <tfransosi@gmail.com> wrote:
> On Mon, Aug 2, 2010 at 4:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Index: linux-2.6/arch/x86/boot/string.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/boot/string.c
>> +++ linux-2.6/arch/x86/boot/string.c
>> @@ -12,7 +12,21 @@
>>  * Very basic string functions
>>  */
>>
>> -#include "boot.h"
>> +static inline int isdigit(int ch)
>> +{
>> +       return (ch >= '0') && (ch <= '9');
>> +}
>> +
>> +static inline int isxdigit(int ch)
>> +{
>> +       if (isdigit(ch))
>> +               return true;
>> +
>> +       if ((ch >= 'a') && (ch <= 'f'))
>> +               return true;
>> +
>> +       return (ch >= 'A') && (ch <= 'F');
>> +}
>>
>
> These to functions above can be fairly simplified by writting as:
>
> static bool inline is_hex_digit(int c) {
>  return (c >= '0' && c <= '9') ||
>            (c >= 'A' && c <= 'F') ||
>            (c >= 'a' && c <= 'f');
> }
>

Wow, sorry, this should be:

static inline bool is_hex_digit(int c) { ... }
