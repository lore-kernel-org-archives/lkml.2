Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0JSX6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:58:45 -0400
Received: from relay3.sgi.com ([192.48.152.1]:48570 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751990Ab0JSX6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:58:44 -0400
Date: Tue, 19 Oct 2010 16:58:42 -0700
From: Arthur Kepner <akepner@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC/PATCHv2] x86/irq: round-robin distribution of irqs to
	cpus w/in node
Message-ID: <20101019235842.GH2440@sgi.com>
References: <20100927203448.GC30050@sgi.com> <alpine.LFD.2.00.1009272236430.2416@localhost6.localdomain6> <20100927220113.GD30050@sgi.com> <alpine.LFD.2.00.1009280003300.2416@localhost6.localdomain6> <m1hbhalo1o.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1009280957150.2416@localhost6.localdomain6> <m1eicennfu.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1010171201410.2496@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010171201410.2496@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 12:44:07PM +0200, Thomas Gleixner wrote:
> ....
> Looked a bit deeper into the users. Quite a bunch do
> 
>        pci_enable_msix();
>        request_irqs();
> 
> in their probe function. There is no sign of making them per cpu or
> node. mlx4 is one of them. No sign of anything related to nodes or cpus in
> the whole driver.
> 
> Even if the driver does not request the irqs from the probe function,
> why does it need to do the msi/msix setup in the probe function at
> all?
> 
> Wouldn't it be sufficient to do that at open() right before the
> interrupts are requested.

That's a good point.

> .....
> The fundamental flaw of arch_setup_msi_irqs() is 
> 
>   node = dev_to_node(&dev->dev);
> 
> That's the only node information we get. So we put everything on a
> single node.
>

But it's even worse than that, because we put everything on a single 
cpu within the node until no vectors are left there, then move on to the 
next one...

-- 
Arthur
