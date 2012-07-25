Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab2GYLs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:48:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38685 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab2GYLs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:48:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120725104138.GA11098@stefanha-thinkpad.localdomain>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com>
	<500FB1DE.1000100@redhat.com>
	<20120725104138.GA11098@stefanha-thinkpad.localdomain>
Date: Wed, 25 Jul 2012 19:48:24 +0800
Message-ID: <CAKviJvWpiAoAdy2weDrJ8=_baBhfFofGDiZxSt4Do7HMBxE52g@mail.gmail.com>
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
From: Sen Wang <kelvin.xupt@gmail.com>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Wang Sen <senwang@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, JBottomley@parallels.com,
        mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/25 Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>:
> On Wed, Jul 25, 2012 at 10:44:14AM +0200, Paolo Bonzini wrote:
>> Il 25/07/2012 10:29, Wang Sen ha scritto:
>> > When using the commands below to write some data to a virtio-scsi LUN of the
>> > QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu will crash.
>> >
>> >     # sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
>> >     # sudo mount /dev/sdb /mnt
>> >     # dd if=/dev/zero of=/mnt/file bs=1M count=1024
>> >
>> > In current implementation, sg_set_buf is called to add buffers to sg list which
>> > is put into the virtqueue eventually. But there are some HighMem pages in
>> > table->sgl can not get virtual address by sg_virt. So, sg_virt(sg_elem) may
>> > return NULL value. This will cause QEMU exit when virtqueue_map_sg is called
>> > in QEMU because an invalid GPA is passed by virtqueue.
>>
>> Heh, I was compiling (almost) the same patch as we speak. :)
>>
>> I've never seen QEMU crash; the VM would more likely just fail to boot
>> with a panic.  But it's the same bug anyway.
>
> It's not a segfault "crash", I think it hits an abort(3) in QEMU's
> virtio code when trying to map an invalid guest physical address.

How the guest boot fail? I never met this case.

>
> Stefan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
------------------------------------------
Wang Sen
Addr: XUPT,Xi'an,Shaanxi,China
Email: kelvin.xupt@gmail.com
------------------------------------------
