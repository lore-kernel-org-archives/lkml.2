Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab0KYLG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:06:59 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34153 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab0KYLG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:06:58 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [resend][PATCH 4/4] oom: don't ignore rss in nascent mm
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>
In-Reply-To: <20101124110915.GA20452@redhat.com>
References: <20101124085022.7BDF.A69D9226@jp.fujitsu.com> <20101124110915.GA20452@redhat.com>
Message-Id: <20101125092237.F43A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 25 Nov 2010 20:06:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Stupid question.
> > >
> > > Can't we just account these allocations in the old -mm temporary?
> > >
> > > IOW. Please look at the "patch" below. It is of course incomplete
> > > and wrong (to the point inc_mm_counter() is not safe without
> > > SPLIT_RSS_COUNTING), and copy_strings/flush_old_exec are not the
> > > best places to play with mm-counters, just to explain what I mean.
> > >
> > > It is very simple. copy_strings() increments MM_ANONPAGES every
> > > time we add a new page into bprm->vma. This makes this memory
> > > visible to select_bad_process().
> > >
> > > When exec changes ->mm (or if it fails), we change MM_ANONPAGES
> > > counter back.
> > >
> > > Most probably I missed something, but what do you think?
> >
> > Because, If the pages of argv is swapping out when processing execve,
> > This accouing doesn't work.
> 
> Why?
> 
> If copy_strings() inserts the new page into bprm->vma and then
> this page is swapped out, inc_mm_counter(current->mm, MM_ANONPAGES)
> becomes incorrect, yes. And we can't turn it into MM_SWAPENTS.
> 
> But does this really matter? oom_badness() counts MM_ANONPAGES +
> MM_SWAPENTS, and result is the same.

Ah, I got it. I did too strongly get stucked correct accounting. but
you mean it's not must.

Okey, I'll tackle this one at this weekend hopefully.



> > Is this enough explanation? Please don't hesitate say "no". If people
> > don't like my approach, I don't hesitate change my thinking.
> 
> Well, certainly I can't say no ;)
> 
> But it would be nice to find a more simple fix (if it can work,
> of course).
> 
> 
> And. I need a simple solution for the older kernels.

Alright. It is certinally considerable one.


