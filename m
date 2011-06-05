Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1FEL6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 07:58:00 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:49819 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab1FEL57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 07:57:59 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DEB6F3A.3000109@die-jansens.de>
Date: Sun, 05 Jun 2011 13:57:46 +0200
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
References: <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com> <1307092535.2353.2973.camel@twins> <4DE8B13D.9020302@die-jansens.de> <1307097052.2353.3061.camel@twins> <20110605081747.GA17920@elte.hu> <4DEB4FA7.3050400@die-jansens.de> <20110605095555.GA22058@elte.hu> <4DEB58D8.4000805@die-jansens.de> <20110605110132.GB23463@elte.hu> <20110605111933.GA24592@elte.hu> <20110605113627.GA25724@elte.hu>
In-Reply-To: <20110605113627.GA25724@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2011 13:36, Ingo Molnar wrote:
>
> * Ingo Molnar<mingo@elte.hu>  wrote:
>
>>> If the ticks stop this suggests a lockup within the printk code.
>>> [...]
>>
>> In which case the printk-killswitch patch below (to be applied
>> *instead* of the previous debugging patch i sent) should provide
>> the desired NMI watchdog output on the serial console.
>>
>> Warning: it's entirely untested.

How is the output supposed to come through? shouldn't printk revert
to early_printk instead of just returning?


>
> Note, since this is an SMP box, if the lockup messages show up with
> this patch but are mixed up with each other then adding a spinlock
> around the WARN() would probably help keeping the output serialized.
>
> A simple:
>
>   static DEFINE_SPINLOCK(watchdog_output_lock);
>
>   ...
> 	spin_lock(&watchdog_output_lock);
>   ...
> 	[ the WARN_ON() logic. ]
>   ...
> 	spin_unlock(&watchdog_output_lock);
>   ...
>
> would suffice.
>
> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

