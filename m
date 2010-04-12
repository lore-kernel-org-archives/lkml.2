Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab0DLVEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 17:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab0DLVE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 17:04:29 -0400
Message-ID: <4BC38A94.2050003@redhat.com>
Date: Mon, 12 Apr 2010 17:03:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH 4/4] anonvma: when setting up page->mapping, we need to
 pick the _oldest_ anonvma
References: <20100411130801.GA7189@a1.tnic> <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org> <20100411185508.GA4450@liondog.tnic> <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org> <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org> <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org> <4BC36916.3080005@redhat.com> <20100412190002.GA8595@a1.tnic> <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org> <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org> <alpine.LFD.2.00.1004121322400.3683@i5.linux-foundation.org> <alpine.LFD.2.00.1004121323080.3683@i5.linux-foundation.org> <alpine.LFD.2.00.1004121323270.3683@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004121323270.3683@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 04:23 PM, Linus Torvalds wrote:
>
> From: Linus Torvalds<torvalds@linux-foundation.org>
> Date: Mon, 12 Apr 2010 12:44:29 -0700
> Subject: [PATCH 4/4] anonvma: when setting up page->mapping, we need to pick the _oldest_ anonvma
>
> Otherwise we might be mapping in a page in a new mapping, but that page
> (through the swapcache) would later be mapped into an old mapping too.
> The page->mapping must be the case that works for everybody, not just
> the mapping that happened to page it in first.
>
> This can be improved in certain cases: if we know the page is private to
> just this particular mapping (for example, it's a new page, or it is the
> only swapcache entry), we could pick the top (most specific) anon_vma.
>
> But that's a future optimization. Make it _work_ reliably first.

Agreed.  I'll send an incremental for that later, you
can judge whether or not it's something you'll want to
merge before or after 2.6.34

> Signed-off-by: Linus Torvalds<torvalds@linux-foundation.org>

Reviewed-by: Rik van Riel <riel@redhat.com>
