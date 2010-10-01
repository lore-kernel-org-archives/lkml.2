Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab0JAGQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:16:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60292 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0JAGQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:16:04 -0400
Date: Fri, 1 Oct 2010 02:16:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/17] fs: icache lock i_count
Message-ID: <20101001061602.GA19107@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-6-git-send-email-david@fromorbit.com>
 <20100929215229.160c7bce.akpm@linux-foundation.org>
 <20101001055536.GD32349@infradead.org>
 <20100930230416.868e6468.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930230416.868e6468.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:04:16PM -0700, Andrew Morton wrote:
> No, we've run into problems *frequently*.  A common case is where we
> convert a mutex to a spinlock or vice versa.  If you don't rename the
> lock, the code still compiles (with warnings) and crashes horridly at
> runtime.

Sorry, if you run code with that obvious warnings you beg for trouble.
If you really believe your advanced users arw too stupid to read
compiler warnings enforcing -Werror is for sure better than obsfucating
the code.

> Still wrong.  We do this frequently and we do it in areas where we
> believe that the implementation might change in the future.
> 
> Had we done it with i_count from day one then this part of the patchset
> would be far simpler.

I don't thin that's quite true.  The big point of using i_lock is that
we can hold it over accessing other things that also are protected by
it.  No accessor is going to help you with that.  For plain opencoded
increments we indeed need a helper as shown by Chris' aio speedup and
the churn in here - but that's already added later in the series and I
asked Dave to move it before this patch.

