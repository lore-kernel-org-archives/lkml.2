Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab0IGWqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 18:46:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33272 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab0IGWqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 18:46:05 -0400
Date: Tue, 7 Sep 2010 15:44:13 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>,
        Linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC 02/22] configfs: Add struct
 configfs_item_operations->check_link() in configfs_unlink()
Message-ID: <20100907224413.GC21935@mail.oracle.com>
Mail-Followup-To: Konrad Rzeszutek Wilk <konrad@darnok.org>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	linux-scsi <linux-scsi@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Mike Christie <michaelc@cs.wisc.edu>,
	Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
	James Bottomley <James.Bottomley@suse.de>,
	Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>,
	Linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <1283160025-6598-1-git-send-email-nab@linux-iscsi.org>
 <20100902064814.GB27904@mail.oracle.com>
 <1283456440.5598.108.camel@haakon2.linux-iscsi.org>
 <201009071701.02847.konrad@darnok.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009071701.02847.konrad@darnok.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 05:01:01PM -0400, Konrad Rzeszutek Wilk wrote:
> > > 	I NAK'd this a while back.  I'm willing to be convinced, but so
> > > far it remains that way.
> >
> > Hi Joel,
> >
> > Thanks for bringing this point up again.  So a brief refresh on why this
> > is currently required in the fabric independent configfs handlers in
> > drivers/target/target_core_fabric_configfs.c (patch #19).
> 
> Well, that is great that you mentioned your requirements. But I don't see a 
> quote of Joel's concerns? Is there an LKML link for it perhaps?

	It was a while back.  Essentially, the concern is that configfs
is defined to be userspace-driven.  If the user asks you to remove
something, the module should be handling safe teardown rather than
rejecting the user's request.
	Now, the world isn't always clean-cut.  Code outside of the
filesystem representation can lay a claim on a configfs item to say "I'm
busy with this."  An example is ocfs2 pinning the configfs item
describing its cluster heartbeat device.   But this is ocfs2 - a
separate thing - claiming it.  There is a defined API to take and
release these claims.
	This API doesn't cover symlinks, as symlinks are simply linkage
between config items.  It may be, as Nick suggested at the bottom of his
reply, that we want the API extended to cover that case.  But he hasn't
yet convinced me that safe teardown is impossible or disasterous.
That's what I'd like to see.  It's not obvious on the face of all the
file trees in the email.
	Nick, can you provide some form of description, not long
pathnames, that explains a) what breaks when the symlink is removed b)
why that can't be allowed if the user is dumb enough to request it?

Joel

-- 

"The lawgiver, of all beings, most owes the law allegiance.  He of all
 men should behave as though the law compelled him.  But it is the
 universal weakness of mankind that what we are given to administer we
 presently imagine we own."
        - H.G. Wells

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
