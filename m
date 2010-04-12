Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab0DLPxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 11:53:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab0DLPxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 11:53:43 -0400
Message-ID: <4BC3418D.1050709@redhat.com>
Date: Mon, 12 Apr 2010 11:51:41 -0400
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
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
References: <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org> <20100410185145.GB28952@a1.tnic> <20100410185839.GA32035@a1.tnic> <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org> <20100410203628.GB32035@a1.tnic> <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org> <20100410212555.GA1797@a1.tnic> <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org> <20100410215115.GA2599@a1.tnic> <20100411130801.GA7189@a1.tnic> <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org> <4BC227B6.7050802@redhat.com> <alpine.LFD.2.00.1004120841480.26679@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004120841480.26679@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 11:44 AM, Linus Torvalds wrote:
> On Sun, 11 Apr 2010, Rik van Riel wrote:
>>
>> Looking around the code some more, zap_pte_range()
>> calls page_remove_rmap(), which leaves the
>> page->mapping in place and has this comment:
>
> See my earlier email about this exact issue. It's well-known that there
> are stale page->mapping pointers. The "page_mapped()" check _should_ have
> meant that in that case we never follow them, though.

Good point.  I wonder if we have some SMP reordering
issue then?

>> I wonder if we can clear page->mapping here, if
>> list_is_singular(anon_vma->head).  That way we
>> will not leave stale pointers behind.
>
> What does that help? What if list _isn't_ singular?

Yeah, that was a bad idea.  Looking at the same code for
11 days straight seems to have put some knots in my brain :)
