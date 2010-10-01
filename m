Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab0JAFzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:55:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46788 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0JAFzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:55:38 -0400
Date: Fri, 1 Oct 2010 01:55:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/17] fs: icache lock i_count
Message-ID: <20101001055536.GD32349@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-6-git-send-email-david@fromorbit.com>
 <20100929215229.160c7bce.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929215229.160c7bce.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 09:52:29PM -0700, Andrew Morton wrote:
> On Wed, 29 Sep 2010 22:18:37 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> > -	if (atomic_read(&inode->i_count) != 1)
> > +	if (inode->i_count != 1)
> 
> This really should have been renamed to catch unconverted code.
> 
> Such code usually wouldn't compile anyway, but it will if it takes the
> address of i_count only (for example).

If people do whacky things they'll lose - there is a reason why C has a
fairly strict type system after all.  We've changed types of variables
all the time and we didn't run into problems.

> And maybe we should access this guy via accessor functions, dunno.

Seems like complete overkill.

