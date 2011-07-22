Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1GVPQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:16:09 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49826
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524Ab1GVPQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:16:07 -0400
Date: Fri, 22 Jul 2011 11:16:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Curt Wohlgemuth <curtw@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110722151604.GD30317@infradead.org>
References: <CAO81RMairX_L5qGOcKKpw7gWdcTd2Y+5NL=+BA9EwTCNLCNmLw@mail.gmail.com>
 <20110711194835.GI5482@quack.suse.cz>
 <20110711201157.GA21460@infradead.org>
 <20110712103453.GC31226@quack.suse.cz>
 <20110712104132.GA14189@infradead.org>
 <20110712223715.GC13656@quack.suse.cz>
 <CAO81RMYJ76kdQ0qVuSSrfxugrTKAveSP98XQ2QF+VdbtjzJ--w@mail.gmail.com>
 <20110714230854.GA29160@quack.suse.cz>
 <20110719165639.GC11540@infradead.org>
 <20110721183523.GA4509@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721183523.GA4509@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 08:35:23PM +0200, Jan Kara wrote:
> > You're also skipping the ->sync_fs and quotasync calls the first round.
>   Well, kind of. Since writeback is running asynchronously, we have no way
> to call ->sync_fs(sb, 0) just after async inode writeback is done (and it
> doesn't really make sense to call it before that moment). So we call
> synchronous inode writeback first and only then ->sync_fs().

I don't nessecarily say it's a bad thing, but when you do subtile
behaviour changes like this it at least needs to be clearly documented
in the changelog, or even better split into a patch on it's own.

>   Where would you like to document the change?

commit log.

