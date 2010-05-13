Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965Ab0EMPOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:14:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab0EMPOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:14:31 -0400
Date: Thu, 13 May 2010 11:14:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/4] Btrfs: add basic DIO read/write support V3
Message-ID: <20100513151429.GA16916@infradead.org>
References: <20100512204052.GD3597@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512204052.GD3597@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 04:40:53PM -0400, Josef Bacik wrote:
> V1->V2
> -Use __blockdev_direct_IO instead of helper
> -Use KM_IRQ0 for kmap instead of KM_USER0

I still don't think this is correct.  The completion can come from
softirq and hardirq context, and possibly even normal process context.
You either need to check for all these, or you need to use the generic
complete in user context helper btrfs has available for other types
of I/O.

