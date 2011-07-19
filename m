Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab1GSQxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 12:53:49 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38817
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008Ab1GSQxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 12:53:48 -0400
Date: Tue, 19 Jul 2011 12:53:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Curt Wohlgemuth <curtw@google.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110719165345.GB11540@infradead.org>
References: <20110629191518.GA23196@quack.suse.cz>
 <BANLkTinndb4oHi6kNQrTsL86UrKDB=2rK6-gA8FM1Nj8CKYZ+w@mail.gmail.com>
 <20110711170042.GE5482@quack.suse.cz>
 <CAO81RMairX_L5qGOcKKpw7gWdcTd2Y+5NL=+BA9EwTCNLCNmLw@mail.gmail.com>
 <20110711194835.GI5482@quack.suse.cz>
 <20110711201157.GA21460@infradead.org>
 <20110712103453.GC31226@quack.suse.cz>
 <20110712104132.GA14189@infradead.org>
 <20110712223715.GC13656@quack.suse.cz>
 <CAO81RMYJ76kdQ0qVuSSrfxugrTKAveSP98XQ2QF+VdbtjzJ--w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO81RMYJ76kdQ0qVuSSrfxugrTKAveSP98XQ2QF+VdbtjzJ--w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 09:29:34AM -0700, Curt Wohlgemuth wrote:
> Your patch looks good to me, in that it does hit all the bdevs with
> both WB_SYNC_NONE and SYNC_ALL.  However, I still say that the call to
> wakeup_flusher_threads() in sys_sync() is superfluous, at least as
> long as writeback_inodes_sb() waits for completion of the work item
> that it enqueues.

Commit 3beab0b42413e83a7907db7176b54c840fc75a81

	"sys_sync(): fix 16% performance regression in ffsb create_4k test"

suggests we need the wakeup_flusher_threads.  We might be able to get
rid of the writeback_inodes_sb call if we're lucky.

