Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760369Ab0HLQIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:08:35 -0400
Received: from verein.lst.de ([213.95.11.210]:47538 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0HLQIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:08:34 -0400
Date: Thu, 12 Aug 2010 18:08:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] BLOCK: fix bio.bi_rw handling
Message-ID: <20100812160809.GC28689@lst.de>
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz> <1281616266-4709-3-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281616266-4709-3-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 02:31:06PM +0200, Jiri Slaby wrote:
> Return of the bi_rw tests is no longer bool after commit 74450be1. But
> results of such tests are stored in bools. This doesn't fit in there
> for some compilers (gcc 4.5 here), so either use !! magic to get real
> bools or use ulong where the result is assigned somewhere.

I'd have to look at my copy of the C standard if it's guaranteed, but
at least currently the values just get truncated down and bool still
is set to true.  I'd much prefer just making these flags unsigned longs
instead of adding syntactic surage to make them true bools.

