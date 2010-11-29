Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab0K2Uvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:51:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37885 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab0K2Uvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:51:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TUWi+cPyd653BnhUy0UboAu5TK/lynwuUOG8/NVQMsQyaFvCMl6//+zbt7Aco5Pgwe
         oZEtiCQ3N7XPvxYZAkJ799xbIASsuSLTdPdM+wGKyBUzgvR42oRsGarRTREcZsa+EDcD
         MZCQYe77duVhQLoNkmwu5iEIucVl5shlZqEWY=
MIME-Version: 1.0
In-Reply-To: <20101129085250.GF5218@cr0.nay.redhat.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
	<20101129081619.GD5218@cr0.nay.redhat.com>
	<AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com>
	<20101129085250.GF5218@cr0.nay.redhat.com>
Date: Mon, 29 Nov 2010 21:51:49 +0100
Message-ID: <AANLkTikmzhM-XpXrtOys3DbrG00brnXx0YVYSpHt-vrs@mail.gmail.com>
Subject: Re: [PATCH] Built kernel without -O2 option
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Hui Zhu <teawater@gmail.com>, linux-kernel@vger.kernel.org,
        gdb@sourceware.org, hellogcc@freelists.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 9:52 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Mon, Nov 29, 2010 at 04:24:42PM +0800, Hui Zhu wrote:
>>On Mon, Nov 29, 2010 at 16:16, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>> On Mon, Nov 29, 2010 at 11:56:15AM +0800, Hui Zhu wrote:
>>>>Hi,
>>>>
>>>>Now, there are a lot of ways to debug the Linux kernel with GDB, like
>>>>qemu, kgtp or kgdb and so on.
>>>>But the developer more like add a printk. It have a lot of reason, a big one is:
>>>>(gdb) p ret
>>>>$3 = <value optimized out>
>>>>And the code execution order is not right.
>>>>
>>>>This is becuase the Kernel is bult with gcc -O2.  Gcc will not
>>>>generate enough debug message with file with -O2.
>>>>So GDB cannot work very well with Linux kernel.
>>>>
>>>>So I make a patch that add a option in "Kernel hacking" called "Close
>>>>GCC optimization".  It will make kernel be built without -O2.
>>>>
>>>>I built and use it in i386 and x86_64.  I will try to make it OK in other arch.
>>>>
>>>
>>> The problem is that some functions _have to_ be inlined and gcc without -O2
>>> doesn't inline them. Have check all the cases? I doubt.
>>
>>If they really need O2, I set  them to O2.
>>Actually, this is the main work, find out the file that need the O2.  :)
>>
>>For example:
>>ifdef CONFIG_CC_CLOSE_OPTIMIZATION
>>CFLAGS_fpu.o                           += -O2
>>CFLAGS_aesni-intel_glue.o              += -O2
>>CFLAGS_ghash-clmulni-intel_glue.o      += -O2
>>endif
>
> No, I didn't mean this, I meant some function that have to be inlined
> are those who only work when being inlined, e.g. current_text_addr().

Can you please explain to me why some functions work only when they are inlined?
Is it because of asm() black magic?

> I think it is not alone. :)
>
> Also, since many inline functions sit in hot-path, are there any
> performance regressions with your patch applied?
>
> BTW, you need to Cc kbuild for makefile changes like this.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Thanks,
//richard
