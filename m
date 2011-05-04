Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab1EDWZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 18:25:20 -0400
Received: from mail.candelatech.com ([208.74.158.172]:33178 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab1EDWZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 18:25:18 -0400
Message-ID: <4DC1D1A5.7050408@candelatech.com>
Date: Wed, 04 May 2011 15:22:29 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slub: Fix the lockless code on 32-bit platforms with
 no 64-bit cmpxchg
References: <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504141413.GA14127@elte.hu> <20110504143616.GA19986@elte.hu> <4DC1CAB8.5080305@candelatech.com> <BANLkTim1L9Gz2kk_SjTe2g_SmKJV=FfuRQ@mail.gmail.com>
In-Reply-To: <BANLkTim1L9Gz2kk_SjTe2g_SmKJV=FfuRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 03:00 PM, Linus Torvalds wrote:
> On Wed, May 4, 2011 at 2:52 PM, Ben Greear<greearb@candelatech.com>  wrote:
>>
>> This patch appears to fix the crashes I was seeing on my 32-bit
>> Atom system.
>>
>> It would crash within 30 seconds of booting every time before this patch...
>
> Oh, well - I already committed it and pushed out, otherwise I'd have
> added that piece of information to the commit log.

No worries...I'm just happy to finally be able to boot .39 :)

> But it's good to know that others had seen this too, just never
> realized what was going on.
>
> Btw, that does seem to imply that your kernel config is somewhat odd.
> We _should_ be using cmpxchg8b natively if you compile for anything
> newer than PPro, and that includes atom.
>
> Did you perhaps say "compile for Pentium" (which is pretty close to
> Atom in some respects - but we don't trust that all Pentium-class
> CPU's have cmpxchg8b, even if the Intel ones all should).

Well, yes.  I'm compiling for 'M586' it seems, plus SMP, pre-empt, etc.

Maybe it's time to move to a newer processor family!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

