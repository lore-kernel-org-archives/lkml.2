Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab1FHX1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 19:27:06 -0400
Received: from ozlabs.org ([203.10.76.45]:48477 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011Ab1FHX1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 19:27:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark Wu <dwu@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        tj@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
In-Reply-To: <4DEF744D.9040702@redhat.com>
References: <1306913069-23637-1-git-send-email-dwu@redhat.com> <87mxi1xfz0.fsf@rustcorp.com.au> <4DEF744D.9040702@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 09 Jun 2011 08:51:05 +0930
Message-ID: <87mxhrgba6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jun 2011 09:08:29 -0400, Mark Wu <dwu@redhat.com> wrote:
> Hi Rusty,
> Yes, I can't figure out an instance of disk probing in parallel either, but as
> per the following commit, I think we still need use lock for safety. What's your opinion?
> 
> commit 4034cc68157bfa0b6622efe368488d3d3e20f4e6
> Author: Tejun Heo <tj@kernel.org>
> Date:   Sat Feb 21 11:04:45 2009 +0900
> 
>     [SCSI] sd: revive sd_index_lock
> 
>     Commit f27bac2761cab5a2e212dea602d22457a9aa6943 which converted sd to
>     use ida instead of idr incorrectly removed sd_index_lock around id
>     allocation and free.  idr/ida do have internal locks but they protect
>     their free object lists not the allocation itself.  The caller is
>     responsible for that.  This missing synchronization led to the same id
>     being assigned to multiple devices leading to oops.

I'm confused.  Tejun, Greg, anyone can probes happen in parallel?

If so, I'll have to review all my drivers.

Thanks,
Rusty.

