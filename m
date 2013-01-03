Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab3ACHcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 02:32:09 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:50816 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3ACHcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 02:32:07 -0500
Date: Thu, 3 Jan 2013 08:31:55 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Gleb Natapov <gleb@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the kvm tree with the s390 tree
Message-ID: <20130103083155.5cc97c31@mschwide>
In-Reply-To: <20130103120650.a19cea9d14a664893c0a5e30@canb.auug.org.au>
References: <20130103120650.a19cea9d14a664893c0a5e30@canb.auug.org.au>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 13010307-0342-0000-0000-000003D376BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, 3 Jan 2013 12:06:50 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next merge of the kvm tree got conflicts in
> arch/s390/include/asm/irq.h and arch/s390/kernel/irq.c between commit
> bfb048f594d5 ("s390/irq: remove split irq fields from /proc/stat") from
> the s390 tree and commit 7e64e0597fd6 ("KVM: s390: Add a channel I/O
> based virtio transport driver") from the kvm tree.
> 
> I fixed it up (I think - see below) including the following merge fix
> patch and can carry the fix as necessary (more action may be required).
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 3 Jan 2013 12:04:39 +1100
> Subject: [PATCH] KVM: s390: fix for IOINT_VIR name change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/s390/kvm/virtio_ccw.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
> index 1a5aff3..f94a0b1 100644
> --- a/drivers/s390/kvm/virtio_ccw.c
> +++ b/drivers/s390/kvm/virtio_ccw.c
> @@ -745,7 +745,7 @@ static struct ccw_driver virtio_ccw_driver = {
>  	.set_offline = virtio_ccw_offline,
>  	.set_online = virtio_ccw_online,
>  	.notify = virtio_ccw_cio_notify,
> -	.int_class = IOINT_VIR,
> +	.int_class = IRQIO_VIR,
>  };
>  
>  static int __init pure_hex(char **cp, unsigned int *val, int min_digit,

I surprises me a bit that there is only one hunk in the cleanup patch.
I expected three, the above for virtio_ccw.c, one for irq.c and another
for irq.h. I checked the resulting tree which is correct! The merge diff
has a '++' line for irq.c/irq.h:

irq.h:
 +      IRQIO_PCI,
 +      IRQIO_MSI,
++      IRQIO_VIR,
        NMI_NMI,
 -      NR_IRQS,
 +      CPU_RST,

irq.c:
 +      [IRQIO_PCI]  = {.name = "PCI", .desc = "[I/O] PCI Interrupt" },
 +      [IRQIO_MSI]  = {.name = "MSI", .desc = "[I/O] MSI Interrupt" },
++      [IRQIO_VIR]  = {.name = "VIR", .desc = "[I/O] Virtual I/O Devices"},
        [NMI_NMI]    = {.name = "NMI", .desc = "[NMI] Machine Check"},
 +      [CPU_RST]    = {.name = "RST", .desc = "[CPU] CPU Restart"},

Magic ?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

