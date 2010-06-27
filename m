Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab0F0Pgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 11:36:41 -0400
Received: from verein.lst.de ([213.95.11.210]:44548 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205Ab0F0Pgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 11:36:39 -0400
Date: Sun, 27 Jun 2010 17:35:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hch@lst.de,
       axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request payload
Message-ID: <20100627153545.GC25667@lst.de>
References: <20100627185927K.fujita.tomonori@lab.ntt.co.jp> <20100627193253P.fujita.tomonori@lab.ntt.co.jp> <20100627110712.GA14511@lst.de> <20100627212952D.fujita.tomonori@lab.ntt.co.jp> <20100627141638.GD3970@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100627141638.GD3970@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 10:16:40AM -0400, Mike Snitzer wrote:
> My leak fixes have been tested extensively against all permuations of
> devices with discards (ATA trim, SCSI UNMAP, SCSI WRTIE SAME w/ unmap=1).
> 
> I think we need to get Christoph's discard payload transformation
> complete by fixing the leaks _without_ trying to rework how discard
> commands are tagged, etc.  E.g. fix what Jens already has staged in
> linux-2.6-block's 'for-next' and 'for-2.6.36'.
> 
> With that sorted out we can then look at longer term changes to cleanup
> discard request processing.

I tend to agree.  I'll look into getting rid of treating discards as
BLOCK_PC commands ontop of you patchset.
