Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab1FWLfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:35:10 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47981 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab1FWLfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fSoocZSPvXe2f1WQrOULZgSiJ4vTnQijTC67DgBtli3wUvy3B73mv1xI+CGaJ20dUz
         tbIsXcWej+bVYd0xnqeA3RUl5BiuIsMVjwNkBd310Yzl+MHzAsb1qEAkPrXykKKKCiKT
         QCvVlTdq5k4YNtEDKCqcfxNKZdmm7tOtqGvFw=
MIME-Version: 1.0
In-Reply-To: <20110623104455.GA9274@elte.hu>
References: <20110622174659.496793734@linutronix.de>
	<20110622174919.135236139@linutronix.de>
	<20110623083722.GF30101@htj.dyndns.org>
	<alpine.LFD.2.02.1106231139270.11814@ionos>
	<20110623101541.GL30101@htj.dyndns.org>
	<20110623104455.GA9274@elte.hu>
Date: Thu, 23 Jun 2011 13:35:07 +0200
X-Google-Sender-Auth: wbuvTr6P6vq2NAd01L20LxdBi4Q
Message-ID: <BANLkTi=SxzG_fonb008KQzbZk16tuxm7NA@mail.gmail.com>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On Thu, Jun 23, 2011 at 12:44 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Tejun Heo <tj@kernel.org> wrote:
>
>> The patch description is simply untrue.  It does affect how wq
>> behaves under heavy CPU load.  The effect might be perfectly okay
>> but more likely it will result in subtle suboptimal behaviors under
>> certain load situations which would be difficult to characterize
>> and track down.  Again, the trade off (mostly killing of
>> ttwu_local) could be okay but you can't get away with just claiming
>> "there's no harm".
>
> Well, either it can be measured or not. If you can suggest a specific
> testing method to Thomas, please do.

Crafting a test case where the suggested change results in worse
behavior isn't difficult (it ends up waking/creating workers which it
doesn't have to between ttwu and actual execution); however, as with
any micro benchmark, the problem is with assessing whether and how
much it would matter in actual workloads (whatever that means) and
workqueue is used throughout the kernel with widely varying patterns
making drawing conclusion a bit tricky.  Given that, changing the
behavior for the worse just for this cleanup doesn't sound like too
sweet a deal.  Is there any other reason to change the behavior
(latency, whatever) other than the ttuw_local ugliness?

Thanks.

-- 
tejun
