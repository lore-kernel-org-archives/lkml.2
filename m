Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0LAMSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 07:18:48 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43056 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab0LAMSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 07:18:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hZLOZrvN+xb2mf5nYamqI16BU/HCH444uERUYmBDIcSFwKY4B8HU65KfZ7b8GZatnM
         QPeqHEomz/PUqXruhEM2ieTCxDo3kTyf2ueSD5TLiBz+knWcR3rLBkFJvWTJuwGLcV9n
         7YECp0yVx5VXVCQ0cbXACdht0wf0vsBYKCBQw=
MIME-Version: 1.0
In-Reply-To: <4CF37603.5080301@de.ibm.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
 <20101129081619.GD5218@cr0.nay.redhat.com> <4CF37603.5080301@de.ibm.com>
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 1 Dec 2010 20:18:24 +0800
Message-ID: <AANLkTikq32EDVfP8SjNJSih2Z5jNafHGRPCDdc+w1GR6@mail.gmail.com>
Subject: Re: [PATCH] Built kernel without -O2 option
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, gdb@sourceware.org,
        hellogcc@freelists.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 17:44, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> Am 29.11.2010 09:16, schrieb Américo Wang:
>> On Mon, Nov 29, 2010 at 11:56:15AM +0800, Hui Zhu wrote:
>>> Hi,
>>>
>>> Now, there are a lot of ways to debug the Linux kernel with GDB, like
>>> qemu, kgtp or kgdb and so on.
>>> But the developer more like add a printk. It have a lot of reason, a big one is:
>>> (gdb) p ret
>>> $3 = <value optimized out>
>>> And the code execution order is not right.
>>>
>>> This is becuase the Kernel is bult with gcc -O2.  Gcc will not
>>> generate enough debug message with file with -O2.
>>> So GDB cannot work very well with Linux kernel.
>>>
>>> So I make a patch that add a option in "Kernel hacking" called "Close
>>> GCC optimization".  It will make kernel be built without -O2.
>>>
>>> I built and use it in i386 and x86_64.  I will try to make it OK in other arch.
>>>
>>
>> The problem is that some functions _have to_ be inlined and gcc without -O2
>> doesn't inline them. Have check all the cases? I doubt.
>
> In essence -O2 just tells gcc to activate a list of optimizations
> gcc  -Q -O2 --help=optimizers
> tells you what.
>
> So what about making this patch much smaller by explicitely using the optimizations
> that are absolutely necessary?
> e.g:
> -finline-small-functions -finline-functions-called-once
> (what else do we need?)
>
> We might even  be able to collapse this with the optimize for size option,
> by providing a Kconfig entry that allows to choose between
>
> -O0 -finline-small-functions -finline-functions-called-once
> -O1 -finline-small-functions -finline-functions-called-once
> -Os
> -O2
> -O3
>
> Christian
>

Hi Christian.

If we can build without any optimization options just set some file to O2.
I think keep it it will better than add some optimization options to
all files, right?

But make for this file that I add O2 to them, I can change them to to
some others options like "-O0 -finline-small-functions
-finline-functions-called-once".

Thanks,
Hui
