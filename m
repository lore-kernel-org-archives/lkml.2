Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab2LTKwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 05:52:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab2LTKwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 05:52:18 -0500
Date: Thu, 20 Dec 2012 10:52:14 +0000
From: Mel Gorman <mgorman@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: compaction: count compaction events only if
 compaction is enabled
Message-ID: <20121220105214.GC10819@suse.de>
References: <alpine.LNX.2.00.1212201118080.17797@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1212201118080.17797@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 11:21:34AM +0100, Jiri Kosina wrote:
> On configs which have CONFIG_CMA but no CONFIG_COMPACTION, 
> isolate_migratepages_range() and isolate_freepages_block() must not 
> account for COMPACTFREE_SCANNED and COMPACTISOLATED events (those 
> constants are even undefined in such case, causing a build error).
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Minchan has a similar patch in the works that defines count_compact_events()
similar to count_vm_numa_events(). It just needs a small correction. The
fixed version would avoid having an #ifdef in the middle of the function
which is cosmetically a bit nicer.

-- 
Mel Gorman
SUSE Labs
