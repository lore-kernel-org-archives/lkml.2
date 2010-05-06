Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab0EFPfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab0EFPfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:35:04 -0400
Message-ID: <4BE2E167.2030806@redhat.com>
Date: Thu, 06 May 2010 11:33:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm,compaction: Do not schedule work on other CPUs for
 compaction
References: <20100506150808.GC8704@csn.ul.ie>
In-Reply-To: <20100506150808.GC8704@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 11:08 AM, Mel Gorman wrote:
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
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Reviewed-by: Rik van Riel <riel@redhat.com>
