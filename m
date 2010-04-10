Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab0DJOru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 10:47:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab0DJOrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 10:47:49 -0400
Message-ID: <4BC08F25.3080600@redhat.com>
Date: Sat, 10 Apr 2010 10:45:57 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
References: <20100409174041.GA10780@a1.tnic> <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org> <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org> <20100409204328.GG28964@cmpxchg.org> <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org> <20100410003110.GI28964@cmpxchg.org> <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org> <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>
In-Reply-To: <20100410112639.GA24708@a1.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2010 07:26 AM, Borislav Petkov wrote:

> This time we got stuck on the anon_vma->lock (yep, we've seen that
> oopsie before). So, it might be that we _really_ are staring at the
> wrong code... Back to square one.

This is a different bug, though.

If the null pointer dereference is gone, Linus's patch
fixed that bug and we can move forward to fixing the
anon_vma->lock bug.

I'll start auditing the code to see if we forget to
unlock the anon_vma in some unlikely error path...
