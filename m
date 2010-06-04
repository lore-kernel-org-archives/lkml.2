Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab0FDHe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:34:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55685 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab0FDHe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:34:56 -0400
Subject: Re: [PATCH 1/4] kernel: local_irq_{save,restore}_nmi()
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, sparclinux@vger.kernel.org
In-Reply-To: <20100604050347.GE31868@linux-sh.org>
References: <20100409.160135.35854399.davem@davemloft.net>
	 <20100604050347.GE31868@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Jun 2010 09:35:15 +0200
Message-ID: <1275636915.27810.38912.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 14:03 +0900, Paul Mundt wrote:
> On Fri, Apr 09, 2010 at 04:01:35PM -0700, David Miller wrote:
> > 
> > Provide local_irq_{save,restore}_nmi() which will allow us to help
> > architectures that implement NMIs using IRQ priorities like SPARC64
> > does.
> > 
> > Sparc uses IRQ prio 15 for NMIs and implements local_irq_disable() as
> > disable <= 14. However if you do that while inside an NMI you re-
> > enable the NMI priority again, causing all kinds of fun.
> > 
> > A more solid implementation would first check the disable level and
> > never lower it, however that is more costly and would slow down the
> > rest of the kernel for no particular reason.
> > 
> > Therefore introduce local_irq_save_nmi() which can implement this
> > slower but more solid scheme and dis-allow local_irq_save() from NMI
> > context.
> > 
> > Suggested-by: David Miller <davem@davemloft.net>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Are there any updates for this patch series? I would like to make use of
> this on SH as well, but it seems these haven't hit upstream yet.

Dave found a better solution, see:

  b4f4372f96e0573d752d9e45beda02fabf716cc8
  0c25e9e6cbe7b233bb91d14d0e2c258bf8e6ec83
  c011f80ba0912486fe51dd2b3f71d9b33a151188


