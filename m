Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1DBNzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 09:55:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1DBNzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 09:55:44 -0400
Date: Sat, 2 Apr 2011 15:55:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
Message-ID: <20110402135523.GA26316@redhat.com>
References: <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D94BE19.7050001@aknet.ru> <20110331181816.GA17101@redhat.com> <4D94EAEE.2010505@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D94EAEE.2010505@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, Stas Sergeev wrote:
>
> 31.03.2011 22:18, Oleg Nesterov wrote:
>> >  +			if (me->real_parent == init_pid_ns.child_reaper)
>>  Also, the task can be the child of /sbin/init's sub-thread.
> Hmm, how to check then? Should I add the "exact_parent" just
> for that? Or traverse the sibling list? How bad. :(

You can check same_thread_group(real_parent, ns->child_reaper)

> > I didn't look at the patch above, but probably it makes more sense.
> > At least for the start.
> IIRC strace didn't like the fact that wait() fails, and that's
> why I started to add the complexity.

Of course, the task should never escape ptrace, but this is
another issue?

And yes, it is not good if the child simply disappears, but the
semantics is "strange" in any case.

> OK, I'll try to break it into a small chunks then.
> But the fact that such a seemingly simple functionality
> requires so many changes, is IMHO bad by itself.

Indeed. You are trying to do something unnatural ;)

> And it
> is also non-trivial to implement mostly because of the
> ptrace hooks that are everywhere. Some cleanups are
> certainly needed in that area. :)

Not sure ptrace is the main problem... To me, it is the problem,
yes, but mostly from the semantics pov.

>> So, just in case, I have to admit: yes, personally I dislike this
>> new feature ;)
> Do you dislike a feature by itself, or by its implementation?

Both ;)

> The feature by itself does nothing but to allow the daemon()
> to work with threads, which can't be bad IMO,

Well. It is bad even if the patch was correct. This complicates
and slows down the code. The code should be maintained. And for
what?

> Of course,
> these cases have nothing to do with the good design,

Indeed. You suggest the exotic and non-portable feature, almost
nobody will use it. But every user should pay for that. This is
not fair.

> but why to
> search for the workarounds at all, in the first place? Why not
> to have the daemon() to "just work" with threads? :)

The kernel is already huge. I simply can't understand why do
you think this is good idea to add more bloat for this feature.

And this is not enough to daemonize anyway. setsid() won't work.



Stas, please do not try to convince me, you can't. OTOH, let me
repeat, you do not need to convince me. I'd suggest you to discuss
this with Linus. If he agrees - then we can look at your patch
seriously and discuss the implementation details. Everything can
be implemented.

Oleg.

