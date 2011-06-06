Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab1FFR54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:57:56 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:55299 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1FFR5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:57:54 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DED1519.2020803@die-jansens.de>
Date: Mon, 06 Jun 2011 19:57:45 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
References: <1307349530.2353.7374.camel@twins> <20110606145827.GD30348@elte.hu> <1307372989.2322.136.camel@twins> <1307375227.2322.161.camel@twins> <20110606155236.GA7374@elte.hu> <1307376039.2322.164.camel@twins> <20110606160810.GA16636@elte.hu> <1307376771.2322.168.camel@twins> <20110606161749.GA22157@elte.hu> <1307378649.2322.198.camel@twins> <20110606171153.GE2391@elte.hu>
In-Reply-To: <20110606171153.GE2391@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.06.2011 19:11, Ingo Molnar wrote:
>
> * Peter Zijlstra<peterz@infradead.org>  wrote:

>
>> +void printk_tick(void)
>> +{
>> +	if (!__this_cpu_read(printk_pending))
>> +		return;
>> +
>> +	/*
>> +	 * Try to acquire and then immediately release the
>> +	 * console semaphore. The release will do all the
>> +	 * actual magic (print out buffers, wake up klogd,
>> +	 * etc).
>> +	 */
>> +	if (console_trylock_for_printk(smp_processor_id())) {
>> +		console_unlock();
>> +		__this_cpu_write(printk_pending, 0);
>> +	}
>> +}
>
> Arne does this fix the hang you are seeing?

What do you want me to test? just replace printk_tick with the
above version? If I do that, the machine doesn't even boot up
any more.

