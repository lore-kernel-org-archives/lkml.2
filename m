Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab2I0NDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:03:08 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58615 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751220Ab2I0NDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:03:06 -0400
Date: Thu, 27 Sep 2012 09:03:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <levinsasha928@gmail.com>, torvalds@linux-foundation.org,
        tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, neilb@suse.de, bfields@fieldses.org,
        ejt@redhat.com, snitzer@redhat.com, edumazet@google.com,
        josh@joshtriplett.org, rmallon@gmail.com, palves@redhat.com
Subject: Re: [PATCH v6] hashtable: introduce a small and naive hashtable
Message-ID: <20120927130303.GB30139@Krystal>
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com> <1348667992.22822.50.camel@gandalf.local.home> <506310AA.2050700@gmail.com> <20120926143905.GB22699@Krystal> <1348675764.22822.56.camel@gandalf.local.home> <20120926161956.GB28648@Krystal> <AE90C24D6B3A694183C094C60CF0A2F6026B7009@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7009@saturn3.aculab.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Laight (David.Laight@ACULAB.COM) wrote:
> > > > And even then, if we would do:
> > > >
> > > >  	for (i = 0; i < HASH_SIZE(hashtable); i++)
> > > >  		if (!hlist_empty(&hashtable[i]))
> > > >  			break;
> > > >
> > > >  	return i >= HASH_SIZE(hashtable);
> > > >
> > > > What happens if the last entry of the table is non-empty ?
> > >
> > > It still works, as 'i' is not incremented due to the break. And i will
> > > still be less than HASH_SIZE(hashtable). Did you have *your* cup of
> > > coffee today? ;-)
> > 
> > Ahh, right! Actually I had it already ;-)
> 
> I tend to dislike the repeated test, gcc might be able to optimise
> it away, but the code is cleaner written as:
> 
> 	for (i = 0; i < HASH_SIZE(hashtable); i++)
> 		if (!hlist_empty(&hashtable[i]))
> 			return false;
> 	return true;
> 

Agreed, this looks like a good way to write it.

> > Agreed that the flags should be removed. Moving to define + static
> > inline is still important though.
> 
> Not sure I'd bother making the function inline.

Do you mean you prefer to keep it as a macro, or that you don't think
the "inline" keyword is relevant anymore, and want to do a "static" only
function in the header file ?

In both cases, please explain the reasons for doing things that way.

Thanks,

Mathieu

> 
> 	David
> 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
