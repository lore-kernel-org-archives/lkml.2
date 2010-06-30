Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab0F3KnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 06:43:03 -0400
Received: from verein.lst.de ([213.95.11.210]:40664 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab0F3KnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 06:43:00 -0400
Date: Wed, 30 Jun 2010 12:41:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>,
       Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request payload
Message-ID: <20100630104155.GA1370@lst.de>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-1-git-send-email-snitzer@redhat.com> <1277652576.4366.19.camel@mulgrave.site> <4C2B012B.2000407@panasas.com> <20100630084204.GA27609@lst.de> <4C2B1B7D.2090607@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2B1B7D.2090607@panasas.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 01:25:01PM +0300, Boaz Harrosh wrote:
> OK, Thanks, I see. Is it one of these operations, (like we have in OSD) where
> the CDB information spills into the payload? like the scatter-gather and extent
> lists and such.

For UNMAP the payload is a list of block number / length pairs, while
the CDB itself doesn't contain any information like that.  It's a rather
awkward command.

> Do we actually use a WRITE_SAME which is not zero? for what use?

The kernel doesn't issue any WRITE SAME without the unmap bit set.
