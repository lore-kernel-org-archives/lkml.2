Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab1C1M3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 08:29:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45848 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab1C1M3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:29:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tuXkq0GALwE6B2KCm2xbi2sg4p8n0jnO0Q9zsQJKOT83dtfl3ZAxQI8r0Xw4qssYOs
         JlEp+/dmn9K2oQCK1dtgSLVzBD2FDXzLQ1iUwce7tdwt0ffw8vMSJ8CYmAIEdCIiFItn
         80nu5+Zvs/uXtJhXNixQOaCorpSOfqVuH1CNg=
Date: Mon, 28 Mar 2011 21:28:47 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/5] Revert "oom: give the dying task a higher priority"
Message-ID: <20110328122847.GB1892@barrios-desktop>
References: <20110322200657.B064.A69D9226@jp.fujitsu.com>
 <20110324152757.GC1938@barrios-desktop>
 <20110328184856.F078.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328184856.F078.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 06:48:13PM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > @@ -434,9 +452,17 @@ static int oom_kill_task(struct task_struct *p)
> >                 K(get_mm_counter(p->mm, MM_FILEPAGES)));
> >         task_unlock(p);
> >  
> > -       p->rt.time_slice = HZ; <<---- THIS
> > +
> >         set_tsk_thread_flag(p, TIF_MEMDIE);
> >         force_sig(SIGKILL, p);
> > +
> > +       /*
> > +        * We give our sacrificial lamb high priority and access to
> > +        * all the memory it needs. That way it should be able to
> > +        * exit() and clear out its resources quickly...
> > +        */
> > +       boost_dying_task_prio(p, mem);
> > +
> >         return 0;
> >  }
> > 
> > At that time, I thought that routine is meaningless in non-RT scheduler.
> > So I Cced Peter but don't get the answer.
> > I just want to confirm it.
> > 
> > Do you still think it's meaningless? 
> 
> In short, yes.
> 
> 
> > so you remove it when you revert 93b43fa5508?
> > Then, this isn't just revert patch but revert + killing meaningless code patch.
> 
> If you want, I'd like to rename a patch title. That said, we can't revert
> 93b43fa5508 simple cleanly, several patches depend on it. therefore I
> reverted it manualy. and at that time, I don't want to resurrect
> meaningless logic. anyway it's no matter. Luis is preparing new patches.
> therefore we will get the same end result. :)

I don't mind it, either. :)
I just want to make sure the meaningless logic.
Thanks.

-- 
Kind regards,
Minchan Kim
