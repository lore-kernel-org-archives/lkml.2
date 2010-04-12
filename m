Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab0DLTIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:08:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60206 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab0DLTIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:08:20 -0400
Date: Mon, 12 Apr 2010 21:00:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
Message-ID: <20100412190002.GA8595@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Rik van Riel <riel@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
References: <20100411130801.GA7189@a1.tnic>
 <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org>
 <20100411185508.GA4450@liondog.tnic>
 <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org>
 <20100412072056.GA2432@liondog.tnic>
 <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org>
 <4BC36916.3080005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4BC36916.3080005@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>
Date: Mon, Apr 12, 2010 at 02:40:22PM -0400

> On 04/12/2010 12:26 PM, Linus Torvalds wrote:
> 
> >But there is a _much_ more subtle case that involved swapping.
> >
> >So guys, here's my fairly simple theory on what happens:
> 
> That bug looks entirely possible.  Given that Borislav
> has heavy swapping going on, it is quite possible that
> this is the bug he has been triggering.

Yeah, about that. I dunno whether you guys saw that but the machine has
8Gb of RAM and shouldn't be swapping, AFAIK. The largest mem usage I
saw was 5Gb used, most of which pagecache. So I was kinda doubtful when
Linus came up with the swapping theory earlier. I'll pay attention to
the SwapCached in /proc/meminfo more to see whether we do any swapping.
It could be that there is a small amount which is swapped out for
whatever reason... Maybe that's the bug...

But I'll give the patch a run anyway in an hour or so anyway.

-- 
Regards/Gruss,
Boris.
