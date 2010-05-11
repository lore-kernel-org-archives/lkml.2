Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0EKMLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 08:11:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab0EKMLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 08:11:46 -0400
Message-ID: <4BE94935.9090200@redhat.com>
Date: Tue, 11 May 2010 08:10:29 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm,migration: Avoid race between shift_arg_pages() and
 rmap_walk() during migration by not migrating temporary stacks
References: <20100511085752.GM26611@csn.ul.ie>
In-Reply-To: <20100511085752.GM26611@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 04:57 AM, Mel Gorman wrote:
> Hi Andrew,
>
> This patch closes the most important race in relation to exec and
> migration. With it applied, the swapops bug is no longer triggering for
> known problem workloads. If you pick it up, it should go with the other
> mmmigration-* fixes in mm.

> This patch causes pages within the temporary stack during exec to be skipped
> by migration. It does this by marking the VMA covering the temporary stack
> with an otherwise impossible combination of VMA flags. These flags are
> cleared when the temporary stack is moved to its final location.
>
> [kamezawa.hiroyu@jp.fujitsu.com: Idea for having migration skip temporary stacks]
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>
> Reviewed-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
