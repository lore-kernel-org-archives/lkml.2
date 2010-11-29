Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab0K2Jok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:44:40 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:57164 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0K2Joi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:44:38 -0500
Message-ID: <4CF37603.5080301@de.ibm.com>
Date: Mon, 29 Nov 2010 10:44:35 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100918 Lightning/1.0b2 Icedove/3.1.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: Hui Zhu <teawater@gmail.com>, linux-kernel@vger.kernel.org,
        gdb@sourceware.org, hellogcc@freelists.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Built kernel without -O2 option
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com> <20101129081619.GD5218@cr0.nay.redhat.com>
In-Reply-To: <20101129081619.GD5218@cr0.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.11.2010 09:16, schrieb Américo Wang:
> On Mon, Nov 29, 2010 at 11:56:15AM +0800, Hui Zhu wrote:
>> Hi,
>>
>> Now, there are a lot of ways to debug the Linux kernel with GDB, like
>> qemu, kgtp or kgdb and so on.
>> But the developer more like add a printk. It have a lot of reason, a big one is:
>> (gdb) p ret
>> $3 = <value optimized out>
>> And the code execution order is not right.
>>
>> This is becuase the Kernel is bult with gcc -O2.  Gcc will not
>> generate enough debug message with file with -O2.
>> So GDB cannot work very well with Linux kernel.
>>
>> So I make a patch that add a option in "Kernel hacking" called "Close
>> GCC optimization".  It will make kernel be built without -O2.
>>
>> I built and use it in i386 and x86_64.  I will try to make it OK in other arch.
>>
> 
> The problem is that some functions _have to_ be inlined and gcc without -O2
> doesn't inline them. Have check all the cases? I doubt.

In essence -O2 just tells gcc to activate a list of optimizations
gcc  -Q -O2 --help=optimizers
tells you what.

So what about making this patch much smaller by explicitely using the optimizations
that are absolutely necessary?
e.g: 
-finline-small-functions -finline-functions-called-once
(what else do we need?)

We might even  be able to collapse this with the optimize for size option,
by providing a Kconfig entry that allows to choose between

-O0 -finline-small-functions -finline-functions-called-once
-O1 -finline-small-functions -finline-functions-called-once
-Os
-O2
-O3

Christian
