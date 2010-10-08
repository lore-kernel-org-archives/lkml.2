Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab0JHLx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 07:53:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:14460 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835Ab0JHLx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 07:53:28 -0400
Message-Id: <89k83a$9u8ggv@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,302,1283756400"; 
   d="scan'208";a="333726239"
Date: Fri, 08 Oct 2010 12:53:23 +0100
To: Thomas Gleixner <tglx@linutronix.de>, Dave Airlie <airlied@gmail.com>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com> <alpine.LFD.2.00.1010072227420.2484@localhost6.localdomain6> <alpine.LFD.2.00.1010072329220.3354@localhost6.localdomain6>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <alpine.LFD.2.00.1010072329220.3354@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010 23:35:43 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> The first test worked fine. But after I added some debugging I got
> another weird corruption this time on the first unload:
> 
> Oct  7 23:21:24 ionos kernel: Console: switching to colour VGA+ 80x25
> Oct  7 23:21:31 ionos kernel: drm: unregistered panic notifier
> Oct  7 23:21:31 ionos kernel: vga_switcheroo: disabled
> Oct  7 23:21:31 ionos kernel: [drm:drm_mm_takedown] *ERROR* Memory manager not clean. Delaying takedown
> 
> That one scares me :)

That was a leak of the object handles which should have been fixed in
.36-rc2

The other horrible crashes look like the set of unload fixes that Daniel
Vetter supplied for .36-rc3 but we postponed to .37.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
