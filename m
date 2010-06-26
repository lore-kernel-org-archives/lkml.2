Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab0FZKQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 06:16:33 -0400
Received: from verein.lst.de ([213.95.11.210]:37744 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab0FZKQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 06:16:31 -0400
Date: Sat, 26 Jun 2010 12:16:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Vivek Goyal <vgoyal@redhat.com>,
       Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100626101613.GA27972@lst.de>
References: <20100621110436.GA4056@lst.de> <4C1FB5F7.3070908@kernel.dk> <20100621191410.GA24213@lst.de> <20100621213618.GC6474@redhat.com> <20100623100138.GA9575@lst.de> <20100624014420.GB3297@redhat.com> <20100625110319.GA12855@lst.de> <20100626092556.GH29809@laptop> <20100626092759.GA25896@lst.de> <20100626101045.GJ29809@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100626101045.GJ29809@laptop>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 08:10:45PM +1000, Nick Piggin wrote:
> But I'm sure apps can submit fsyncs much faster than once per
> few ms, like small database transactions.

fsync / O_SYNC should be irrelevant for the idling logic.  One those
retourn to the user data must have made it to the disk, and with our
barrier implementation that implies fully draining any outstanding I/O
on the device.
