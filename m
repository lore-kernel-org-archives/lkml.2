Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0K2JLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:11:46 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41317 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0K2JLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:11:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BMe990+KrxmIKXsuDvap5U+HdgyR6ULk9fau6kzTLzyg5jzaAoY7B08gxjkTvUAT/0
         0SVcePevriS8B84hUuMMFFMNEymU0U3S5bXeiE2jDmx84jtTgyBhDz1csBZdcjZKvOlI
         u0+B2oUVsdDKejClwp3odwuk+gJdIzN9J9C00=
MIME-Version: 1.0
In-Reply-To: <20101129085250.GF5218@cr0.nay.redhat.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
 <20101129081619.GD5218@cr0.nay.redhat.com> <AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com>
 <20101129085250.GF5218@cr0.nay.redhat.com>
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 29 Nov 2010 17:11:23 +0800
Message-ID: <AANLkTikK_ADMRR+8Po7m0VzzzVTm03+Twven0Y4Dx-uk@mail.gmail.com>
Subject: Re: [PATCH] Built kernel without -O2 option
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, gdb@sourceware.org, hellogcc@freelists.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 16:52, Américo Wang <xiyou.wangcong@gmail.com> wrote:
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
>
> I think it is not alone. :)
>
> Also, since many inline functions sit in hot-path, are there any
> performance regressions with your patch applied?
>

I did some nm, looks each file that have inline have a special code
for inline function.

> BTW, you need to Cc kbuild for makefile changes like this.
>

Thanks for you remind me.

Best,
Hui
