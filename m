Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab1BJEhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 23:37:23 -0500
Received: from void.printf.net ([89.145.121.20]:34749 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab1BJEhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 23:37:22 -0500
Date: Thu, 10 Feb 2011 04:37:18 +0000
From: Chris Ball <cjb@laptop.org>
To: Pierre Tardy <pierre.tardy@intel.com>
Cc: linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yunpeng Gao <yunpeng.gao@intel.com>
Subject: Re: [PATCH v2 2/3] sdhci-pci : Enable runtime PM support
Message-ID: <20110210043718.GA7585@void.printf.net>
References: <cover.1297014479.git.pierre.tardy@intel.com> <6722fa7986194808f4d69a1e5ba6d3f163b77da9.1297014479.git.pierre.tardy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6722fa7986194808f4d69a1e5ba6d3f163b77da9.1297014479.git.pierre.tardy@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

On Sun, Feb 06, 2011 at 07:02:49PM +0100, Pierre Tardy wrote:
> From: Yunpeng Gao <yunpeng.gao@intel.com>
> 
> Follow the kernel runtime PM framework, enable runtime PM support of the
> sdhci host controller with pci interface.
> 
> Note that this patch implements runtime_pm but now actually detects
> activity.
> It relies on higher level (childrens) to do actual waking up
> Activity detection is put in following patch

Testing this patchset in linux-next-20100208 gives:

[   10.829223] sdhci: Secure Digital Host Controller Interface driver
[   10.829548] sdhci: Copyright(c) Pierre Ossman
[   10.883906] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 1)
[   10.884533] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.885189] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[   10.886176] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[   10.886819] Registered led device: mmc0::
[   10.887281] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[   10.887724] sdhci-pci 0000:0d:00.0: Unbalanced pm_runtime_enable!
[   10.888498] sdhci-pci 0000:17:00.0: SDHCI controller found [1180:e822] (rev 1)
[   10.889179] sdhci-pci 0000:17:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   10.889876] sdhci-pci 0000:17:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[   10.890924] sdhci-pci 0000:17:00.0: setting latency timer to 64
[   10.891387] Registered led device: mmc1::
[   10.891900] mmc1: SDHCI controller on PCI [0000:17:00.0] using DMA
[   10.892280] sdhci-pci 0000:17:00.0: Unbalanced pm_runtime_enable!

(Note the last line above.)

I then removed the card and reinserted it, but there's no dmesg output
related to the reinsert, only to the card removal:

[   65.381047] mmc0: card d555 removed

So, card insertion is broken.  I then did rmmod sdhci-pci && modprobe
sdhci-pci, and it picked up the card again.

There was also a weird UI hang for a few hundred msecs around the time
the second modprobe happened, but I don't expect you to be able to do
anything about that without a more helpful report; if it happens again
I'll try to record what's going on using ftrace.

Full dmesg is at:
   http://dev.laptop.org/~cjb/logs/runtime-pm-sdhci-20100209.log

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
