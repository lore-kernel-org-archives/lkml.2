Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab1IUQOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:14:11 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:33422 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752436Ab1IUQOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:14:09 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19JPr89rOi+oGyVYylJs52B
Date: Wed, 21 Sep 2011 09:14:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 04/10] hwspinlock/core/omap: fix id issues on multiple
 hwspinlock devices
Message-ID: <20110921161406.GF2937@atomide.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
 <1315846025-11453-5-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315846025-11453-5-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ohad Ben-Cohen <ohad@wizery.com> [110912 09:14]:
> hwspinlock devices provide system-wide hardware locks that are used
> by remote processors that have no other way to achieve synchronization.
> 
> For that to work, each physical lock must have a system-wide unique id
> number that all processors are familiar with, otherwise they can't
> possibly assume they're using the same hardware lock.
> 
> Usually SoCs have a single hwspinlock device, which provides several
> hwspinlocks, and in this case, they can be trivially numbered 0 to
> (num-of-locks - 1).
> 
> In case boards have several hwspinlocks devices (each of which
> providing numerous hardware spinlocks) a different base id should be
> used for each hwspinlock device (they can't all use 0 as a starting
> id!).
> 
> While this is certainly not common, it's just plain wrong to just
> silently use 0 as a base id whenever the hwspinlock driver is probed.
> 
> This patch provides a hwspinlock_pdata structure, that boards can use
> to set a different base id for each of the hwspinlock devices they may
> have, and demonstrates how to use it with the omap hwspinlock driver
> (ultimately it will be DT which will supply this base_id information).
> 
> While we're at it, make sure the hwspinlock core prints an explicit
> error message in case an hwspinlock is registered with an id number
> that already exists; this will help users catch such base id issues.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

Acked-by: Tony Lindgren <tony@atomide.com>
