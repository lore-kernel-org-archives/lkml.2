Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1C1MVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 08:21:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54364 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab1C1MVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:21:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ViWXjq3AUf3xnaSbAahRIHiLXynD9/a36/2Z9geaNsrKV59UeM6lkByzDReKPJSOkn
         tj88S/wNnjwAjnagf6qAihwVYGK51FG4rcbTBqiq2LNnL7U1S56dQkaSBeTC8xyUtQPN
         sOFz6kf2KU/DhabqVhI5YxhpPf/lRKnlvIAAg=
Date: Mon, 28 Mar 2011 21:21:25 +0900
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
Message-ID: <20110328122125.GA1892@barrios-desktop>
References: <20110315153801.3526.A69D9226@jp.fujitsu.com>
 <20110322194721.B05E.A69D9226@jp.fujitsu.com>
 <20110322200657.B064.A69D9226@jp.fujitsu.com>
 <20110324152757.GC1938@barrios-desktop>
 <1301305896.4859.8.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301305896.4859.8.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Mar 28, 2011 at 11:51:36AM +0200, Peter Zijlstra wrote:
> On Fri, 2011-03-25 at 00:27 +0900, Minchan Kim wrote:
> > 
> > At that time, I thought that routine is meaningless in non-RT scheduler.
> > So I Cced Peter but don't get the answer.
> > I just want to confirm it. 
> 
> Probably lost somewhere in the mess that is my inbox :/, what is the
> full question?

The question is we had a routine which change rt.time_slice with HZ to 
accelarate task exit. But when we applied 93b43fa5508, we found it isn't effective
any more about normal task. So we removed it. Is it right?

And Kosaki is about to revert 93b43fa5508 to find out the problem of this thread
and Luis said he has a another solution to replace 93b43fa5508. 
If rt.time_slice handleing is effective, we should restore it until Luis's patch
will be merged.


-- 
Kind regards,
Minchan Kim
