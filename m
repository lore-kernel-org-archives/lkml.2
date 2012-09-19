Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2ISNzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:55:07 -0400
Received: from smtp.tele.fi ([192.89.123.25]:48186 "EHLO
	vulpes-int.media.sonera.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754106Ab2ISNzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:55:03 -0400
X-Greylist: delayed 2307 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2012 09:55:03 EDT
X-Originating-Ip: [194.89.68.22]
Date: Wed, 19 Sep 2012 16:16:32 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Oliver Chick <oliver.chick@citrix.com>
Cc: xen-devel@lists.xen.org, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
Message-ID: <20120919131632.GS8912@reaktio.net>
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 11:51:27AM +0100, Oliver Chick wrote:
> This patch implements persistent grants for the xen-blk{front,back}
> mechanism. The effect of this change is to reduce the number of unmap
> operations performed, since they cause a (costly) TLB shootdown. This
> allows the I/O performance to scale better when a large number of VMs
> are performing I/O.
> 
> Previously, the blkfront driver was supplied a bvec[] from the request
> queue. This was granted to dom0; dom0 performed the I/O and wrote
> directly into the grant-mapped memory and unmapped it; blkfront then
> removed foreign access for that grant. The cost of unmapping scales
> badly with the number of CPUs in Dom0. An experiment showed that when
> Dom0 has 24 VCPUs, and guests are performing parallel I/O to a
> ramdisk, the IPIs from performing unmap's is a bottleneck at 5 guests
> (at which point 650,000 IOPS are being performed in total). If more
> than 5 guests are used, the performance declines. By 10 guests, only
> 400,000 IOPS are being performed.
> 
> This patch improves performance by only unmapping when the connection
> between blkfront and back is broken.
>

So how many IOPS can you get with this patch / persistent grants ? 

-- Pasi

