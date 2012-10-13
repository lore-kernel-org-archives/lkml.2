Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2JMQE7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 12:04:59 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58217
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753735Ab2JMQE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 12:04:58 -0400
Date: Sat, 13 Oct 2012 12:04:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 3
Message-ID: <20121013160455.GA32420@infradead.org>
References: <20121013002003.GL2616@ZenIV.linux.org.uk>
 <5079164D.4030307@gmail.com>
 <20121013075128.GQ2616@ZenIV.linux.org.uk>
 <20121013154810.GA9678@infradead.org>
 <20121013160115.GS2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121013160115.GS2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 05:01:15PM +0100, Al Viro wrote:
> You know, I'm in the middle of dealing with one such TODO.  Yours, as it
> were.  From six years ago.  kernel_thread() unexporting.  TODO comments
> of any form are routinely shat upon and ignored, especially when shuffled
> away into less read parts of the tree... ;-/
> 
> I'd rather see it done fs-by-fs.  Starting with something reasonably easy
> to test - minixfs would do nicely.  Don't get me wrong - I'm all for
> burying ->truncate(); what I'm worried about is that we'll end up burying
> the warning about the reasons why vmtruncate() was a bad idea, leaving the
> functionality exactly as it used to be...

As mentioned I agree with the concern in principle.  Let's start by
taking Marco's patches for filesystems that use vmtruncate but don't 
actually implement ->truncate.  There's a few I remember offhand, e.g.
procfs and ufs right now.  Then we can do the actual work required ones
piece by piece.
