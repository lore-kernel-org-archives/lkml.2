Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab2FMGmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 02:42:52 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65530 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094Ab2FMGmv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 02:42:51 -0400
MIME-Version: 1.0
In-Reply-To: <CANBwrj_i+VZiV1YFVhBduor5g=03mcM08NF1FteczWvQuCAjhw@mail.gmail.com>
References: <CANBwrj_i+VZiV1YFVhBduor5g=03mcM08NF1FteczWvQuCAjhw@mail.gmail.com>
Date: Wed, 13 Jun 2012 14:42:49 +0800
Message-ID: <CANBwrj_WAqQs+-Jnj+nTBVE-1YuK6XwFeZN6biLGge+9TvZXeg@mail.gmail.com>
Subject: Re: UIO driver multi-instance issue discussion
From: Raymond Wu <wxy412@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: xywu@marvell.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

>
> I'm not sure who is the maintainer for UIO driver. Please help if you know something. Thanks in advance!
>
>
> Recently, we have some trouble when using UIO as our VPU driver.
>
> Issue description:
>
> ·         This issue comes from the so called "multi-instance case". This means that for one H/W device, it can be opened multiple times.
>
> ·         Each instance will be assigned with a FD(file descriptor) and its own uio_listener.
>
> ·         After one H/W interrupt comes, the global uio_device.event has been +1 ( See atomic_inc(&idev->event); ) while all other instance’s uio_listener->event_count is not +1.
>
> ·         So, if we have 1+ instances waiting for interrupt, all of them will be woken up because listener->event_count != event_count.
>
>
>
> Solution:
>
> ·         Export uio_device definition to uio.h or uio_driver.h, so that we can sync the event_count for all instances in the private driver.
>
> ·         Add new uio_sync_event(struct file *filep) function in uio.c, so that we can call it directly when we want to sync the event count.
>
>
>
> Please advise which one is recommended or you can propose a new one. We have a plan to submit a patch to open source community to improve it.
>
>
>
> BTW, personally, I’m curious that why you put the uio_device definition within uio.c, is there any special reason for it?
>
>
>
> Thanks,
> Raymond
