Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab2KLQT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:19:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33032 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2KLQTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:19:25 -0500
Message-ID: <50A12182.90305@kernel.dk>
Date: Mon, 12 Nov 2012 09:19:14 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.8
References: <20121109145529.GB23023@phenom.dumpdata.com>
In-Reply-To: <20121109145529.GB23023@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-09 07:55, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please git pull the following branch:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.8
> 
> which has a new feature of the blk[back|front] driver - it is called 'feature-persistent'.
> Roger and Oliver patch says:
> "  This patch implements persistent grants for the xen-blk{front,back}
>     mechanism. The effect of this change is to reduce the number of unmap
>     operations performed, since they cause a (costly) TLB shootdown. This
>     allows the I/O performance to scale better when a large number of VMs
>     are performing I/O.
>     
>     Previously, the blkfront driver was supplied a bvec[] from the request
>     queue. This was granted to dom0; dom0 performed the I/O and wrote
>     directly into the grant-mapped memory and unmapped it; blkfront then
>     removed foreign access for that grant. The cost of unmapping scales
>     badly with the number of CPUs in Dom0. An experiment showed that when
>     Dom0 has 24 VCPUs, and guests are performing parallel I/O to a
>     ramdisk, the IPIs from performing unmap's is a bottleneck at 5 guests
>     (at which point 650,000 IOPS are being performed in total). If more
>     than 5 guests are used, the performance declines. By 10 guests, only
>     400,000 IOPS are being performed.
>     
>     This patch improves performance by only unmapping when the connection
>     between blkfront and back is broken.
> "
> 
> Note: You might get a conflict in the common.h file. It should
> be fairly easy to fix it - it should end up looking as this:
> 
> 160         /* Cached size parameter. */
> 161         sector_t                size;
> 162         unsigned int            flush_support:1;
> 163         unsigned int            discard_secure:1;
> 164         unsigned int            feature_gnt_persistent:1;
> 165         unsigned int            overflow_max_grants:1;
> 166 };
> 
> Thanks!

Thanks, pulled. No conflict observed, it merged cleanly.

-- 
Jens Axboe

