Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab3AJByD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:54:03 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:49082 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3AJByC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:54:02 -0500
MIME-Version: 1.0
In-Reply-To: <20130107155604.GE29449@x1.alien8.de>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-13-git-send-email-yinghai@kernel.org>
	<20130107155604.GE29449@x1.alien8.de>
Date: Wed, 9 Jan 2013 17:53:59 -0800
X-Google-Sender-Auth: -ED0WxCiWoHT4_TNYmTPCeHTkYk
Message-ID: <CAE9FiQXqgbMiqgfDOnJCsxP4anzgSHfW9aF2cSb3Ko_GoUQB-g@mail.gmail.com>
Subject: Re: [PATCH v7u1 12/31] x86: add get_ramdisk_image/size()
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 7:56 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jan 03, 2013 at 04:48:32PM -0800, Yinghai Lu wrote:
>> There are several places to find ramdisk information early for reserving
>> and relocating.
>>
>> Use functions to make code more readable and consistent.
>>
>> Later will add ext_ramdisk_image/size in those functions to support
>> loading ramdisk above 4g.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  arch/x86/kernel/setup.c |   29 +++++++++++++++++++++--------
>>  1 file changed, 21 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index 1b8a8cc..644a123 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -294,12 +294,25 @@ static void __init reserve_brk(void)
>>
>>  #ifdef CONFIG_BLK_DEV_INITRD
>>
>> +static u64 __init get_ramdisk_image(void)
>> +{
>> +     u64 ramdisk_image = boot_params.hdr.ramdisk_image;
>> +
>> +     return ramdisk_image;
>
> just do

No, I will insert line between them.
