Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab0GAOgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:36:17 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37713 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab0GAOgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:36:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aj207xZwYuTBkbZZCkLe26yDpLSQZvwLjUjat0TJ4+bmPulQKcMsKrFCQh+ist9C04
         bH7yslEsOLkuvPMKhmohca7Y0xK69f0tQvhMVa/o8FsY4w0djHohShrFDEIu0o894sC7
         jMjm79yJkYKJVUG9KQqSXDzROPvnh/Kd+/vnA=
Date: Thu, 1 Jul 2010 23:36:08 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 05/11] oom: /proc/<pid>/oom_score treat kernel thread
 honestly
Message-ID: <20100701143608.GB16383@barrios-desktop>
References: <20100630182922.AA56.A69D9226@jp.fujitsu.com>
 <20100630140328.GC15644@barrios-desktop>
 <20100701085309.DA16.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701085309.DA16.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 09:07:02AM +0900, KOSAKI Motohiro wrote:
> > On Wed, Jun 30, 2010 at 06:30:19PM +0900, KOSAKI Motohiro wrote:
> > > If kernel thread are using use_mm(), badness() return positive value.
> > > This is not big issue because caller care it correctly. but there is
> > > one exception, /proc/<pid>/oom_score call badness() directly and
> > > don't care the task is regular process.
> > > 
> > > another example, /proc/1/oom_score return !0 value. but it's unkillable.
> > > This incorrectness makes confusing to admin a bit.
> > 
> > Hmm. If it is a really problem, Could we solve it in proc_oom_score itself?
> 
> probably, no good idea. For maintainance view, all oom related code should
> be gathered in oom_kill.c.
> If you dislike to add messy into badness(), I hope to make badness_for_oom_score()

I am looking forward to seeing your next series.
Thanks, Kosaki. 

P.S) 
I think if the number of patch series is the bigger than #10, 
It would be better to include or point url of all-at-once patch 
in patch series.

In case of your patch, post patches changes pre patches
It could make hard review unless the reviewer merge patches into tree to
see the final figure. 

-- 
Kind regards,
Minchan Kim
