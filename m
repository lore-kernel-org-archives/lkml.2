Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1FFHec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:34:32 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:40562 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab1FFHe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:34:29 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/f7yb6+x1CF1B3oIP27v4=
X-RZG-CLASS-ID: mo00
Message-ID: <4DEC82FA.2060603@die-jansens.de>
Date: Mon, 06 Jun 2011 09:34:18 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
References: <4DEB58D8.4000805@die-jansens.de> <20110605110132.GB23463@elte.hu> <20110605111933.GA24592@elte.hu> <20110605113627.GA25724@elte.hu> <4DEB6F3A.3000109@die-jansens.de> <20110605133958.GA27812@elte.hu> <4DEB8A93.30601@die-jansens.de> <20110605141003.GB29338@elte.hu> <4DEB933C.1070900@die-jansens.de> <20110605151323.GA30590@elte.hu> <20110605152641.GA31124@elte.hu>
In-Reply-To: <20110605152641.GA31124@elte.hu>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2011 17:26, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>>
>> * Arne Jansen <lists@die-jansens.de> wrote:
>>
>>> sched.c:934: in function __task_rq_lock
>>>         lockdep_assert_held(&p->pi_lock);
>>
>> Oh. Could you remove that line with the patch below - does it result 
>> in a working system?
>>
>> Now, this patch alone just removes a debugging check - but i'm not 
>> sure the debugging check is correct - we take the pi_lock in a raw 
>> way - which means it's not lockdep covered.
>>
>> So how can lockdep_assert_held() be called on it?
> 
> Ok, i'm wrong there - it's lockdep covered.
> 
> I also reviewed all the __task_rq_lock() call sites and each of them 
> has the pi_lock acquired. So unless both Peter and me are blind, the 
> other option would be some sort of memory corruption corrupting the 
> runqueue.

Another small idea, can we install the assert into a pre-0122ec5b02f766c
to see if it's an older problem that just got uncovered by the assert?

-Arne

> 
> But ... that looks so unlikely here, it's clearly heavy printk() and 
> console_sem twiddling that triggers the bug, not any other scheduler 
> activity.
> 
> Thanks,
> 
> 	Ingo

