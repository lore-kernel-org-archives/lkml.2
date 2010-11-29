Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab0K2IsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:48:05 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42513 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0K2IsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:48:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=vK3dOtSHQb8z+y6gHHqRURSEm+/iOjyHcr/w5+JLYlvynPofx+SJpsOWLvoj6I8Tb2
         MiGGLgiKNuW98b6OHI+Cx3t4Wc4aFeUJ71291Ta272yW+B/pVtRtHosiOD8Op0lmwcjg
         Hg+ktM4jLf1pqqgMOFk4fhmvSQ3RHqAX3EdJM=
Date: Mon, 29 Nov 2010 16:52:50 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, gdb@sourceware.org,
        hellogcc@freelists.org
Subject: Re: [PATCH] Built kernel without -O2 option
Message-ID: <20101129085250.GF5218@cr0.nay.redhat.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
 <20101129081619.GD5218@cr0.nay.redhat.com>
 <AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 04:24:42PM +0800, Hui Zhu wrote:
>On Mon, Nov 29, 2010 at 16:16, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Mon, Nov 29, 2010 at 11:56:15AM +0800, Hui Zhu wrote:
>>>Hi,
>>>
>>>Now, there are a lot of ways to debug the Linux kernel with GDB, like
>>>qemu, kgtp or kgdb and so on.
>>>But the developer more like add a printk. It have a lot of reason, a big one is:
>>>(gdb) p ret
>>>$3 = <value optimized out>
>>>And the code execution order is not right.
>>>
>>>This is becuase the Kernel is bult with gcc -O2.  Gcc will not
>>>generate enough debug message with file with -O2.
>>>So GDB cannot work very well with Linux kernel.
>>>
>>>So I make a patch that add a option in "Kernel hacking" called "Close
>>>GCC optimization".  It will make kernel be built without -O2.
>>>
>>>I built and use it in i386 and x86_64.  I will try to make it OK in other arch.
>>>
>>
>> The problem is that some functions _have to_ be inlined and gcc without -O2
>> doesn't inline them. Have check all the cases? I doubt.
>
>If they really need O2, I set  them to O2.
>Actually, this is the main work, find out the file that need the O2.  :)
>
>For example:
>ifdef CONFIG_CC_CLOSE_OPTIMIZATION
>CFLAGS_fpu.o                           += -O2
>CFLAGS_aesni-intel_glue.o              += -O2
>CFLAGS_ghash-clmulni-intel_glue.o      += -O2
>endif

No, I didn't mean this, I meant some function that have to be inlined
are those who only work when being inlined, e.g. current_text_addr().

I think it is not alone. :)

Also, since many inline functions sit in hot-path, are there any
performance regressions with your patch applied?

BTW, you need to Cc kbuild for makefile changes like this.
