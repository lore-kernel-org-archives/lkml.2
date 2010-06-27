Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab0F0Jip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 05:38:45 -0400
Received: from verein.lst.de ([213.95.11.210]:34937 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab0F0Jin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 05:38:43 -0400
Date: Sun, 27 Jun 2010 11:38:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, dm-devel@redhat.com,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request payload
Message-ID: <20100627093823.GC12016@lst.de>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277582211-10725-1-git-send-email-snitzer@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 03:56:50PM -0400, Mike Snitzer wrote:
> Fix leaks introduced via "block: don't allocate a payload for discard
> request" commit a1d949f5f44.
> 
> sd_done() is not called for REQ_TYPE_BLOCK_PC commands so cleanup
> discard request's payload directly in scsi_finish_command().
> 
> Also cleanup page allocated for discard payload in
> scsi_setup_discard_cmnd's scsi_setup_blk_pc_cmnd error path.

This looks good - I've tested an equivalent patch doing xfstests runs
for more than 24hours now without seeing leaks.

On the long run I'd prefer not having the knowledge of the payload
freeing inside the core scsi code, but that requires either calling
->done for block pc requests, or treating discards as fs requests all
the way, which will require much larger changes.

So for now:


Reviewed-by: Christoph Hellwig <hch@lst.de>

