Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1C1Mkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 08:40:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52799 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1C1Mku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j4AIaN31xxYWHN/vuml+wQVDUT+76oKCGcd+FpvbwW8qUmi+1VUVCVgu8db9narcvu
         QSE7btGDNwe2PPZK3P2A5X498nOah8OReWiUm0LaErgdoD86wB/6rZyQ0qP4ZzSLN+bg
         kvO/FYaEDDWuBy8XRzTB7ChufYjprCdAIijXQ=
Date: Mon, 28 Mar 2011 21:40:25 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [PATCH 2/5] Revert "oom: give the dying task a higher priority"
Message-ID: <20110328124025.GC1892@barrios-desktop>
References: <20110315153801.3526.A69D9226@jp.fujitsu.com>
 <20110322194721.B05E.A69D9226@jp.fujitsu.com>
 <20110322200657.B064.A69D9226@jp.fujitsu.com>
 <20110324152757.GC1938@barrios-desktop>
 <1301305896.4859.8.camel@twins>
 <20110328122125.GA1892@barrios-desktop>
 <1301315307.4859.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301315307.4859.13.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 02:28:27PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-03-28 at 21:21 +0900, Minchan Kim wrote:
> > Hi Peter,
> > 
> > On Mon, Mar 28, 2011 at 11:51:36AM +0200, Peter Zijlstra wrote:
> > > On Fri, 2011-03-25 at 00:27 +0900, Minchan Kim wrote:
> > > > 
> > > > At that time, I thought that routine is meaningless in non-RT scheduler.
> > > > So I Cced Peter but don't get the answer.
> > > > I just want to confirm it. 
> > > 
> > > Probably lost somewhere in the mess that is my inbox :/, what is the
> > > full question?
> > 
> > The question is we had a routine which change rt.time_slice with HZ to 
> > accelarate task exit. But when we applied 93b43fa5508, we found it isn't effective
> > any more about normal task. So we removed it. Is it right?
> 
> rt.time_slice is only relevant to SCHED_RR, since you seem to use
> SCHED_FIFO (which runs for as long as the task is runnable), its
> completely irrelevant.
> 
> > And Kosaki is about to revert 93b43fa5508 to find out the problem of this thread
> > and Luis said he has a another solution to replace 93b43fa5508. 
> > If rt.time_slice handleing is effective, we should restore it until Luis's patch
> > will be merged.
> 
> Right, so only SCHED_RR is affected by time_slice, it will be
> decremented on tick (so anything that avoids ticks will also avoid the
> decrement) and once it reaches 0 the task will be queued at the tail of
> its static priority and reset the slice. If there is no other task on
> that same priority we'll again schedule that task.
> 
> In short, don't use SCHED_RR and don't worry about time_slice.

There was meaningless code in there. I guess it was in there from CFS.
Thanks for the explanation, Peter.

-- 
Kind regards,
Minchan Kim
