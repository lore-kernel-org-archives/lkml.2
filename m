Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab0D1AJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 20:09:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab0D1AJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 20:09:12 -0400
Date: Wed, 28 Apr 2010 02:08:33 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] mm,migration: Remove straggling migration PTEs
 when page tables are being moved after the VMA has already moved
Message-ID: <20100428000833.GE510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
 <1272403852-10479-4-git-send-email-mel@csn.ul.ie>
 <20100428090302.5e69721f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428090302.5e69721f.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 09:03:02AM +0900, KAMEZAWA Hiroyuki wrote:
> I bet calling __get_user_pages_fast() before vma_adjust() is the way to go. 
> When page_count(page) != page_mapcount(page) +1, migration skip it.

My proposed fix avoids to walk the pagetables once more time and to
mangle over the page counts. Can you check it? It works but it needs
more review.
