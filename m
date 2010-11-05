Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0KEVKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 17:10:45 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42464 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab0KEVKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 17:10:43 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2010 17:10:43 EDT
Date: Fri, 5 Nov 2010 22:04:54 +0100
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>, Neil Brown <neilb@suse.de>,
        drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] [PATCH] block: read i_size with i_size_read()
Message-ID: <20101105210454.GE2321@barkeeper1-xen.linbit>
Mail-Followup-To: Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jens Axboe <jaxboe@fusionio.com>, Neil Brown <neilb@suse.de>,
	drbd-dev@lists.linbit.com
References: <1288985241-3515-1-git-send-email-snitzer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288985241-3515-1-git-send-email-snitzer@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 03:27:21PM -0400, Mike Snitzer wrote:
> Convert direct reads of an inode's i_size to using i_size_read().
> 
> i_size_{read,write} use a seqcount to protect reads from accessing
> incomple writes.  Concurrent i_size_write()s require mutual exclussion
> to protect the seqcount that is used by i_size_{read,write}.  But
> i_size_read() callers do not need to use additional locking.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: drbd-dev@lists.linbit.com
> ---
>  block/blk-core.c              |    4 ++--
>  block/compat_ioctl.c          |    4 ++--
>  block/ioctl.c                 |    6 +++---
>  drivers/block/drbd/drbd_int.h |    2 +-
>  drivers/md/md.c               |   18 +++++++++---------
>  5 files changed, 17 insertions(+), 17 deletions(-)

DRBD one line fix trivially
  Acked-by: Lars Ellenberg <lars.ellenberg@linbit.com>


> NOTE: I stopped short of fixing drbd and nbd to use revalidate_disk
> and/or i_size_write.

Ok, we'll pick up the DRBD part of it.

-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
