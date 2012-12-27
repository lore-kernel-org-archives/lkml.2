Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab2L0X4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:56:46 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:56536 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2L0X4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:56:44 -0500
MIME-Version: 1.0
In-Reply-To: <20121227182232.GA10054@x1.alien8.de>
References: <20121227182232.GA10054@x1.alien8.de>
Date: Thu, 27 Dec 2012 15:56:42 -0800
X-Google-Sender-Auth: wetPZ_82LJvJ1a6m5NqbhEK_b1Y
Message-ID: <CAE9FiQXpAB_AFtHF_NN7yr2iP2OOLgMir8MNvYUUc15k83_3zg@mail.gmail.com>
Subject: Re: [PATCH] x86, realmode: set real_mode permissions early
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 10:22 AM, Borislav Petkov <bp@alien8.de> wrote:
>> commit 77e277cb85290a183bbc1995a1cd839b1c216f25
>> Subject: [PATCH] x86, realmode: set real_mode permissions early
>> Author: Yinghai Lu <yinghai@kernel.org>
>> Date:   Mon Dec 24 18:00:21 2012 -0800
>>
>>     x86, realmode: set real_mode permissions early
>>
>>     We need to set trampoline code to EXEC early before we do smp
>>     AP bootings.
>>
>>     Found the problem after switching to #PF handler set page table,
>>     and we do not set initial kernel low mapping with EXEC anymore.
>>
>>     Change to use early_initcall instead that will make sure tramopline
>>     will have EXEC set.
>>
>>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
>> index 80450261215c..0b7e840ad4d4 100644
>> --- a/arch/x86/realmode/init.c
>> +++ b/arch/x86/realmode/init.c
>> @@ -111,5 +111,4 @@ static int __init set_real_mode_permissions(void)
>>
>>       return 0;
>>  }
>> -
>> -arch_initcall(set_real_mode_permissions);
>> +early_initcall(set_real_mode_permissions);
>
> I'm looking at this patch in the -v8 branch: you need to update the
> comment above that function to say that trampoline code needs to be
> marked X now earlier.

Not sure if we really need to add such comment in the code.

Peter, what is your idea about this?

Yinghai
