Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab2GYKwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 06:52:38 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:34217 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab2GYKwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 06:52:37 -0400
Date: Wed, 25 Jul 2012 11:41:38 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org,
        JBottomley@parallels.com, mc@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
Message-ID: <20120725104138.GA11098@stefanha-thinkpad.localdomain>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com>
 <500FB1DE.1000100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500FB1DE.1000100@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12072510-1948-0000-0000-0000027E4987
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 10:44:14AM +0200, Paolo Bonzini wrote:
> Il 25/07/2012 10:29, Wang Sen ha scritto:
> > When using the commands below to write some data to a virtio-scsi LUN of the 
> > QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu will crash.
> > 
> > 	# sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
> > 	# sudo mount /dev/sdb /mnt
> > 	# dd if=/dev/zero of=/mnt/file bs=1M count=1024
> > 
> > In current implementation, sg_set_buf is called to add buffers to sg list which
> > is put into the virtqueue eventually. But there are some HighMem pages in 
> > table->sgl can not get virtual address by sg_virt. So, sg_virt(sg_elem) may
> > return NULL value. This will cause QEMU exit when virtqueue_map_sg is called 
> > in QEMU because an invalid GPA is passed by virtqueue.
> 
> Heh, I was compiling (almost) the same patch as we speak. :)
> 
> I've never seen QEMU crash; the VM would more likely just fail to boot
> with a panic.  But it's the same bug anyway.

It's not a segfault "crash", I think it hits an abort(3) in QEMU's
virtio code when trying to map an invalid guest physical address.

Stefan

