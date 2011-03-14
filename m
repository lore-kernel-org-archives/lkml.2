Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab1CNVV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:21:28 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:46006 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab1CNVV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:21:26 -0400
Date: Mon, 14 Mar 2011 22:21:25 +0100
From: Lennert Buytenhek <buytenh@secretlab.ca>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree (powerpc tree related)
Message-ID: <20110314212125.GA9616@mail.wantstofly.org>
References: <20110314203827.4b61818e.sfr@canb.auug.org.au> <1300135074.22236.788.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300135074.22236.788.camel@pasglop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 07:37:54AM +1100, Benjamin Herrenschmidt wrote:

> > Hi all,
> > 
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> > 
> > drivers/gpio/langwell_gpio.c: In function 'lnw_irq_handler':
> > drivers/gpio/langwell_gpio.c:210: error: 'struct irq_desc' has no member named 'chip'
> > drivers/gpio/langwell_gpio.c:211: error: 'struct irq_desc' has no member named 'chip'
> > 
> > Caused by commit 17b9f9e2653a ("powerpc: Enable
> > GENERIC_HARDIRQS_NO_DEPRECATED") enabling
> > CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED for powerpc without previously
> > fixing up the above driver.
> > 
> > I have reverted that commit for today.
> 
> Except that the above driver has nothing to do with powerpc, it's some
> Intel Moorestown stuff...

I sent this this morning:

	http://marc.info/?l=linux-kernel&m=130009963219374&w=2
