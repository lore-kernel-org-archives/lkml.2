Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab1EQJBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:01:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38427 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1EQJBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J/3SF5SUE9JqzGsu5tXffygxqSB1EatqfamQhYiooHdAWkeWlFy2aisGMfoN7TrYtm
         NMKj8ldUapWaxu7TSUNOXdZjsgirlXtc0vnIOS2J/AK+VeLpKD3//3QRw//CFFNrlH5f
         VoknSxFhFIaX1gsq9cTYNsQhfnDTXJyEK4rzY=
Subject: Re: [patch V3] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305609768.2375.84.camel@sli10-conroe>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	 <20110511092848.GE1661@htj.dyndns.org>
	 <1305168493.2373.15.camel@sli10-conroe>
	 <20110512082159.GB1030@htj.dyndns.org>
	 <1305190520.2373.18.camel@sli10-conroe>
	 <20110512085922.GD1030@htj.dyndns.org>
	 <1305190936.3795.1.camel@edumazet-laptop>
	 <20110512090534.GE1030@htj.dyndns.org>
	 <1305261477.2373.45.camel@sli10-conroe>
	 <1305264007.2831.14.camel@edumazet-laptop>
	 <20110513052859.GA11088@sli10-conroe.sh.intel.com>
	 <1305268456.2831.38.camel@edumazet-laptop>
	 <1305298300.3866.22.camel@edumazet-laptop>
	 <1305301151.3866.39.camel@edumazet-laptop>
	 <1305304532.3866.54.camel@edumazet-laptop>
	 <1305305190.3866.57.camel@edumazet-laptop>
	 <1305324187.3120.30.camel@edumazet-laptop>
	 <1305507517.2375.10.camel@sli10-conroe>
	 <1305526296.3120.204.camel@edumazet-laptop>
	 <1305527828.2375.28.camel@sli10-conroe>
	 <1305528912.3120.213.camel@edumazet-laptop>
	 <1305530143.2375.42.camel@sli10-conroe>
	 <1305531877.3120.230.camel@edumazet-laptop>
	 <1305534857.2375.55.camel@sli10-conroe>
	 <1305538504.2898.33.camel@edumazet-laptop>
	 <1305555736.2898.46.camel@edumazet-laptop>
	 <1305593751.2375.69.camel@sli10-conroe>
	 <1305608212.9466.45.camel@edumazet-laptop>
	 <1305609768.2375.84.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 11:01:01 +0200
Message-ID: <1305622861.2850.21.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 mai 2011 à 13:22 +0800, Shaohua Li a écrit :

> I don't know why you said there is no good reason. I posted a lot of
> data which shows improvement, while you just ignore.
> 

Dear Shaihua, ignoring you would mean I would not even answer, and let
other people do, when they have time (maybe in 2 or 3 months, maybe
never. Just take a look at my previous attempts, two years ago,
atomic64_t didnt exist at that time, obviously)

I hope you can see the value I add to your concerns, making this subject
alive and even coding stuff. We all share ideas, we are not fighting.



> The size issue is completely pointless. If you have 4096 CPUs, how could
> you worry about 16k bytes memory. Especially the extra memory makes the
> API much faster.
> 

It is not pointless at all, maybe for Intel guys it is.

I just NACK this idea

> > 2) Two separate alloc_percpu() -> two separate cache lines instead of
> > one.
> Might be in one cache line actually, but can be easily fixed if not
> anyway. On the other hand, even touch two cache lines, it's still faster
> than the original spinlock implementation, which I already posted data.
> 
> > But then, if one alloc_percpu() -> 32 kbytes per object.
> the size issue is completely pointless
> 

Thats your opinion

> > 3) Focus on percpu_counter() implementation instead of making an
> > analysis of callers.
> > 
> > I did a lot of rwlocks removal in network stack because they are not the
> > right synchronization primitive in many cases. I did not optimize
> > rwlocks. If rwlocks were even slower, I suspect other people would have
> > help me to convert things faster.
> My original issue is mmap, but I already declaimed several times we can
> make percpu_counter better, why won't we?
> 

Only if it's a good compromise. Your last patches are not yet good
candidates I'm afraid.

> > 4) There is a possible way to solve your deviation case : add at _add()
> > beginning a short cut for crazy 'amount' values. Its a bit expensive on
> > 32bit arches, so might be added in a new helper to let _add() be fast
> > for normal and gentle users.
> 
> +		if (unlikely(cmpxchg(ptr, old, 0) != old))
> > +			goto retry;
> this doesn't change anything, you still have the deviation issue here
> 

You do understand 'my last patch' doesnt address the deviation problem
anymore ? Its a completely different matter to address vm_committed_as
problem (and maybe other percpu_counters).

The thing you prefer to not touch so that your 'results' sound better...

If your percpu_counter is hit so hardly that you have many cpus
competing in atomic64(&count, &fbc->count), _sum() result is wrong right
after its return. so _sum() _can_ deviate even if it claims being more
precise.



> > +		atomic64_add(count, &fbc->count);
> 
> > if (unlikely(amount >= batch || amount <= -batch)) {
> > 	atomic64(amount, &fbc->count);
> > 	return;
> > }
> why we just handle this special case, my patch can make the whole part
> faster without deviation
> 

This 'special case' is the whole problem others pointed out, and this
makes deviation worst value like before your initial patch.


> so you didn't point out any obvious problem with my patch actually. This
> is good.
> 

This brings nothing. Just say NO to people saying its needed.

Its not because Tejun says there is a deviation "problem", you need to
change lglock and bring lglock to percpu_counter, or double
percpu_counter size, or whatever crazy idea.

Just convince him that percpu_counter by itself cannot bring a max
deviation guarantee. No percpu_counter user cares at all. If they do,
then percpu_counter choice for their implementation is probably wrong.

[ We dont provide yet a percpu_counter_add_return() function ]




