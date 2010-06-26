Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab0FZL4v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 07:56:51 -0400
Received: from verein.lst.de ([213.95.11.210]:43356 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab0FZL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 07:56:49 -0400
Date: Sat, 26 Jun 2010 13:56:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, czoccolo@gmail.com
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100626115632.GA31209@lst.de>
References: <20100621110436.GA4056@lst.de> <4C1FB5F7.3070908@kernel.dk> <20100621191410.GA24213@lst.de> <20100621213618.GC6474@redhat.com> <20100623100138.GA9575@lst.de> <20100624014420.GB3297@redhat.com> <20100625110319.GA12855@lst.de> <20100626033509.GA2435@redhat.com> <20100626100526.GA27159@lst.de> <20100626112054.GA30661@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100626112054.GA30661@kernel.dk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 01:20:55PM +0200, Jens Axboe wrote:
> The whole idling/anticipation is all about knowing when to
> stall the queue very briefly for sync io, allowing that single
> sync stream to make good progress for a while before switching
> to something else. This switching back and forth potentially
> destroyes throughput for the O_DIRECT writer, especially for
> disks with write through caching.
> 
> Christoph, you seem not to agree on the concept of idling.

I'm still trying to understand the use case.  Basically CFQ gets
worse results for any workload I'm looking at, be that from the
filesystem developer point of view, or virtualization point of
view.  And it tends to get worse the more intelligence is added
to CFQ.

If we could actually narrow down what it's supposed to help
with into useful benchmarks that can be trivially reproduced a
lot of things would be easier.

