Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab2I0NLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:11:22 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58631 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751290Ab2I0NLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:11:21 -0400
Date: Thu, 27 Sep 2012 09:11:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Steven Rostedt <rostedt@goodmis.org>, torvalds@linux-foundation.org,
        tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, neilb@suse.de, bfields@fieldses.org,
        ejt@redhat.com, snitzer@redhat.com, edumazet@google.com,
        josh@joshtriplett.org, rmallon@gmail.com, palves@redhat.com
Subject: Re: [PATCH v6] hashtable: introduce a small and naive hashtable
Message-ID: <20120927131118.GC30139@Krystal>
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com> <1348667992.22822.50.camel@gandalf.local.home> <506310AA.2050700@gmail.com> <20120926143905.GB22699@Krystal> <1348675764.22822.56.camel@gandalf.local.home> <20120926161956.GB28648@Krystal> <AE90C24D6B3A694183C094C60CF0A2F6026B7009@saturn3.aculab.com> <50640F4E.4020305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50640F4E.4020305@gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sasha Levin (levinsasha928@gmail.com) wrote:
> On 09/27/2012 10:25 AM, David Laight wrote:
> >>>> And even then, if we would do:
> >>>>
> >>>>  	for (i = 0; i < HASH_SIZE(hashtable); i++)
> >>>>  		if (!hlist_empty(&hashtable[i]))
> >>>>  			break;
> >>>>
> >>>>  	return i >= HASH_SIZE(hashtable);
> >>>>
> >>>> What happens if the last entry of the table is non-empty ?
> >>>
> >>> It still works, as 'i' is not incremented due to the break. And i will
> >>> still be less than HASH_SIZE(hashtable). Did you have *your* cup of
> >>> coffee today? ;-)
> >>
> >> Ahh, right! Actually I had it already ;-)
> > 
> > I tend to dislike the repeated test, gcc might be able to optimise
> > it away, but the code is cleaner written as:
> > 
> > 	for (i = 0; i < HASH_SIZE(hashtable); i++)
> > 		if (!hlist_empty(&hashtable[i]))
> > 			return false;
> > 	return true;
> 
> Right, the flag thing in the macro was there just to make it work
> properly as a macro.
> 
> >> Agreed that the flags should be removed. Moving to define + static
> >> inline is still important though.
> > 
> > Not sure I'd bother making the function inline.
> 
> I usually never make anything 'inline', I just let gcc do it's own
> thing when it compiles the code. If there are any objections
> please let me know before I send the new version.

AFAIK, gcc nowadays use "inline" only as a hint, because programmers
were using it everywhere, even where it should not have been used. This
is where the attribute always_inline becomes useful, if you really,
really want to inline. However, for kernel coding style consistency, it
might be better to use "static inline", because it is used everywhere
else in kernel headers. Or maybe are there some headers that do not use
"inline" I am not aware of ?

Moreover, if your thinking is that we do not need a static inline
function replicated at every caller, maybe we should introduce a
lib/hashtable.c that implements those 2 functions.

Thanks,

Mathieu

> 
> 
> Thanks,
> Sasha
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
