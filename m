Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab1FBB55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 21:57:57 -0400
Received: from ozlabs.org ([203.10.76.45]:48241 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab1FBB54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 21:57:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark Wu <dwu@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Wu <dwu@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
In-Reply-To: <1306913069-23637-1-git-send-email-dwu@redhat.com>
References: <1306913069-23637-1-git-send-email-dwu@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 02 Jun 2011 09:27:23 +0930
Message-ID: <87mxi1xfz0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Jun 2011 03:24:29 -0400, Mark Wu <dwu@redhat.com> wrote:
> Current index allocation in virtio-blk is based on a monotonically
> increasing variable "index". It could cause some confusion about disk
> name in the case of hot-plugging disks. And it's impossible to find the
> lowest available index by just maintaining a simple index. So it's
> changed to use ida to allocate index via referring to the index
> allocation in scsi disk.
> 
> Signed-off-by: Mark Wu <dwu@redhat.com>

Hi Mark,

   I don't believe that we do disk probes in parallel, so the spinlock
is unnecessary.  Otherwise, this looks good.

Thanks,
Rusty.
