Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab1CXPLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:11:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55093 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab1CXPLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p0zmvuFc5AmlqR569XXoKmCi0iXQtWxHsnjV8Gm9qchxAP4TQ5r7BVfjGRKaTl4zmW
         rEGzV9sDQ/qh/1eKZn+bRGZgyIXyiNH5Q51tM6dOE3lJNDpNWkMCUvaAahWQjKrX1Qck
         cUo03Pf7vCAa8cZcnOYeKXOSj0EcNwEL+Vx5s=
Date: Fri, 25 Mar 2011 00:10:48 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 5/5] x86,mm: make pagefault killable
Message-ID: <20110324151048.GB1938@barrios-desktop>
References: <20110315153801.3526.A69D9226@jp.fujitsu.com>
 <20110322194721.B05E.A69D9226@jp.fujitsu.com>
 <20110322200945.B06D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322200945.B06D.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 08:09:29PM +0900, KOSAKI Motohiro wrote:
> When oom killer occured, almost processes are getting stuck following
> two points.
> 
> 	1) __alloc_pages_nodemask
> 	2) __lock_page_or_retry
> 
> 1) is not much problematic because TIF_MEMDIE lead to make allocation
> failure and get out from page allocator. 2) is more problematic. When
> OOM situation, Zones typically don't have page cache at all and Memory
> starvation might lead to reduce IO performance largely. When fork bomb
> occur, TIF_MEMDIE task don't die quickly mean fork bomb may create
> new process quickly rather than oom-killer kill it. Then, the system
> may become livelock.
> 
> This patch makes pagefault interruptible by SIGKILL.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Looks like a cool idea.

-- 
Kind regards,
Minchan Kim
