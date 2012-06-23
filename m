Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2FWUkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 16:40:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600Ab2FWUkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 16:40:09 -0400
Date: Sat, 23 Jun 2012 22:38:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: deferring __fput()
Message-ID: <20120623203800.GA10306@redhat.com>
References: <1340369098.2464.20.camel@falcor> <20120623092049.GH14083@ZenIV.linux.org.uk> <20120623194505.GI14083@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623194505.GI14083@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Al Viro wrote:
>
> BTW, I really wonder why do we need to have that void *data in task_work; we can
> always embed the sucker into a bigger struct (if nothing else, task_work +
> void *data) and get to it via container_of().  And in quite a few cases we don't
> want that data thing at all.

Yes, it is not strictly needed. From the changelog:

	"struct task_work" can be embedded in another struct, still it has "void
	*data" to handle the most common/simple case.

Namely, for keyctl_session_to_parent(). Probably it has ->data just because
I failed to invent the good name for the struct with task_work + cred.

> Moreover, the reasons to use hlist_head instead of
> a single forward pointer are very thin on the ground:

Oh, yes, there is no any reason. Except the code looks a bit simpler.

> Oleg, do you see any reasons why trimming it down to forward pointer + callback
> pointer wouldn't work?

OK. will do.

> Matter of fact, it would become identical to struct rcu_head
> after that...

This is not clear to me... Why this is good?

I understand that sizeof(task_work) == sizeof(rcu_head) would be
nice, probably you meant just this?

Oleg.

