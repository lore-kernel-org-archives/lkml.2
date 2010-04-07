Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab0DGH3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:29:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50659 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499Ab0DGH3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:29:08 -0400
Date: Wed, 7 Apr 2010 09:29:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
Message-ID: <20100407072903.GB11220@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
References: <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
 <4BBB69A9.5090906@redhat.com>
 <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
 <20100406120315.53ad7390.akpm@linux-foundation.org>
 <20100406194238.GB20357@a1.tnic>
 <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
 <20100406205123.GC20357@a1.tnic>
 <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org>
 <20100406225925.GA3446@liondog.tnic>
 <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, Apr 06, 2010 at 04:27:42PM -0700

> No, you're mis-reading the asm. It's again the first iteration, and the 
> code above it is again the end of the loop. And %rax is once more a kernel 
> pointer, not the return value of 'page_referenced_one()'. 
> 
> So it once more is 'anon_vma->head.next' that is crap, but now it's not 
> NULL, it's that very odd 0x002e2e2e002e2e2e pattern (the %r13 has had 0x20 
> subtracted from it, so that LSB of "0x0e" is actually _also_ a 0x2e).

No, maybe I expressed myself wrong (it was late an' all) - I was
basically trying to confirm your assessment that anon_vma->head.next
is crap but the code had changed since I had added the debugging 'if
(!anon_vma->head.next)' and that was the value that was already in %r13
before iterating over the list chain.

Yeah, just a minor nitpick and not that it matters. Nevermind though,
we're on the same page.

-- 
Regards/Gruss,
Boris.
