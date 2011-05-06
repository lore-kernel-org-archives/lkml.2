Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab1EFQyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:54:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60206 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab1EFQyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:54:03 -0400
Date: Fri, 6 May 2011 18:53:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>
Subject: Re: [RFC] time: xtime_lock is held too long
Message-ID: <20110506165359.GE11636@one.firstfloor.org>
References: <1304564090.2943.36.camel@work-vm> <1304574244.32152.666.camel@edumazet-laptop> <1304576495.2943.40.camel@work-vm> <1304604284.3032.78.camel@edumazet-laptop> <alpine.LFD.2.02.1105051630390.3005@ionos> <1304608095.3032.95.camel@edumazet-laptop> <alpine.LFD.2.02.1105051750540.3005@ionos> <20110505210118.GI2925@one.firstfloor.org> <alpine.LFD.2.02.1105061117220.3005@ionos> <20110506102232.GA11036@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506102232.GA11036@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Then precise measurements have to be done on the source of cache misses, the 
> total cost of the timer interrupt, etc.

What we did was profiling the remote node cache misses
using raw offcore events, and the xtime code was high up.
I cannot share exact numbers for various reasons, but it was
an improvement on a hard to improve workload.

> I.e. this should be analyzed and improved properly, not just sloppily slapping 
> a few prefetches here and there, which wont really *solve* anything ...

Well it made things faster. That's definitely something.

I agree the cache lines need to be consolidated in a proper way. 

But well placed prefetches by themselves can be a useful tool,
and placing them based on stable profile results is not "sloppy".

-Andi
