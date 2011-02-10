Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab1BJMZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:25:16 -0500
Received: from www.tglx.de ([62.245.132.106]:35131 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248Ab1BJMZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:25:12 -0500
Date: Thu, 10 Feb 2011 13:24:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the xen-two tree
In-Reply-To: <20110210154648.8b3b994e.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.1102101322450.31804@localhost6.localdomain6>
References: <20110210154648.8b3b994e.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011, Stephen Rothwell wrote:

> Hi Konrad,
> 
> After merging the xen-two tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/gpio/langwell_gpio.c: In function 'lnw_irq_handler':
> drivers/gpio/langwell_gpio.c:210: error: 'struct irq_desc' has no member named 'chip'
> drivers/gpio/langwell_gpio.c:211: error: 'struct irq_desc' has no member named 'chip'
> 
> Caused by commit e22ff7614860bc282ba1eb25440d8fc56975e357 ("xen:
> Interrupt cleanups").

Argh, it selects:

+       select GENERIC_HARDIRQS_NO_DEPRECATED

Konrad, I merily asked you to test XEN with that flag set, not to
apply the change.

Thanks,

	tglx
