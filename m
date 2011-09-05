Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1IEJnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:43:02 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47160
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894Ab1IEJmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:42:55 -0400
Date: Mon, 5 Sep 2011 05:42:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, khlebnikov@openvz.org
Subject: Re: [PATCH 11/13] dcache: use a dispose list in select_parent
Message-ID: <20110905094252.GA28967@infradead.org>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com>
 <1314089786-20535-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314089786-20535-12-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -/**
>   * shrink_dcache_sb - shrink dcache for a superblock
>   * @sb: superblock
>   *
> @@ -1073,7 +1054,7 @@ EXPORT_SYMBOL(have_submounts);
>   * drop the lock and return early due to latency
>   * constraints.
>   */
> -static long select_parent(struct dentry * parent)
> +static long select_parent(struct dentry *parent, struct list_head *dispose)

Btw, the function header comment above select_parent is entirely
incorrect after your changes.

Also I'd suggest folding select_parent into shrink_dcache_parent as
the split doesn't make a whole lot of sense any more.  Maybe factoring
it at a different level would make sense, though.

