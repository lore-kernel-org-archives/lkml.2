Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0DBSlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:41:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363Ab0DBSlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:41:40 -0400
Date: Fri, 2 Apr 2010 11:37:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Borislav Petkov <bp@alien8.de>, Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Minchan Kim <minchan.kim@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <20100402112428.f46ddc44.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004021135530.3634@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <20100402175937.GA19690@liondog.tnic> <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org> <20100402112428.f46ddc44.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Apr 2010, Andrew Morton wrote:

> On Fri, 2 Apr 2010 11:09:14 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > I think this is likely due to the new scalable anon_vma linking by Rik. 
> 
> Similar to https://bugzilla.kernel.org/show_bug.cgi?id=15680

Yup, looks like the same thing, except that bugzilla entry was due to 
swapping rather than hibernation and memory shrinking. But same end 
result, just different reasons for why we were trying to shrink the page 
lists.

		Linus
