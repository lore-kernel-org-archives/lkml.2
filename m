Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1FGQhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:37:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55272 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1FGQhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xkFWK5NWgIeBt7VA6QLItKPsukLicuPRS08/CIlihC607G6jisWWXYA0hZZ+om44Ie
         zgK6EGLCn4c9ZYLmFGkFU6FRlOqFw+soCfjj6HxQ6thGO5zYUkMJJNKFDdmVWcrsPp6t
         5LOvMMCzlhp1PaXl0XQS1u+NFvytPt1dUHKzk=
Date: Wed, 8 Jun 2011 01:36:57 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Sattler <tsattler@gmx.de>, Ury Stankevich <urykhy@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mm: compaction: Abort compaction if too many pages
 are isolated and caller is asynchronous V2
Message-ID: <20110607163657.GM1686@barrios-laptop>
References: <1307459225-4481-1-git-send-email-mgorman@suse.de>
 <1307459225-4481-5-git-send-email-mgorman@suse.de>
 <20110607155029.GL1686@barrios-laptop>
 <20110607162711.GO5247@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607162711.GO5247@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 05:27:11PM +0100, Mel Gorman wrote:
> Changelog since V1
>   o Return COMPACT_PARTIAL when aborting due to too many isolated
>     pages. As pointed out by Minchan, this is better for consistency
> 
> Asynchronous compaction is used when promoting to huge pages. This is
> all very nice but if there are a number of processes in compacting
> memory, a large number of pages can be isolated. An "asynchronous"
> process can stall for long periods of time as a result with a user
> reporting that firefox can stall for 10s of seconds. This patch aborts
> asynchronous compaction if too many pages are isolated as it's better to
> fail a hugepage promotion than stall a process.
> 
> [minchan.kim@gmail.com: Return COMPACT_PARTIAL for abort]
> Reported-and-tested-by: Ury Stankevich <urykhy@gmail.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards
Minchan Kim
