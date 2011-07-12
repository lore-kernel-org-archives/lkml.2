Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab1GLKll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:41:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41286
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045Ab1GLKlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:41:39 -0400
Date: Tue, 12 Jul 2011 06:41:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Curt Wohlgemuth <curtw@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110712104132.GA14189@infradead.org>
References: <20110629081155.GA5558@infradead.org>
 <20110629165714.GF17590@quack.suse.cz>
 <20110629175534.GA32236@infradead.org>
 <20110629191518.GA23196@quack.suse.cz>
 <BANLkTinndb4oHi6kNQrTsL86UrKDB=2rK6-gA8FM1Nj8CKYZ+w@mail.gmail.com>
 <20110711170042.GE5482@quack.suse.cz>
 <CAO81RMairX_L5qGOcKKpw7gWdcTd2Y+5NL=+BA9EwTCNLCNmLw@mail.gmail.com>
 <20110711194835.GI5482@quack.suse.cz>
 <20110711201157.GA21460@infradead.org>
 <20110712103453.GC31226@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712103453.GC31226@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 12:34:53PM +0200, Jan Kara wrote:
> > All block device inodes sit on blockdev_superblock, we got rid of inodes
> > without a superblock long time ago.
>   Sure, we can easily iterate also blockdev_superblock. What I meant is
> that blockdev_superblock will need a special handling since we otherwise
> ignore pseudo superblocks...

Pseudo superblocks aren't ignored.  They are added to super_blocks like
all others, and iterate_supers doesn't skip over them.  The problem
is that blockdev_superblock doesn't have a proper s_bdi set, and thus
gets skipped over by __sync_filesystem. 

