Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab1EZRFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:05:09 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:47607 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab1EZRFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:05:06 -0400
Subject: Re: Kernel crash after using new Intel NIC (igb)
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Arun Sharma <asharma@fb.com>, Maximilian Engelhardt <maxi@daemonizer.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        StuStaNet Vorstand <vorstand@stusta.mhn.de>
In-Reply-To: <1306305331.3305.22.camel@edumazet-laptop>
References: <201104250033.03401.maxi@daemonizer.de>
	 <1303878240.2699.41.camel@edumazet-laptop>
	 <1303878771.2699.44.camel@edumazet-laptop>
	 <201104271352.00601.maxi@daemonizer.de>
	 <20110512211033.GA3468@dev1756.snc6.facebook.com>
	 <1305234953.2831.2.camel@edumazet-laptop>
	 <20110524213327.GA3917@dev1756.snc6.facebook.com>
	 <1306291469.3305.11.camel@edumazet-laptop>
	 <20110525060609.GA32244@dev1756.snc6.facebook.com>
	 <1306305331.3305.22.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Thu, 26 May 2011 08:06:15 -0700
Message-ID: <1306422375.17233.88.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 May 2011 17:05:05.0779 (UTC) FILETIME=[0F679430:01CC1BC7]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18160.004
X-TM-AS-Result: No--26.141100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 08:35 +0200, Eric Dumazet wrote:
> Le mardi 24 mai 2011 à 23:06 -0700, Arun Sharma a écrit :
> > On Wed, May 25, 2011 at 04:44:29AM +0200, Eric Dumazet wrote:
> > > 
> > > Hmm, thanks for the report. Are you running x86 or another arch ?
> > > 
> > 
> > This was on x86.
> > 
> > > We probably need some sort of memory barrier.
> > > 
> > > However, locking this central lock makes the thing too slow, I'll try to
> > > use an atomic_inc_return on p->refcnt instead. (and then lock
> > > unused_peers.lock if we got a 0->1 transition)
> > 
> > Another possibility is to do the list_empty() check twice. Once without
> > taking the lock and again with the spinlock held.
> > 
> 
> Why ?
> 
> list_del_init(&p->unused); (done under lock of course) is safe, you can
> call it twice, no problem.
> 
> No, the real problem is the  (!list_empty(&p->unused) test : It seems to
> not always tell the truth if not done under lock.

Of course not; list modification operations are not atomic.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

