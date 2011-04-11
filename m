Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1DKSZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:25:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab1DKSZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:25:53 -0400
Date: Mon, 11 Apr 2011 14:25:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Layton <jlayton@redhat.com>, djwong <djwong@us.ibm.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Joel Becker <jlbec@evilplan.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Message-ID: <20110411182541.GA29511@infradead.org>
References: <20110308045626.GD1956@dastard>
 <20110319000755.GD1110@tux1.beaverton.ibm.com>
 <20110321140451.GA7153@quack.suse.cz>
 <1300716666-sup-2087@think>
 <20110321164305.GC7153@quack.suse.cz>
 <20110406232938.GF1110@tux1.beaverton.ibm.com>
 <20110407165700.GB7363@quack.suse.cz>
 <20110408203135.GH1110@tux1.beaverton.ibm.com>
 <20110411124229.47bc28f6@corrin.poochiereds.net>
 <1302543595-sup-4352@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302543595-sup-4352@think>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 01:41:16PM -0400, Chris Mason wrote:
> Actually this isn't a nit.  Keeping the page locked closes an important
> hole where it can become writeback again.  It might fix the last
> remaining problem.

Note that the generic block_page_mkwrite atually does that.  But only
xfs and nilfs2 actually make use of it.

