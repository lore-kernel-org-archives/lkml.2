Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab2GDG5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:57:13 -0400
Received: from ozlabs.org ([203.10.76.45]:47483 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972Ab2GDG5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:57:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: allow toggling host cache between writeback and writethrough
In-Reply-To: <1341321577-24435-1-git-send-email-pbonzini@redhat.com>
References: <1341321577-24435-1-git-send-email-pbonzini@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 04 Jul 2012 15:54:26 +0930
Message-ID: <87y5n0ujqd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Jul 2012 15:19:37 +0200, Paolo Bonzini <pbonzini@redhat.com> wrote:
> This patch adds support for the new VIRTIO_BLK_F_CONFIG_WCE feature,
> which exposes the cache mode in the configuration space and lets the
> driver modify it.  The cache mode is exposed via sysfs.
> 
> Even if the host does not support the new feature, the cache mode is
> visible (thanks to the existing VIRTIO_BLK_F_WCE), but not modifiable.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Fixed up some checkpatch warnings for you, too:

virtio:blk_allow_toggling_host_cache_between_writeback_and_writethrough.patch.new:51: WARNING: please, no spaces at the start of a line
#51: FILE: drivers/block/virtio_blk.c:424:
+       revalidate_disk(vblk->disk);$

.virtio:blk_allow_toggling_host_cache_between_writeback_and_writethrough.patch.new:54: WARNING: static const char * array should probably be static const char * const
#54: FILE: drivers/block/virtio_blk.c:427:
+static const char *virtblk_cache_types[] = {

.virtio:blk_allow_toggling_host_cache_between_writeback_and_writethrough.patch.new:160: ERROR: code indent should use tabs where possible
#160: FILE: include/linux/virtio_blk.h:73:
+        /* writeback mode (if VIRTIO_BLK_F_CONFIG_WCE) */$

.virtio:blk_allow_toggling_host_cache_between_writeback_and_writethrough.patch.new:161: ERROR: code indent should use tabs where possible
#161: FILE: include/linux/virtio_blk.h:74:
+        __u8 wce;$

.virtio:blk_allow_toggling_host_cache_between_writeback_and_writethrough.patch.new:161: WARNING: please, no spaces at the start of a line
#161: FILE: include/linux/virtio_blk.h:74:
+        __u8 wce;$

total: 2 errors, 3 warnings, 132 lines checked

Cheers,
Rusty.
