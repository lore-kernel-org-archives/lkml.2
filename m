Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab0DTC34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 22:29:56 -0400
Received: from ozlabs.org ([203.10.76.45]:37420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab0DTC3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 22:29:55 -0400
Date: Tue, 20 Apr 2010 12:26:15 +1000
From: Anton Blanchard <anton@samba.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix regression in O_DIRECT|O_SYNC writes to block
 devices
Message-ID: <20100420022615.GM11751@kryten>
References: <20100415044039.GJ11751@kryten>
 <20100415104224.GA27482@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415104224.GA27482@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi,

> Actually you can just drop this call entirely.  sync_blockdev is an
> overcomplicated alias for filemap_write_and_wait on the  block device
> inode, which is exactl what we did just before calling into ->fsync
> 
> It might be worth to still drop i_mutex for the cache flush, though.

Thanks for the feedback Jan + Christoph. New patch on the way.

Anton
