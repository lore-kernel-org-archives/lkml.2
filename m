Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145Ab2JSOZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:25:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:49792 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988Ab2JSOZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:25:35 -0400
Message-ID: <1350656690.2768.19.camel@twins>
Subject: Re: [PATCH RFC] sched: boost throttled entities on wakeups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vladimir Davydov <VDavydov@parallels.com>
Cc: Ingo Molnar <mingo@redhat.com>, Paul Turner <pjt@google.com>,
        Kirill Korotaev <dev@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Date: Fri, 19 Oct 2012 16:24:50 +0200
In-Reply-To: <206EF0C3-1F5F-4B58-B7DA-E63298939DFD@parallels.com>
References: <206EF0C3-1F5F-4B58-B7DA-E63298939DFD@parallels.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 11:32 +0400, Vladimir Davydov wrote:
> 
> 1) Do you agree that the problem exists and should be sorted out?

This is two questions.. yes it exists, I'm absolutely sure I pointed it
out as soon as people even started talking about this nonsense (bw
cruft).

Should it be sorted, dunno, in general !PREEMPT_RT is very susceptible
to all this and in general we don't fix it.

> 2) If so, does the general approach proposed (unthrottling on wakeups) suits
> you? Why or why not?

its a quick hack similar to existing hacks done for rt, preferably we'd
do smarter things though.

> 3) If you think that the approach proposed is sane, what you dislike about the
> patch? 

its not inlined, its got coding style issues, but worst of all, you
added yet another callback from the schedule() path and did it wrong ;-)

Also, it adds even more bw cruft overhead to regular scheduling paths,
we took some pains to limit that when we introduced the fail^Wfeature.
