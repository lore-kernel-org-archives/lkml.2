Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188Ab1B1FeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 00:34:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:30079 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab1B1FeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 00:34:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,238,1297065600"; 
   d="scan'208";a="662018143"
Date: Sun, 27 Feb 2011 21:34:06 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
Subject: Re: 2.6.38 regression caused by commit 415e12b
Message-ID: <20110228053346.GA2223@xanatos>
References: <20110228014218.GA11083@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110228014218.GA11083@xanatos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 05:42:18PM -0800, Sarah Sharp wrote:
> I'm having an issue with an xHCI (USB 3.0 host controller) Express Card.
> This card works fine on 2.6.37, but on 2.6.38-rc5, when I plug in the
> card, I get this output in dmesg:
> 
> Feb 22 16:32:28 xanatos kernel: [  119.345996] irq 23: nobody cared (try booting with the "irqpoll" option)
> Feb 22 16:32:28 xanatos kernel: [  119.346002] Pid: 0, comm: kworker/0:0 Not tainted 2.6.38-rc5+ #745
> Feb 22 16:32:28 xanatos kernel: [  119.346005] Call Trace:
> Feb 22 16:32:28 xanatos kernel: [  119.346007]  <IRQ>  [<ffffffff8109a1f6>] ? __report_bad_irq+0x26/0xa0
> Feb 22 16:32:28 xanatos kernel: [  119.346019]  [<ffffffff8109a3fc>] ? note_interrupt+0x18c/0x1d0
> Feb 22 16:32:28 xanatos kernel: [  119.346024]  [<ffffffff8109ad7d>] ? handle_fasteoi_irq+0xcd/0x100
> Feb 22 16:32:28 xanatos kernel: [  119.346029]  [<ffffffff8100543d>] ? handle_irq+0x1d/0x30
> Feb 22 16:32:28 xanatos kernel: [  119.346032]  [<ffffffff81004bb8>] ? do_IRQ+0x58/0xd0
> Feb 22 16:32:28 xanatos kernel: [  119.346037]  [<ffffffff8149f5d3>] ? ret_from_intr+0x0/0xe
> Feb 22 16:32:28 xanatos kernel: [  119.346040]  <EOI>  [<ffffffff8126f2d0>] ? acpi_idle_enter_c1+0x7e/0x99
> Feb 22 16:32:28 xanatos kernel: [  119.346048]  [<ffffffff8126f2b2>] ? acpi_idle_enter_c1+0x60/0x99
> Feb 22 16:32:28 xanatos kernel: [  119.346054]  [<ffffffff8138ac92>] ? cpuidle_idle_call+0x82/0xf0
> Feb 22 16:32:28 xanatos kernel: [  119.346059]  [<ffffffff81001906>] ? cpu_idle+0x56/0xb0
> Feb 22 16:32:28 xanatos kernel: [  119.346064]  [<ffffffff8149861b>] ? start_secondary+0x1c1/0x1c8
> Feb 22 16:32:28 xanatos kernel: [  119.346068]  [<ffffffff81263386>] ? acpi_ns_parse_table+0x2e/0x34
> Feb 22 16:32:28 xanatos kernel: [  119.346073]  [<ffffffff81267a8c>] ? acpi_load_tables+0x9c/0x15d
> Feb 22 16:32:28 xanatos kernel: [  119.346076] handlers:
> Feb 22 16:32:28 xanatos kernel: [  119.346078] [<ffffffffa0123500>] (usb_hcd_irq+0x0/0x70 [usbcore])
> Feb 22 16:32:28 xanatos kernel: [  119.346100] Disabling IRQ #23
> 
> This happens before the xHCI driver has a chance to start PCI
> initialization.
> 
> I've been trying to bisect this on a slow laptop, so I haven't had a
> chance to test with the latest tree from Linus to see if this is already
> fixed.  I'll do that later this evening.

Still broken on the latest from Linus' tree.

Sarah Sharp
