Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2KSWxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:53:39 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61632 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab2KSWxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:53:38 -0500
MIME-Version: 1.0
In-Reply-To: <50AAB5E8.5070807@zytor.com>
References: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
	<1353222571-31544-4-git-send-email-yinghai@kernel.org>
	<50AAB5E8.5070807@zytor.com>
Date: Mon, 19 Nov 2012 14:53:36 -0800
X-Google-Sender-Auth: RBDCCRx2L3BjmodmrkEF8hsnOng
Message-ID: <CAE9FiQV=G=5zAqv7EiUnb=O7znxuieiCawfgomv9aPNwVAV4uQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] x86: Add macro for 64bit entry startup_64
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 2:42 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/17/2012 11:09 PM, Yinghai Lu wrote:
>> We will add one 64bit entry for bzImage in boot header struct.
>>
>> the contents in that field will be offset of startup_64.
>>
>> Add macro for offset of startup_64 to keep two places consistent.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Matt Fleming <matt.fleming@intel.com>
>> ---
>>  arch/x86/boot/compressed/head_64.S |    2 +-
>>  arch/x86/include/asm/boot.h        |    2 ++
>>  2 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
>> index 375af23..e4964dd 100644
>> --- a/arch/x86/boot/compressed/head_64.S
>> +++ b/arch/x86/boot/compressed/head_64.S
>> @@ -195,7 +195,7 @@ no_longmode:
>>        * it may change in the future.
>>        */
>>       .code64
>> -     .org 0x200
>> +     .org BOOT_CODE64_START_OFFSET
>>  ENTRY(startup_64)
>>       /*
>>        * We come here either from startup_32 or directly from a
>> diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
>> index b13fe63..ef36497 100644
>> --- a/arch/x86/include/asm/boot.h
>> +++ b/arch/x86/include/asm/boot.h
>> @@ -38,8 +38,10 @@
>>
>>  #ifdef CONFIG_X86_64
>>  #define BOOT_STACK_SIZE      0x4000
>> +#define BOOT_CODE64_START_OFFSET 0x200
>>  #else
>>  #define BOOT_STACK_SIZE      0x1000
>> +#define BOOT_CODE64_START_OFFSET 0
>>  #endif
>>
>
> We can't change the 0x200 value, ever, because there are already things
> that use the 64-bit entry point.  As such, these macros and the bzImage
> fields are pointless; let's not bother and instead document the 0x200 as
> the permanently fixed address of the 64-bit entry point.

ok,

any other field, in header struct field that we can use to tell
bzImage could be used that
0x200 directly?

hardware_subarch?
