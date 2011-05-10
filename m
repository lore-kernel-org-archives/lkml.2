Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab1EJQSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 12:18:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:41117 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab1EJQSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 12:18:42 -0400
Date: Tue, 10 May 2011 18:18:36 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>, Theodore Tso <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [PATCHSET v3.1 0/7] data integrity: Stabilize pages during
 writeback for various fses
Message-ID: <20110510161836.GL4402@quack.suse.cz>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
 <87tyd31fkc.fsf@devron.myhome.or.jp>
 <20110510133603.GA5823@infradead.org>
 <874o524q9h.fsf@devron.myhome.or.jp>
 <20110510144939.GI4402@quack.suse.cz>
 <87aaeur31x.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aaeur31x.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-05-11 00:24:58, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> Isn't it reallocated blocks too, and metadata too?
> >   Reallocated blocks - not really. For a block to be freed it cannot be
> > under writeback and when it's freed no writeback is started.
> 
> Sure for data -> data reallocated case. metadata -> data/metadata is
> still there.
  Unless you properly use bforget() (which you should I think). But I have
not really checked this in detail for a while.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
