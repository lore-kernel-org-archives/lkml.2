Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0CXIhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:37:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab0CXIhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:37:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100323105707.GA8634@redhat.com>
References: <20100323105707.GA8634@redhat.com> <20100322184136.GA3967@redhat.com> <15829.1269333449@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/3] proc: make task_sig() lockless
Date: Wed, 24 Mar 2010 08:37:22 +0000
Message-ID: <11571.1269419842@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> > Except that the data returned might then be inconsistent because you don't
> > hold a lock as you read the various bits of it.
> 
> Yes. From the changelog:
> 
> 	Of course, this means we read pending/blocked/etc nonatomically,
> 	but I hope this is OK for fs/proc.

Ah, yes.  I read that as you meant how procfs accessed the actual data
structures, not how the user accessed procfs.  It might be worth clarifying
that.

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

I don't know of anything this will affect adversely.  In fact, I'm not sure
there was a guarantee that it would be atomic anyway.

So as far as I'm concerned, you can add:

Acked-by: David Howells <dhowells@redhat.com>

> > Probably we can change do_task_stat() to avod ->siglock too, except
> > we can't get tty_nr lockless.

Btw, avoid has an 'i' in it... :-)
