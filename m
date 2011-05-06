Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab1EFRRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:17:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49027 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab1EFRRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:17:03 -0400
Date: Fri, 6 May 2011 19:17:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] time: xtime_lock is held too long
Message-ID: <20110506171701.GJ11636@one.firstfloor.org>
References: <1304574244.32152.666.camel@edumazet-laptop> <1304576495.2943.40.camel@work-vm> <1304604284.3032.78.camel@edumazet-laptop> <alpine.LFD.2.02.1105051630390.3005@ionos> <1304608095.3032.95.camel@edumazet-laptop> <alpine.LFD.2.02.1105051750540.3005@ionos> <20110505210118.GI2925@one.firstfloor.org> <alpine.LFD.2.02.1105061117220.3005@ionos> <20110506165913.GF11636@one.firstfloor.org> <1304701778.3066.165.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304701778.3066.165.camel@edumazet-laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unless I am very mistaken, it cannot explain my original report of up to
> 24.000 instructions waiting in ktime_get()

Yes it's a different problem. Sorry for hijacking your thread.

> 
> BTW, how many consecutive prefetch() a cpu can 'store/execute' before
> throwing away hints ?

It depends on the CPU. Older ones had a small number only. On the 
newer ones it tends to be limited by the various queues to memory,
which are a shared resource (so it also depends on what the other
threads/cores are doing)

I normally assume as a rule of thumb < 50

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
