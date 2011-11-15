Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab1KOVH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:07:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62732 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab1KOVHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:07:55 -0500
Date: Tue, 15 Nov 2011 13:07:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
In-Reply-To: <20111115132513.GF27150@suse.de>
Message-ID: <alpine.DEB.2.00.1111151303230.23579@chino.kir.corp.google.com>
References: <20111110100616.GD3083@suse.de> <20111110142202.GE3083@suse.de> <CAEwNFnCRCxrru5rBk7FpypqeL8nD=SY5W3-TaA7Ap5o4CgDSbg@mail.gmail.com> <20111110161331.GG3083@suse.de> <20111110151211.523fa185.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1111101536330.2194@chino.kir.corp.google.com> <20111111101414.GJ3083@suse.de> <20111114154408.10de1bc7.akpm@linux-foundation.org> <20111115132513.GF27150@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011, Mel Gorman wrote:

> Fine control is limited. If it is really needed, I would not oppose
> a patch that allows the use of sync compaction via a new setting in
> /sys/kernel/mm/transparent_hugepage/defrag. However, I think it is
> a slippery slope to expose implementation details like this and I'm
> not currently planning to implement such a patch.
> 

This doesn't expose any implementation detail, the "defrag" tunable is 
supposed to limit defragmentation efforts in the VM if the hugepages 
aren't immediately available and simply fallback to using small pages.  
Given that definition, it would make sense to allow for synchronous 
defragmentation (i.e. sync_compaction) on the second iteration of the page 
allocator slowpath if set.  So where's the disconnect between this 
proposed behavior and the definition of the tunable in 
Documentation/vm/transhuge.txt?
