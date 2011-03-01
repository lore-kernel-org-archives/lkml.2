Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab1CAHnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 02:43:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49697 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab1CAHnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 02:43:00 -0500
Date: Tue, 1 Mar 2011 08:42:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] printk: Allocate kernel log buffer earlier
Message-ID: <20110301074239.GB12384@elte.hu>
References: <20110225180633.857892225@gulag1.americas.sgi.com>
 <20110225180634.017570095@gulag1.americas.sgi.com>
 <20110227120949.GF16453@elte.hu>
 <20110227121518.GA19165@elte.hu>
 <4D6AFBB0.70401@kernel.org>
 <4D6BF63D.2020404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6BF63D.2020404@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Yinghai Lu wrote:

> > please check updated patch...
> >
> > with the memblock change, you don't need to change acpi SRAT handling etc any 
> > more.
> 
> I had to debug a weird ACPI -> Node mapping last week and the
> "improved" SRAT messages helped that considerably.  It was
> far easier to spot which Node didn't have the correct assignments.
> I'd submit that patch even without needing fewer (like 512 lines
> max instead of 4096 lines max) bytes in the log buffer.

I agree that better compressed output generally makes sense - you just need to solve 
the ugliness aspect of it. (or get Len's Acked-by to add that code to drivers/acpi/)

Nevertheless doing this via memblock is obviously more important, as it solves the 
early printk log overrun problem once and for all.

> Let's move on to far more important problems.

That's not the threshold for upstream inclusion though. (at least for patches that 
we process via the -tip tree)

If you add crap to a single hardware driver then only that hardware is affected, but 
if you change the way the printk buffer is allocated it is *very important*, because 
like every single kernel message is affected by it.

So we scale up our review threshold with the importance of the piece of code 
affected.

Thanks,

	Ingo
