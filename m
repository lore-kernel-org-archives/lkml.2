Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab1GLKe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:34:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab1GLKez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:34:55 -0400
Date: Tue, 12 Jul 2011 12:34:53 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Curt Wohlgemuth <curtw@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110712103453.GC31226@quack.suse.cz>
References: <BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
 <20110629081155.GA5558@infradead.org>
 <20110629165714.GF17590@quack.suse.cz>
 <20110629175534.GA32236@infradead.org>
 <20110629191518.GA23196@quack.suse.cz>
 <BANLkTinndb4oHi6kNQrTsL86UrKDB=2rK6-gA8FM1Nj8CKYZ+w@mail.gmail.com>
 <20110711170042.GE5482@quack.suse.cz>
 <CAO81RMairX_L5qGOcKKpw7gWdcTd2Y+5NL=+BA9EwTCNLCNmLw@mail.gmail.com>
 <20110711194835.GI5482@quack.suse.cz>
 <20110711201157.GA21460@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711201157.GA21460@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11-07-11 16:11:57, Christoph Hellwig wrote:
> On Mon, Jul 11, 2011 at 09:48:35PM +0200, Jan Kara wrote:
> >   Well, they're not exactly cheap (journaling filesystems have to force
> > transaction commits and wait for them) but that does not really matter.
> > The real problem is that to wait for IO completion you need some list of
> > inodes you want to wait for and you can currently get such list only from
> > superblock.
> 
> All block device inodes sit on blockdev_superblock, we got rid of inodes
> without a superblock long time ago.
  Sure, we can easily iterate also blockdev_superblock. What I meant is
that blockdev_superblock will need a special handling since we otherwise
ignore pseudo superblocks...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
