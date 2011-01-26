Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1AZXH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:07:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824Ab1AZXH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:07:26 -0500
Date: Wed, 26 Jan 2011 15:06:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/3] When migrate_pages returns 0, all pages must have
 been released
Message-Id: <20110126150612.cf288843.akpm@linux-foundation.org>
In-Reply-To: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com>
References: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 01:17:05 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> In some cases migrate_pages could return zero while still leaving a
> few pages in the pagelist (and some caller wouldn't notice it has to
> call putback_lru_pages after commit
> cf608ac19c95804dc2df43b1f4f9e068aa9034ab).
> 
> Add one missing putback_lru_pages not added by commit
> cf608ac19c95804dc2df43b1f4f9e068aa9034ab.
> 
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Some patch administrivia:

a) you were on the delivery path for this patch, so you should have
   added your signed-off-by:.  I have made that change to my copy.

   There's no harm in also having a Reviewed-by:, but Signed-off-by:
   does imply that, we hope.

b) Andrea's From: line appeared twice.

c) Please choose patch titles which identify the subsystem which is
   being patched.  Plain old "mm:" will suit, although "mm:
   compaction:" or "mm/compaction" would be nicer.

   For some weird reason people keep on sending me patches with titles like

	drivers: mmc: host: omap.c: frob the nozzle

   or similar.  I think there might be some documentation file which
   (mis)leads them to do this.  I simply do the utterly obvious and
   convert it to

	drivers/mmc/host/omap.c: frob the nozzle

   duh.

d) Please don't identify patches via bare commit IDs.  Because
   commits can have different IDs in different trees.  Instead use the
   form cf608ac19c95 ("mm: compaction: fix COMPACTPAGEFAILED
   counting").  I end up having to do this operation multiple times a
   day and it's dull.  And sometimes I don't even have that commit ID
   in any of my trees, because they were working against some other
   tree.

   Also note that the 40-character commit ID has been trimmed to 12
   characters or so.

Thanks.
