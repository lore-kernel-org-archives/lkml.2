Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2BFGHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 01:07:15 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:38973 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025Ab2BFGHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 01:07:13 -0500
Date: Sun, 5 Feb 2012 23:07:08 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Torben Hohn <torbenh@linutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree (gpio
 tree related)
Message-ID: <20120206060708.GC21449@ponder.secretlab.ca>
References: <20120206152346.106057d7dd747d0daa47bbc8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206152346.106057d7dd747d0daa47bbc8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 03:23:46PM +1100, Stephen Rothwell wrote:
> Hi Grant,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/gpio/gpio-sodaville.c:130:2: error: unknown field 'dt_translate' specified in initializer
> drivers/gpio/gpio-sodaville.c:130:2: warning: initialization from incompatible pointer type [enabled by default]
> drivers/gpio/gpio-sodaville.c:130:2: warning: (near initialization for 'irq_domain_sdv_ops.match') [enabled by default]
> drivers/gpio/gpio-sodaville.c: In function 'sdv_register_irqsupport':
> drivers/gpio/gpio-sodaville.c:152:8: error: 'struct irq_domain' has no member named 'irq_base'
> drivers/gpio/gpio-sodaville.c:182:2: error: implicit declaration of function 'irq_domain_add' [-Werror=implicit-function-declaration]
> drivers/gpio/gpio-sodaville.c: In function 'sdv_gpio_remove':
> drivers/gpio/gpio-sodaville.c:263:2: error: implicit declaration of function 'irq_domain_del' [-Werror=implicit-function-declaration]
> 
> Caused by commit 8b26c833d229 ("gpio: Add a driver for Sodaville GPIO
> controller") interacting with the irqdomain tree changes.
> 
> I have reverted that commit for today.  I am not sure how you should
> handle this ... you could send me a fixup patch that I should apply as a
> merge fix when merging the irqdomain tree.

The sodavile is an x86 driver only.  This problem can be solved by
making it depend on x86, which I'll do now.  When x86 is converted to the
new irq_domain code the problem will go even further away.

g.


