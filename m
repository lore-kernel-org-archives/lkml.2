Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab0EMRxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:53:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758718Ab0EMRxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:53:08 -0400
Date: Thu, 13 May 2010 14:01:37 -0400
From: Josef Bacik <josef@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 4/4] Btrfs: add basic DIO read/write support V3
Message-ID: <20100513180137.GH27011@dhcp231-156.rdu.redhat.com>
References: <20100512204052.GD3597@localhost.localdomain> <20100513151429.GA16916@infradead.org> <20100513153145.GE27011@dhcp231-156.rdu.redhat.com> <20100513152639.GA30954@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513152639.GA30954@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 11:26:39AM -0400, Christoph Hellwig wrote:
> On Thu, May 13, 2010 at 11:31:45AM -0400, Josef Bacik wrote:
> > AIO's aio_complete does kmap with KM_IRQ0/1 and it gets called in the same
> > context as the btrfs completion handler, so if it's ok for aio_complete it
> > should be ok for btrfs right?  Thanks,
> 
> aio_complete does a spin_lock_irqsave before that, which disables
> interrupts on the local CPU.
> 

Ok how about I just do

local_irq_disable()
kmap(KM_IRQ0)
local_irq_enable()

would that be acceptable?  Thanks,

Josef
