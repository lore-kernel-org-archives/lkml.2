Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0JHHwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:52:23 -0400
Received: from www.tglx.de ([62.245.132.106]:59809 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab0JHHwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:52:22 -0400
Date: Fri, 8 Oct 2010 09:52:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Airlie <airlied@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
In-Reply-To: <alpine.LFD.2.00.1010072329220.3354@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1010080941160.7653@localhost6.localdomain6>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com> <alpine.LFD.2.00.1010072227420.2484@localhost6.localdomain6> <alpine.LFD.2.00.1010072329220.3354@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010, Thomas Gleixner wrote:
  Oct  7 23:21:24 ionos kernel: Console: switching to colour VGA+ 80x25
> Oct  7 23:21:31 ionos kernel: drm: unregistered panic notifier
> Oct  7 23:21:31 ionos kernel: vga_switcheroo: disabled
> Oct  7 23:21:31 ionos kernel: [drm:drm_mm_takedown] *ERROR* Memory manager not clean. Delaying takedown
> 
> That one scares me :)
> 
> Oct  7 23:21:32 ionos kernel: BUG: unable to handle kernel paging request at 00000037362e313a
> 
> We are again dereferencing a user space address.

Further debugging shows that the interrupt is torn down and the
vectors are cleared. On modprobe the irq is set up again and a
different vector is assigned.

The interrupt which comes in is going to the old vector. So something
is stale in the card.

Thanks,

	tglx
