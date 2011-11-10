Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab1KJXhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 18:37:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38154 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab1KJXhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 18:37:36 -0500
Date: Thu, 10 Nov 2011 15:37:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
In-Reply-To: <20111110151211.523fa185.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1111101536330.2194@chino.kir.corp.google.com>
References: <20111110100616.GD3083@suse.de> <20111110142202.GE3083@suse.de> <CAEwNFnCRCxrru5rBk7FpypqeL8nD=SY5W3-TaA7Ap5o4CgDSbg@mail.gmail.com> <20111110161331.GG3083@suse.de> <20111110151211.523fa185.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Nov 2011, Andrew Morton wrote:

> > This patch once again prevents sync migration for transparent
> > hugepage allocations as it is preferable to fail a THP allocation
> > than stall.
> 
> Who said?  ;) Presumably some people would prefer to get lots of
> huge pages for their 1000-hour compute job, and waiting a bit to get
> those pages is acceptable.
> 

Indeed.  It seems like the behavior would better be controlled with 
/sys/kernel/mm/transparent_hugepage/defrag which is set aside specifically 
to control defragmentation for transparent hugepages and for that 
synchronous compaction should certainly apply.
