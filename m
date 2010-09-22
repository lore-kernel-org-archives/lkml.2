Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab0IVIyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 04:54:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52833 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0IVIyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 04:54:54 -0400
To: Neeraj Kumar <neeraj.kumar01@ymail.com>
CC: linux-kernel@vger.kernel.org
In-reply-to: <633175.66987.qm@web113411.mail.gq1.yahoo.com> (message from
	Neeraj Kumar on Mon, 20 Sep 2010 13:12:22 -0700 (PDT))
Subject: Re: Doing a zero-copy move of data from a kernel buffer to hard disk
References: <633175.66987.qm@web113411.mail.gq1.yahoo.com>
Message-Id: <E1OyL6H-0002wC-GV@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Sep 2010 10:54:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Neeraj Kumar wrote:
> I am trying to move data from a buffer in kernel space into the hard
> disk without having to incur any additional copies from kernel buffer to
> user buffers or any other kernel buffers. Any ideas/suggestions would be
> most helpful.
> 
> The use case is basically a demux driver which collects data into a
> demux buffer in kernel space and this buffer has to be emptied
> periodically by copying the contents into a FUSE-based partition on the
> disk. As the buffer gets full, a user process is signalled which then
> determines the sector numbers on the disk the contents need to be copied
> to.
> 
> I was hoping to mmap the above demux kernel buffer into user address
> space and issue a write system call to the raw partition device. But
> from what I can see, the this data is being cached by the kernel on its
> way to the Hard Disk driver. And so I am assuming that involves
> additional copies by the linux kernel.

Isn't this functionality already served by relayfs?

> At this point I am wondering if there is any other mechansim to do this
> without involving additional copies by the kernel. I realize this is an
> unsual usage scenario for non-embedded environments, but I would
> appreciate any feedback on possible options.
> 
> BTW - I have tried using O_DIRECT when opening the raw partition, but
> the subsequent write call fails if the buffer being passed is the
> mmapped buffer.

The other zero-copy  mechanism is splice(2).

Thanks,
Miklos
