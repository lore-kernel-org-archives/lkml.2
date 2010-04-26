Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0DZVzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:55:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab0DZVzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:55:09 -0400
Message-ID: <4BD60B80.8050605@redhat.com>
Date: Mon, 26 Apr 2010 17:54:08 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 04/14] mm,migration: Allow the migration of	PageSwapCache
  pages
References: <20100422195153.d91c1c9e.kamezawa.hiroyu@jp.fujitsu.com> <1271946226.2100.211.camel@barrios-desktop> <1271947206.2100.216.camel@barrios-desktop> <20100422154443.GD30306@csn.ul.ie> <20100423183135.GT32034@random.random> <20100423192311.GC14351@csn.ul.ie> <20100423193948.GU32034@random.random> <20100423213549.GV32034@random.random> <20100424105226.GF14351@csn.ul.ie> <20100424111340.GB32034@random.random> <20100424115936.GG14351@csn.ul.ie>
In-Reply-To: <20100424115936.GG14351@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2010 07:59 AM, Mel Gorman wrote:
> On Sat, Apr 24, 2010 at 01:13:40PM +0200, Andrea Arcangeli wrote:

>> Also keep in mind expand_downwards which also adjusts
>> vm_start/vm_pgoff the same way (and without mmap_sem write mode).
>
> Will keep it in mind. It's taking the anon_vma lock but once again,
> there might be more than one anon_vma to worry about and the proper
> locking still isn't massively clear to me.

The locking for the anon_vma_chain->same_vma list is
essentially the same as what was used before in mmap
and anon_vma_prepare.

Either the mmap_sem is held for write, or the mmap_sem
is held for reading and the page_table_lock is held.

What exactly is the problem that migration is seeing?

-- 
All rights reversed
