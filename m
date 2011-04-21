Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab1DUUBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:01:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab1DUUBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:01:03 -0400
Date: Thu, 21 Apr 2011 22:00:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [2/2]
Message-ID: <20110421200006.GA12248@redhat.com>
References: <20110405164557.GA23248@redhat.com> <4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk> <4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk> <4DAEDC3F.5010208@aknet.ru> <20110420165023.GA24455@redhat.com> <4DAF29AD.1080603@aknet.ru> <20110420193307.GA1445@redhat.com> <4DAF439A.5020204@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAF439A.5020204@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21, Stas Sergeev wrote:
> 20.04.2011 23:33, Oleg Nesterov wrote:
>
>> I still do not understand the point of PR_DETACH. Why do you think it is
>> needed without reparenting? OK, I do not really care ;)
> Hmm, but that's really interesting, I wonder why do
> you ask this.

Because I do not understand why do we need this feature. And I strongly
dislike the complications this (wrong) patch adds.

> In my eyes, the reparenting was just a
> "trick",

Sure, I din't like the previous semantics too.


Once again, last time... No need to convince me. Please convince
someone who can ack this hack authoritatively. I can't anyway. And
I'm afraid nobody except Linus can decide whether we need it or not.

>From my side - nack. What can I do if I do not agree with you?

>>>> And. To hide the pr_detached task from do_wait(). you changed
>>>> do_notify_parent() to returnd DEATH_REAP.
>>> No, its hidden by the check in wait_consider_task().
>>> do_notify_parent() was changed only to not allow the
>>> second notification to the same parent.
>> Not only. Please look at your own code ;) wait_consider_task() checks
>> exit_state == EXIT_ZOMBIE before p->pr_detached, and thus do_notify_parent()
>> haas to return DEATH_REAP so that the caller will set EXIT_DEAD. Otherwise
>> the old parent could see EXIT_ZOMBIE&&  pr_detached task again.
> Yes, but that's not to hide from do_wait().
> At least as far as I understand, exit_notify() does
> release_task() in this case, so that's not hiding: I
> literally terminate the child this way.

Yes. But there is a window before release_task() does this, we should
change task->state.

But I forgot where did we start... perhaps I missed something or meant
something else. Perhaps I disliked the fact wait_consider_task() checks
EXIT_ZOMBIE before pr_detached... Nevermind.

Oleg.

