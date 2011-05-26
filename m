Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab1EZFf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:35:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34826 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab1EZFf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YkyvkXU8/RgaDCcSF0bfaoIjFW/viU1LZ1wHegm8hgKx1F5e9dVlhf/15AUonObANV
         68vksPzWt+Gp7rf+yq8z/HCAQ6+tAURLqdoBm4S6WcMOK9JoIjoiLnaODFgpf/mvpEPy
         BT3CiyVis31eBzMHKSUey9fK4NUYUuLR9SOfI=
Subject: Re: [GIT PULL] Core block bits for 2.6.40
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>, Tao Ma <boyu.mt@taobao.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4DDCFE21.80003@fusionio.com>
References: <4DDCFE21.80003@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 07:35:53 +0200
Message-ID: <1306388153.2664.4.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 25 mai 2011 à 15:03 +0200, Jens Axboe a écrit :
> Hi Linus,
> 
> A real pull request this time. These are the core bits for the next
> kernel. Nothing exciting in here in this round, with the churn in
> the last release, this release will be mellow.
> 
> - Optimizations for queue flushing on SATA devices, where we
>   can't queue a FLUSH command. This fixes up a performance regression
>   caused by a bug fix to prevent potential live lock on adding
>   FLUSH commands at the head of the queue.
> 
> - Make stats lockless for blk-cgroup.
> 
> - Various bug fixes for blk-cgroup.
> 
> - Various little fixes and improvements to CFQ.
> 
> - Last round of media event changes.
> 
> - Fixes for discard topology reporting and sysfs documentation update
>   for the same.
> 
> - Add support for batched discards. This greatly speeds up discarding
>   an entire device.
> 
> - Fix for bad return value in the discard ioctl.
> 
> - Remove request plug state debug checks. Haven't triggered even during
>   the 2.6.39-rc devel cycle, so get rid of them.
> 
> 
> Please pull!
> 
> 
>   git://git.kernel.dk/linux-2.6-block.git for-2.6.40/core
> 

> Tao Ma (2):
>       block: Remove 'plug/unplug' comment in blk_execute_rq_nowait
>       block: Remove extra discard_alignment from hd_struct.

At boot, I have a crash in part_discard_alignment_show+0x1b/0x50

CR2 : 000006ac

fault in : mov    0x2c(%rcx),%edx

I suspect commit 23ceb5b7719e9276d4 (block: Remove extra
discard_alignment from hd_struct) being in fault



