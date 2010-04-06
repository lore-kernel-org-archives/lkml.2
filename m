Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0DFOjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 10:39:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab0DFOjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:39:43 -0400
Message-ID: <4BBB475A.7070002@redhat.com>
Date: Tue, 06 Apr 2010 10:38:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Minchan Kim <minchan.kim@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
References: <20100402175937.GA19690@liondog.tnic> <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org> <20100406173754.7E5A.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100406173754.7E5A.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 04:53 AM, KOSAKI Motohiro wrote:

> Today, I've reviewed this patch carefully. but I haven't found any bug.

> Also, I've runned stress workload with shrink_all_memory() today. but
> I couldn't reproduce the issue. hmm..  (perhaps I'm no lucky guy.
> I'm frequently fail to reproduce)
>
> I'll continue to work.

My status with this bug is the same - I have gone through
the code from all angles, but have not found any other bugs
yet (except for that leak - which could leave invalid
pointers behind).

This makes me wonder if perhaps the bug is a side effect
of something Borislav (and the other reproducers) have
in their kernel configuration, which we do not have.

Another (unlikely) thing is that the fix for the leak
makes the bug go away.  Yes, very unlikely.

Borislav, could you please send us your .config ?

Also, if you have the time, could you try out the
patch (-v2) I mailed in a little up this thread
that fixes the memory leak in anon_vma_fork?

I suspect it should not change anything, but it
could be useful to rule out anyway.
