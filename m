Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1AHOII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 09:08:08 -0500
Received: from mail-vw0-f66.google.com ([209.85.212.66]:45893 "EHLO
	mail-vw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab1AHOIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 09:08:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qUDxX4rLTZ9AAvicMzwesRyNu3iDxUTYMCf7o5oPl507X8+yATFZ6ZME76H2lHBF4x
         nvXos5jLJp+5zO7ugh4qOqpANMmLExdaVKFuGqutt+aUe0NCY8usPC7c1Y0wy4F/gWTD
         L0RdZbO7mb5NG52Cmt06MggDcvNpw3QubMRXQ=
Date: Sat, 8 Jan 2011 09:08:01 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Ted Ts'o" <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Neil Brown <neilb@suse.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
        dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
        linux-ext4@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
        Josef Bacik <josef@redhat.com>
Subject: Re: Patch to issue pure flushes directly (Was: Re: [PATCH v6 0/4]
 ext4: Coordinate data-only flush requests sent) by fsync
Message-ID: <20110108140801.GB13269@mtj.dyndns.org>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
 <20101130164124.GA30858@lst.de>
 <20110107235449.GT21922@thunk.org>
 <20110108074524.GA13024@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110108074524.GA13024@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jan 08, 2011 at 08:45:24AM +0100, Christoph Hellwig wrote:
> On Fri, Jan 07, 2011 at 06:54:49PM -0500, Ted Ts'o wrote:
> > This patch seemed like a good idea to me; I just checked linux-next,
> > and looks like nothing like this is planned to be merged.  Just
> > thought I would send a prod-o-gram to see what the current thinking
> > was around adding something like this.
> 
> I haven't really gotten any feedback on the patch, so it fell on the
> floor for a while.  I've managed to get some big system resources to
> test the impact of it, and once I've got numbers I'll resend it as
> separate patches for scsi and the block layer.

But would it actually make any difference?  It's not like the usual
completion path in the optimized case is much longer.  It will set all
the skip bits, try to determine the next step which is completion and
then complete the flush request.  It'll sure occupy the CPU for a
little bit longer but I don't think it will be anything measureable.
Is there a workload that this can actually help?

Thanks.

-- 
tejun
