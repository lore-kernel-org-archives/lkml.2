Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2LHMMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 07:12:13 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37076
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614Ab2LHMML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 07:12:11 -0500
Date: Sat, 8 Dec 2012 07:12:04 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Alun <alun.linux@ty-penguin.org.uk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH reduce impact of FIFREEZE on userland processes
Message-ID: <20121208121204.GA18467@infradead.org>
References: <20121205211707.7ca3b94b@aspire.ty-penguin.org.uk>
 <20121207004255.GC27172@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207004255.GC27172@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 11:42:55AM +1100, Dave Chinner wrote:
> The problem wth doing this is that the sync can delay the freeze
> process by quite some time under the exact conditions you describe.
> If you want freeze to take effect immediately (i.e instantly stop
> new modifications), then adding a sync will break this semantic.
> THere are existing users of freeze that require this behaviour...

But that's only because he uses the big hammer sync_filesystem() which
actually waits for I/O completion.  I agree that this is a bad idea,
but if we'd just do a writeback_inodes_sb() call in this place that
starts asynchronous writeout I think everyone would benefit.

