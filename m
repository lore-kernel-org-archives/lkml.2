Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2GYLqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:46:21 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46047 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab2GYLqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:46:19 -0400
MIME-Version: 1.0
In-Reply-To: <ccef753fa6fd0ce145611de514e75018@sf-mail.de>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com>
	<ccef753fa6fd0ce145611de514e75018@sf-mail.de>
Date: Wed, 25 Jul 2012 19:46:18 +0800
Message-ID: <CAKviJvW5w_9_wMazs3HQigosuk+W-iQipb_0pZxr0-bu3xhGbg@mail.gmail.com>
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
From: Sen Wang <kelvin.xupt@gmail.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org,
        jbottomley@parallels.com, pbonzini@redhat.com,
        stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/25 Rolf Eike Beer <eike-kernel@sf-tec.de>:
> Am 25.07.2012 10:29, schrieb Wang Sen:
>
>> When using the commands below to write some data to a virtio-scsi LUN of
>> the
>> QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu
>> will crash.
>>
>>         # sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
>>         # sudo mount /dev/sdb /mnt
>>         # dd if=/dev/zero of=/mnt/file bs=1M count=1024
>>
>> In current implementation, sg_set_buf is called to add buffers to sg
>> list which
>> is put into the virtqueue eventually.
>
>
> The next sentence is somehow broken:
>
>
>> But there are some HighMem pages in
>> table->sgl can not get virtual address by sg_virt.
>
>
> Maybe something like "But _if_ there are ... _you_ can not get ..."?

Thanks, I'll pay attention in next post.

>
> Eike
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
