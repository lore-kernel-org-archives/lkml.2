Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0D1NXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:23:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab0D1NW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:22:59 -0400
Date: Wed, 28 Apr 2010 02:20:56 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] Fix migration races in rmap_walk() V2
Message-ID: <20100428002056.GH510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
 <alpine.DEB.2.00.1004271723090.24133@router.home>
 <20100427223242.GG8860@random.random>
 <20100428091345.496ca4c4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428091345.496ca4c4.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 09:13:45AM +0900, KAMEZAWA Hiroyuki wrote:
> Doing some check in move_ptes() after vma_adjust() is not safe.
> IOW, when vma's information and information in page-table is incosistent...objrmap
> is broken and migartion will cause panic.
> 
> Then...I think there are 2 ways.
>   1. use seqcounter in "mm_struct" as previous patch and lock it at mremap.
> or
>   2. get_user_pages_fast() when do remap.

3 take the anon_vma->lock
