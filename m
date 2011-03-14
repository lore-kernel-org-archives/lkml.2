Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab1CNUiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:38:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:58709 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1CNUiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:38:22 -0400
Subject: Re: linux-next: build failure after merge of the final tree
 (powerpc tree related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lennert Buytenhek <buytenh@secretlab.ca>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110314203827.4b61818e.sfr@canb.auug.org.au>
References: <20110314203827.4b61818e.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 07:37:54 +1100
Message-ID: <1300135074.22236.788.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 20:38 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/gpio/langwell_gpio.c: In function 'lnw_irq_handler':
> drivers/gpio/langwell_gpio.c:210: error: 'struct irq_desc' has no member named 'chip'
> drivers/gpio/langwell_gpio.c:211: error: 'struct irq_desc' has no member named 'chip'
> 
> Caused by commit 17b9f9e2653a ("powerpc: Enable
> GENERIC_HARDIRQS_NO_DEPRECATED") enabling
> CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED for powerpc without previously
> fixing up the above driver.
> 
> I have reverted that commit for today.

Except that the above driver has nothing to do with powerpc, it's some
Intel Moorestown stuff...

It should be fixed regardless I suppose, CC'ing Thomas.

Cheers,
Ben.


