Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab0DJXf6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 19:35:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab0DJXf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 19:35:57 -0400
Date: Sat, 10 Apr 2010 16:31:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Borislav Petkov <bp@alien8.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <20100410224915.GJ28964@cmpxchg.org>
Message-ID: <alpine.LFD.2.00.1004101629090.3576@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org> <20100409204328.GG28964@cmpxchg.org> <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org> <20100410003110.GI28964@cmpxchg.org>
 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org> <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic> <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004100930460.3558@i5.linux-foundation.org>
 <20100410224915.GJ28964@cmpxchg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Apr 2010, Johannes Weiner wrote:
> 
> Did you have something in mind that I missed?

Mostly that the corner cases will never matter, and I'd prefer to keep the 
code simpler than to care deeply.

For example, the only case you'd see vm_ops->close() is for special device 
mappings. It's true that they cannot have their vma's merged, but it's 
also true that they (a) will seldom have anon_vma's anyway and (b) would 
never get mapped very many times so that anon_vma merging would be an 
issue.

In other words, it's a "don't care" situation, where to keep the code 
simpler we just document that we don't care.

		Linus
