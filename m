Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061Ab0EMP0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:26:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57807 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759012Ab0EMP0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:26:40 -0400
Date: Thu, 13 May 2010 11:26:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 4/4] Btrfs: add basic DIO read/write support V3
Message-ID: <20100513152639.GA30954@infradead.org>
References: <20100512204052.GD3597@localhost.localdomain> <20100513151429.GA16916@infradead.org> <20100513153145.GE27011@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513153145.GE27011@dhcp231-156.rdu.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 11:31:45AM -0400, Josef Bacik wrote:
> AIO's aio_complete does kmap with KM_IRQ0/1 and it gets called in the same
> context as the btrfs completion handler, so if it's ok for aio_complete it
> should be ok for btrfs right?  Thanks,

aio_complete does a spin_lock_irqsave before that, which disables
interrupts on the local CPU.

