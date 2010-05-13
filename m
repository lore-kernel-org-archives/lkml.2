Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024Ab0EMPXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:23:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab0EMPXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:23:15 -0400
Date: Thu, 13 May 2010 11:31:45 -0400
From: Josef Bacik <josef@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 4/4] Btrfs: add basic DIO read/write support V3
Message-ID: <20100513153145.GE27011@dhcp231-156.rdu.redhat.com>
References: <20100512204052.GD3597@localhost.localdomain> <20100513151429.GA16916@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513151429.GA16916@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 11:14:30AM -0400, Christoph Hellwig wrote:
> On Wed, May 12, 2010 at 04:40:53PM -0400, Josef Bacik wrote:
> > V1->V2
> > -Use __blockdev_direct_IO instead of helper
> > -Use KM_IRQ0 for kmap instead of KM_USER0
> 
> I still don't think this is correct.  The completion can come from
> softirq and hardirq context, and possibly even normal process context.
> You either need to check for all these, or you need to use the generic
> complete in user context helper btrfs has available for other types
> of I/O.
> 

AIO's aio_complete does kmap with KM_IRQ0/1 and it gets called in the same
context as the btrfs completion handler, so if it's ok for aio_complete it
should be ok for btrfs right?  Thanks,

Josef
