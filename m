Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2FYCMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 22:12:51 -0400
Received: from linux-sh.org ([111.68.239.195]:37979 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab2FYCMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 22:12:49 -0400
Date: Mon, 25 Jun 2012 11:11:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        peterz@infradead.org, minchan@gmail.com, kosaki.motohiro@gmail.com,
        andi@firstfloor.org, hannes@cmpxchg.org, mel@csn.ul.ie,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH -mm v2 11/11] mm: remove SH arch_get_unmapped_area
 functions
Message-ID: <20120625021121.GA9317@linux-sh.org>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
 <1340315835-28571-12-git-send-email-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340315835-28571-12-git-send-email-riel@surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 05:57:15PM -0400, Rik van Riel wrote:
> Remove the SH special variants of arch_get_unmapped_area since
> the generic functions should now be able to handle everything.
> 
> Paul, does anything in NOMMU SH need shm_align_mask?
> 
> Untested because I have no SH hardware.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: linux-sh@vger.kernel.org

We don't particularly need it for the nommu case, it's just using the
default PAGE_SIZE case there. The primary reason for having it defined
is so we can use the same cache alias checking and d-cache purging code
on parts that can operate with or without the MMU enabled.

So it would be nice to have the variable generally accessible regardless
of CONFIG_MMU setting, rather than having to have a private definition
for the nommu case.
