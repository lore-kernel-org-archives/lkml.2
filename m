Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab2K1Q0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:26:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50136 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2K1Q0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:26:50 -0500
Date: Wed, 28 Nov 2012 11:26:48 -0500 (EST)
Message-Id: <20121128.112648.12434052000954493.davem@davemloft.net>
To: mst@redhat.com
Cc: asias@redhat.com, rusty@rustcorp.com.au, hch@infradead.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-blk: Add vhost-blk support v5
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121126151416.GB21016@redhat.com>
References: <1353315222-27685-1-git-send-email-asias@redhat.com>
	<20121119202641.GB12283@redhat.com>
	<20121126151416.GB21016@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 26 Nov 2012 17:14:16 +0200

> On Mon, Nov 19, 2012 at 10:26:41PM +0200, Michael S. Tsirkin wrote:
>> > 
>> > Userspace bits:
>> > -----------------------------
>> > 1) LKVM
>> > The latest vhost-blk userspace bits for kvm tool can be found here:
>> > git@github.com:asias/linux-kvm.git blk.vhost-blk
>> > 
>> > 2) QEMU
>> > The latest vhost-blk userspace prototype for QEMU can be found here:
>> > git@github.com:asias/qemu.git blk.vhost-blk
>> > 
>> > Changes in v5:
>> > - Do not assume the buffer layout
>> > - Fix wakeup race
>> > 
>> > Changes in v4:
>> > - Mark req->status as userspace pointer
>> > - Use __copy_to_user() instead of copy_to_user() in vhost_blk_set_status()
>> > - Add if (need_resched()) schedule() in blk thread
>> > - Kill vhost_blk_stop_vq() and move it into vhost_blk_stop()
>> > - Use vq_err() instead of pr_warn()
>> > - Fail un Unsupported request
>> > - Add flush in vhost_blk_set_features()
>> > 
>> > Changes in v3:
>> > - Sending REQ_FLUSH bio instead of vfs_fsync, thanks Christoph!
>> > - Check file passed by user is a raw block device file
>> > 
>> > Signed-off-by: Asias He <asias@redhat.com>
>> 
>> Since there are files shared by this and vhost net
>> it's easiest for me to merge this all through the
>> vhost tree.
> 
> Hi Dave, are you ok with this proposal?

I have no problems with this, for networking parts:

Acked-by: David S. Miller <davem@davemloft.net>
