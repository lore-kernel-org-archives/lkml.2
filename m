Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab2KUKld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:41:33 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:40536 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab2KUKlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:41:32 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: trace filemap add and del
References: <1352404450-30100-1-git-send-email-robert.jarzmik@free.fr>
	<alpine.LNX.2.00.1211202103460.16323@eggly.anvils>
X-URL: http://belgarath.falguerolles.org/
Date: Wed, 21 Nov 2012 11:41:23 +0100
In-Reply-To: <alpine.LNX.2.00.1211202103460.16323@eggly.anvils> (Hugh
	Dickins's message of "Tue, 20 Nov 2012 21:07:39 -0800 (PST)")
Message-ID: <87k3tf5jcc.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hughd@google.com> writes:

> On Thu, 8 Nov 2012, Robert Jarzmik wrote:
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -467,6 +471,7 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
>>  		} else {
>>  			page->mapping = NULL;
>>  			/* Leave page->index set: truncation relies upon it */
>> +			trace_mm_filemap_add_to_page_cache(page);
>>  			spin_unlock_irq(&mapping->tree_lock);
>>  			mem_cgroup_uncharge_cache_page(page);
>>  			page_cache_release(page);
>
> I doubt if you really want your tracepoint sited just in this error path.

Urghh ... a git rebase mystified me.
In my original code, that tracepoint was 5 lines above, before the previous
spin_unlock_irq(), in the if branch, not the else branch.

Well spotted, I'll fix that for patch V2.

Cheers.

-- 
Robert
