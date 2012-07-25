Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2GYKGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 06:06:05 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:33859 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab2GYKGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 06:06:03 -0400
Date: Wed, 25 Jul 2012 11:05:39 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Wang Sen <senwang@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, pbonzini@redhat.com,
        mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
Message-ID: <20120725100539.GB10075@stefanha-thinkpad.localdomain>
References: <1343203219-19190-1-git-send-email-senwang@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343203219-19190-1-git-send-email-senwang@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12072510-4966-0000-0000-0000030A90C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 04:00:19PM +0800, Wang Sen wrote:
> When using the commands below to write some data to a virtio-scsi LUN of the 
> QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu will crash.
> 
> 	# sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
> 	# sudo mount /dev/sdb /mnt
> 	# dd if=/dev/zero of=/mnt/file bs=1M count=1024
> 
> In current implementation, sg_set_buf is called to add buffers to sg list which
> is put into the virtqueue eventually. But there are some HighMem pages in 
> table->sgl can not get virtual address by sg_virt. So, sg_virt(sg_elem) may
> return NULL value. This will cause QEMU exit when virtqueue_map_sg is called 
> in QEMU because an invalid GPA is passed by virtqueue.
> 
> My solution is using sg_set_page instead of sg_set_buf.
> 
> I have tested the patch on my workstation. QEMU would not crash any more.
> 
> Signed-off-by: Wang Sen <senwang@linux.vnet.ibm.com>
> ---
>  drivers/scsi/virtio_scsi.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

