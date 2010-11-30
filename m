Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0K3Qnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:43:37 -0500
Received: from verein.lst.de ([213.95.11.210]:46034 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab0K3Qnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:43:35 -0500
Date: Tue, 30 Nov 2010 17:43:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Neil Brown <neilb@suse.de>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Jens Axboe <axboe@kernel.dk>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
        dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
        Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v6 0/4] ext4: Coordinate data-only flush requests sent by fsync
Message-ID: <20101130164301.GB30858@lst.de>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com> <20101130113906.176ffcad@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130113906.176ffcad@notabene.brown>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 11:39:06AM +1100, Neil Brown wrote:
> Would it not be sufficient to simply gather flushes while a flush is pending.
> i.e
>   - if no flush is pending, set the 'flush pending' flag, submit a flush,
>     then clear the flag.
>   - if a flush is pending, then wait for it to complete, and then submit a
>     single flush on behalf of all pending flushes.
>
> That way when flush is fast, you do a flush every time, and when it is slow
> you gather multiple flushes together.

We can even optimize the second flush away if no other I/O has
completed since the first flush has started.  That will always be the
case for SATA devices as the cache flush command is not queued.

