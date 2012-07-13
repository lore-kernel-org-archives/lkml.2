Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab2GMJK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 05:10:56 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39527 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2GMJKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 05:10:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAFNq8R6dNb0BrDVZScJ8s=P3B-OMgtr8tUdy8XqQcCAeUWuH+A@mail.gmail.com>
References: <CAK2TD5ygowdy9t1TpfxAPbpvNQfMnMB-3Zp8TKMsTYtBZdGW=Q@mail.gmail.com>
	<CAFNq8R6dNb0BrDVZScJ8s=P3B-OMgtr8tUdy8XqQcCAeUWuH+A@mail.gmail.com>
Date: Fri, 13 Jul 2012 17:10:52 +0800
Message-ID: <CAK2TD5z2DticZAQ-Pxzo7YT9tx=YWZkwcn-YZJ3aQa4AFoE_Cw@mail.gmail.com>
Subject: Re: ARM: why smp_mb() is not needed in the "__mutex_fastpath_lock"
 and "__mutex_fastpath_unlock" functions
From: shan kang <kangshan0910@gmail.com>
To: Li Haifeng <omycle@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For example, in the following scenario, Process2  may get the wrong value;
Process1:
mutex_lock(&lock);
write data; (store operation)
mutex_unlock(&lock);

Process2:
mutex_lock(&lock);
read data; (load operation)
mutex_unlock(&lock);

Suppose Process1 gets the lock first, write data and unlock. If the
store operation completes very slowly, the load operation of the
Process2 will fail to get the new value.
Since there are no dmb instructions in the mutex_lock and
mutex_unlock, which doesn't make sure that after Process2 gets the
lock, the result of the Process1's store operation will be seen by the
Process2.



2012/7/13 Li Haifeng <omycle@gmail.com>:
> Hi Shan,
>
> 2012/7/12 shan kang <kangshan0910@gmail.com>:
>> Hello,
>>    I wonder why smp_mb() is not needed in the "__mutex_fastpath_lock"
>> and "__mutex_fastpath_unlock" functions which are located in the
>> "arch/arm/include/asm/mutex.h"?
>>    I think "dmb" instruction is necessary there.
>
> Why necessary? Could you explain more detailed?
>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
