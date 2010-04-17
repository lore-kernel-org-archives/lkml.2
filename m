Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab0DQQik (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 12:38:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:55524 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0DQQii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 12:38:38 -0400
Date: Sat, 17 Apr 2010 09:40:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Salman <sqazi@google.com>
Cc: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       linux-pm@lists.linux-foundation.org, csadler@google.com,
       ranjitm@google.com, kenchen@google.com, dawnchen@google.com
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
Message-ID: <20100417094005.449443be@infradead.org>
In-Reply-To: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Apr 2010 17:08:18 -0700
Salman <sqazi@google.com> wrote:

> As we discussed earlier this year, Google has an implementation that
> it would like to share.  I have finally gotten around to porting it to
> v2.6.33 and cleaning up the interfaces.  It is provided in the
> following messages for your review.  I realize that when we first
> discussed this idea, a lot of ideas were presented for enhancing it.
> Thanks alot for your suggestions.  I haven't gotten around to
> implementing any of them.

again I'll chime in to support this effort; it's the right thing to do
for power limiting (as opposed to taking cores offline), and I'm happy
to see progress being made.

I'll start playing with your patches and use timechart to see how well
it works, including to see how well things align... 

> The ones that I still find appealing are:
> 
> 0. Providing approximate synchronization between cores, regardless
> of their independant settings in order to improve power savings.   We
> have to balance this with eager injection (i.e. avoiding injection
> when an interactive task needs to run).

I still would like to see this ;-)
It's a *HUGE* instant power delta.

But it does not have to be perfect. As long as "on average" we align
we're good enough.

the easiest way is to round the time of the start of idle injection
up to, say, double the duration of the injection period...
and maybe to whole seconds or some round value of jiffies as well.

It could even be done by "creeping" towards an aligned situation...
rather than forcing instant alignment, as long as each time we inject
idle time we get a step closer to being aligned.. very soon we WILL be
aligned.
(for example, if a cpu notices it's on the late side of an alignment
window, it could inject a little shorter than usual, while if it
notices it's a little early, it can inject a little longer)
 
> A stricter synchronization between cores is needed to make idle cycle
> injector work on hyperthreaded systems.  This is a some what separate
> issue, as there should only be one idle cycle injector minimum idle
> setting per physical core.

actually... while the HT case is clearly required to be solved to get
actual power limits, ideally we can solve it using the same tricks we
use for the above, just with a stronger bias...

I don't think we need to force the admin to set the same value per se,
it's something that's just a matter of having the policy guy do this
right... (but if you want to do "effective injection %age is minimum of
the two" or so, I can live with that)




> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
