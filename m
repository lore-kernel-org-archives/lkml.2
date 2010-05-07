Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab0EGAM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 20:12:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46795 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab0EGAMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 20:12:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 7 May 2010 09:08:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] mm,compaction: Do not schedule work on other CPUs for
 compaction
Message-Id: <20100507090850.50d6a11c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100506150808.GC8704@csn.ul.ie>
References: <20100506150808.GC8704@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010 16:08:09 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> Migration normally requires a call to migrate_prep() as a preparation
> step. This schedules work on all CPUs for pagevecs to be drained. This
> makes sense for move_pages and memory hot-remove but is unnecessary
> for memory compaction.
> 
> To avoid queueing work on multiple CPUs, this patch introduces
> migrate_prep_local() which drains just local pagevecs.
> 
> This patch can be either merged with mmcompaction-memory-compaction-core.patch
> or placed immediately after it to clarify why migrate_prep_local() was
> introduced.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

