Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab1CNUul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:50:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43633
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757217Ab1CNUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:50:38 -0400
Date: Mon, 14 Mar 2011 13:51:16 -0700 (PDT)
Message-Id: <20110314.135116.112600339.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: sfr@canb.auug.org.au, paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        buytenh@secretlab.ca, grant.likely@secretlab.ca, tglx@linutronix.de
Subject: Re: linux-next: build failure after merge of the final tree
 (powerpc tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1300135074.22236.788.camel@pasglop>
References: <20110314203827.4b61818e.sfr@canb.auug.org.au>
	<1300135074.22236.788.camel@pasglop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 15 Mar 2011 07:37:54 +1100

> On Mon, 2011-03-14 at 20:38 +1100, Stephen Rothwell wrote:
>> Hi all,
>> 
>> After merging the final tree, today's linux-next build (powerpc
>> allyesconfig) failed like this:
>> 
>> drivers/gpio/langwell_gpio.c: In function 'lnw_irq_handler':
>> drivers/gpio/langwell_gpio.c:210: error: 'struct irq_desc' has no member named 'chip'
>> drivers/gpio/langwell_gpio.c:211: error: 'struct irq_desc' has no member named 'chip'
>> 
>> Caused by commit 17b9f9e2653a ("powerpc: Enable
>> GENERIC_HARDIRQS_NO_DEPRECATED") enabling
>> CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED for powerpc without previously
>> fixing up the above driver.
>> 
>> I have reverted that commit for today.
> 
> Except that the above driver has nothing to do with powerpc, it's some
> Intel Moorestown stuff...
> 
> It should be fixed regardless I suppose, CC'ing Thomas.

I've had to make fixes to this driver in sparc64 allmodconfig builds
too :-)
