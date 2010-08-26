Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0HZXCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:02:19 -0400
Received: from www.tglx.de ([62.245.132.106]:48489 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab0HZXCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:02:17 -0400
Date: Fri, 27 Aug 2010 01:02:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Shawn Bohrer <shawn.bohrer@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] hrtimer: make epoll_wait() use the hrtimer range
 feature
In-Reply-To: <alpine.DEB.2.00.1008261543470.25446@makko.or.mcafeemobile.com>
Message-ID: <alpine.LFD.2.00.1008270059240.2768@localhost.localdomain>
References: <alpine.DEB.2.00.1008261543470.25446@makko.or.mcafeemobile.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010, Davide Libenzi wrote:
> On Sun, 8 Aug 2010, Shawn Bohrer wrote:
> 
> > This make epoll use hrtimers for the timeout value which prevents
> > epoll_wait() from timing out up to a millisecond early.
> > 
> > This mirrors the behavior of select() and poll().
> 
> I saw this now, since I got notifications from Andrew's patch machine.
> Is this really needed?

Yes, as it is the last user space interface which is jiffies based.

> Is that really worth the extra code in the fast path?

It's not that much overhead and we had no complaints when we converted
everything else

> Aren't we breaking existing behavior?

We had no problems when we moved all the other interfaces over

> I have some doubts.

/me not - though I need to look at the patch itself

Thanks,

	tglx


