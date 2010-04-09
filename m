Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab0DIUAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:00:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab0DIUA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:00:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/3] proc: make task_sig() lockless
In-Reply-To: Oleg Nesterov's message of  Tuesday, 23 March 2010 11:57:07 +0100 <20100323105707.GA8634@redhat.com>
References: <20100322184136.GA3967@redhat.com>
	<15829.1269333449@redhat.com>
	<20100323105707.GA8634@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20100409195936.44663BD18@magilla.sf.frob.com>
Date: Fri,  9 Apr 2010 12:59:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes. From the changelog:
> 
> 	Of course, this means we read pending/blocked/etc nonatomically,
> 	but I hope this is OK for fs/proc.
> 
> But I don't think the returned data could be "really" inconsistent
> from the /bin/ps pov. Yes, it is possible that, say, some signal is
> seen as both pending and ignored without ->siglock. Or we can report
> user->sigpending != 0 while pending/shpending are empty.
> 
> But this looks harmless to me. We never guaranteed /proc/pid/status
> can't report the "intermediate" state, and I don't think we can
> confuse the user-space.
> 
> Do you agree? Or do you think this can make problems ?

I'm not so sure.  Operations like sigprocmask and sigaction really have
always been entirely atomic from the userland perspective before.  Now it
becomes possible to read from /proc e.g. a blocked set that never existed
as such (one word updated by sigprocmask but not yet the next word).


Thanks,
Roland
