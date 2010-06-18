Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab0FRDMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 23:12:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45114
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343Ab0FRDMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 23:12:08 -0400
Date: Thu, 17 Jun 2010 20:12:16 -0700 (PDT)
Message-Id: <20100617.201216.115931147.davem@davemloft.net>
To: chf.fritz@googlemail.com
Cc: strakh@ispras.ru, philb@gnu.org, craigs@ineluki.apana.org.au,
       tridge@web.rsise.anu.edu.au, Alan.Cox@linux.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: BUG: double spinlock in "drivers/net/3c505.c"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1276003605.3916.14.camel@lovely>
References: <201006071517.28744.strakh@ispras.ru>
	<1276003605.3916.14.camel@lovely>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Fritz <chf.fritz@googlemail.com>
Date: Tue, 08 Jun 2010 15:26:45 +0200

> On Mon, 2010-06-07 at 15:17 +0400, Alexander Strakh wrote: 
>> 	KERNEL_VERSION: 2.6.35-rc1
>>         SUBJECT: duble spinlock  in function elp_start_xmit
> 
> Not only in elp_start_xmit. This driver is for a pretty old and slow isa
> ethernet card and I think nobody cares. To quote a comment from the
> source: "[...] the concurrency protection is particularly awful".

Indeed, I spent some time trying to unravel the locking mess
for these call chains to check_3c505_dma() and it was just
too much to sanely cure.
