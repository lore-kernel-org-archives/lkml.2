Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1BHJSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 04:18:00 -0500
Received: from smtp.citrix.com ([66.165.176.89]:55920 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab1BHJR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 04:17:58 -0500
X-IronPort-AV: E=Sophos;i="4.60,441,1291611600"; 
   d="scan'208";a="12417974"
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <20110205200108.921707839@linutronix.de>
References: <20110205200108.921707839@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Mon, 7 Feb 2011 21:56:51 +0000
Message-ID: <1297115811.2959.395.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-02-05 at 20:08 +0000, Thomas Gleixner wrote: 
> Jeremy,
> 
> the following series converts the interrupt chips of XEN to the new
> chip functions and the last patches replace the xen private resume
> hackery.
> 
> The first two patches have no dependencies.
> 
> The last two need the modification to the generic interrupt layer. I
> could either carry them through the genirq tree with your
> acked-tested-whatever-by or I provide you a branch to pull that change
> from. I need the genirq change local as it conflicts with other patches
> in the pipeline. Either way works fine.

I definitely like IRQF_FORCE_RESUME bits, clearly much better than the
current solution.

I applied the complete series applied on top of current Linus tree (with
fixlet from my reply to 2/4 and a little reject fixup in irq.h from
3/4). 

It appears that with all 4 patches applied IPIs aren't getting
resumed/unmasked/something else after a migration.

Adding an irq_enable hook to the relevant irq_chip didn't fix it and I
didn't get a chance to dig any deeper this evening.

I'll look a bit closer tomorrow and get back to you.

Ian. 

