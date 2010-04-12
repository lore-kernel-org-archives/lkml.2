Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab0DLQJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 12:09:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0DLQJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 12:09:18 -0400
Message-ID: <4BC34501.5060401@redhat.com>
Date: Mon, 12 Apr 2010 12:06:25 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
References: <20100409191425.GB10780@a1.tnic>	 <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>	 <20100409204328.GG28964@cmpxchg.org>	 <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>	 <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>	 <20100410003110.GI28964@cmpxchg.org>	 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>	 <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>	 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>	 <20100410163828.GA25579@a1.tnic>	 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>	 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>	 <1271083207.4807.18.camel@twins>  <4BC33A02.8000307@redhat.com> <1271088103.20295.3383.camel@laptop>
In-Reply-To: <1271088103.20295.3383.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 12:01 PM, Peter Zijlstra wrote:

> @@ -864,15 +889,8 @@ void page_remove_rmap(struct page *page)
>   		__dec_zone_page_state(page, NR_FILE_MAPPED);
>   		mem_cgroup_update_file_mapped(page, -1);
>   	}
> -	/*
> -	 * It would be tidy to reset the PageAnon mapping here,
> -	 * but that might overwrite a racing page_add_anon_rmap
> -	 * which increments mapcount after us but sets mapping
> -	 * before us: so leave the reset to free_hot_cold_page,
> -	 * and remember that it's only reliable while mapped.
> -	 * Leaving it set also helps swapoff to reinstate ptes
> -	 * faster for those pages still in swapcache.
> -	 */
> +
> +	page->mapping = NULL;
>   }

That would be a bug for file pages :)

I could see how it could work for anonymous memory, though.
