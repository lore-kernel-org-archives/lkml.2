Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab0FDFEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 01:04:14 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49593 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0FDFEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 01:04:13 -0400
Date: Fri, 4 Jun 2010 14:03:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 1/4] kernel: local_irq_{save,restore}_nmi()
Message-ID: <20100604050347.GE31868@linux-sh.org>
References: <20100409.160135.35854399.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100409.160135.35854399.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 04:01:35PM -0700, David Miller wrote:
> 
> Provide local_irq_{save,restore}_nmi() which will allow us to help
> architectures that implement NMIs using IRQ priorities like SPARC64
> does.
> 
> Sparc uses IRQ prio 15 for NMIs and implements local_irq_disable() as
> disable <= 14. However if you do that while inside an NMI you re-
> enable the NMI priority again, causing all kinds of fun.
> 
> A more solid implementation would first check the disable level and
> never lower it, however that is more costly and would slow down the
> rest of the kernel for no particular reason.
> 
> Therefore introduce local_irq_save_nmi() which can implement this
> slower but more solid scheme and dis-allow local_irq_save() from NMI
> context.
> 
> Suggested-by: David Miller <davem@davemloft.net>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Are there any updates for this patch series? I would like to make use of
this on SH as well, but it seems these haven't hit upstream yet.
