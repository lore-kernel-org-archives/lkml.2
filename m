Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab1BJXd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:33:59 -0500
Received: from www.tglx.de ([62.245.132.106]:58869 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844Ab1BJXd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:33:58 -0500
Date: Fri, 11 Feb 2011 00:33:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Daney <ddaney@caviumnetworks.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: Call chip_bus_lock()/chip_bus_sync_unlock() in
 setup_irq().
In-Reply-To: <1297296265-18680-1-git-send-email-ddaney@caviumnetworks.com>
Message-ID: <alpine.LFD.2.00.1102110029170.31804@localhost6.localdomain6>
References: <1297296265-18680-1-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011, David Daney wrote:

> irq_chips that supply .irq_bus_lock/.irq_bus_sync_unlock functions,
> expect that the other chip methods will be called inside of calls to
> the pair.  If this expectation is not met, things tend to not work.
> 
> Make setup_irq() call chip_bus_lock()/chip_bus_sync_unlock() too.
> 
> For the vast majority of irq_chips, this will be a NOP as most don't
> have these bus lock functions.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>

Ralf,

please pull that change from

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/for-mips

so you can apply David's patches which depend on that one.

That's 38-rc4 based w/o any other changes to the core code. I pull
that into irq/core so we have no dependecies or collision for Linus.

Thanks,

	tglx
