Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab0D1BiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:38:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab0D1BiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:38:06 -0400
Date: Wed, 28 Apr 2010 03:36:59 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] mm,migration: Remove straggling migration PTEs
 when page tables are being moved after the VMA has already moved
Message-ID: <20100428013659.GL510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
 <1272403852-10479-4-git-send-email-mel@csn.ul.ie>
 <20100427223004.GF8860@random.random>
 <20100427225852.GH8860@random.random>
 <20100428093948.c4e6faa1.kamezawa.hiroyu@jp.fujitsu.com>
 <20100428010543.GJ510@random.random>
 <20100428101858.1da1d2ed.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428101858.1da1d2ed.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 10:18:58AM +0900, KAMEZAWA Hiroyuki wrote:
> BTW, page->index is not updated, we just keep [start_address, pgoff] to be
> sane value.

yes I corrected myself too, the end result is the same and adjusting
the new vma vm_pgoff available in the anon-vma list is obviously
faster and simpler. When the src and dst ranges don't overlap and
src_vma != dst_vma (vma, new_vma in code) things are a lot simpler
there...
