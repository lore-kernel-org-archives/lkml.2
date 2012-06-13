Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab2FMLSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:18:45 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:49466 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab2FMLSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:18:44 -0400
Date: Wed, 13 Jun 2012 13:18:35 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Raymond Wu <wxy412@gmail.com>
Cc: linux-kernel@vger.kernel.org, xywu@marvell.com
Subject: Re: UIO driver multi-instance issue discussion
Message-ID: <20120613111835.GB4763@local>
References: <CANBwrj_i+VZiV1YFVhBduor5g=03mcM08NF1FteczWvQuCAjhw@mail.gmail.com>
 <CANBwrj_WAqQs+-Jnj+nTBVE-1YuK6XwFeZN6biLGge+9TvZXeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANBwrj_WAqQs+-Jnj+nTBVE-1YuK6XwFeZN6biLGge+9TvZXeg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 02:42:49PM +0800, Raymond Wu wrote:
> Hi guys,
> 
> >
> > I'm not sure who is the maintainer for UIO driver. Please help if you know something. Thanks in advance!

Please refer to the MAINTAINERS file in the kernel top level directory.
You can also use the get_maintainer script under scripts/.

UIO maintainers are Greg Kroah-Hartman and myself.

> >
> >
> > Recently, we have some trouble when using UIO as our VPU driver.
> >
> > Issue description:
> >
> > ·         This issue comes from the so called "multi-instance case". This means that for one H/W device, it can be opened multiple times.
> >
> > ·         Each instance will be assigned with a FD(file descriptor) and its own uio_listener.
> >
> > ·         After one H/W interrupt comes, the global uio_device.event has been +1 ( See atomic_inc(&idev->event); ) while all other instance’s uio_listener->event_count is not +1.
> >
> > ·         So, if we have 1+ instances waiting for interrupt, all of them will be woken up because listener->event_count != event_count.
> >

Please post the code of your kernel driver part. It's hard to talk about
that verbal description.

Your driver can be included in the mainline kernel, if you go through the
normal review process, all of these problems will be sorted out.

> >
> >
> > Solution:
> >
> > ·         Export uio_device definition to uio.h or uio_driver.h, so that we can sync the event_count for all instances in the private driver.
> >
> > ·         Add new uio_sync_event(struct file *filep) function in uio.c, so that we can call it directly when we want to sync the event count.
> >
> > Please advise which one is recommended or you can propose a new one. We have a plan to submit a patch to open source community to improve it.
> >
> > BTW, personally, I’m curious that why you put the uio_device definition within uio.c, is there any special reason for it?

Yes, nobody is supposed to fiddle around with it in a driver.
That is very much intentional.

Thanks,
Hans

