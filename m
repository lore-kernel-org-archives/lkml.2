Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab2B2XZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:25:03 -0500
Received: from broadrack.ru ([195.178.208.66]:56281 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932300Ab2B2XZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:25:00 -0500
Date: Thu, 1 Mar 2012 02:24:57 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Renata Sayakhova <rsayakhova@gmail.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] DS2781 Maxim Stand-Alone Fuel Gauge battery and w1
 slave drivers
Message-ID: <20120229232457.GA12803@ioremap.net>
References: <1330523933-32344-1-git-send-email-rsayakhova@gmail.com>
 <1330523933-32344-2-git-send-email-rsayakhova@gmail.com>
 <20120229185259.GC32077@ioremap.net>
 <CAO0_4pY_MXgx1gFRK9ino0P9RAO3e3E00PFCJvjpq2A-6Oz=1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO0_4pY_MXgx1gFRK9ino0P9RAO3e3E00PFCJvjpq2A-6Oz=1Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 12:17:30AM +0100, Renata Sayakhova (rsayakhova@gmail.com) wrote:
> w1_process (w1.c line 982) holds mutex. If during w1_search_process (w1.c
> line 983) slave is found and battery initcall is already done at this
> moment than battery probe() is called. This call leads to
> power_supply_register() and device_add() which does among other things call
> battery properties. battery_get_property() should normally results in
> w1_ds2781_read() and w1_ds2781_io(), but w1_ds2781_io() calls itself
> mutex_lock.
> 
> So this weird function is a workaround to avoid a second mutex_lock during
> battery probe(). mutex_holder is set before power_supply_register() and
> unset when probe is done.
> 
> This is very brief, if it's not clear I'll try to explain in more details.
> I found this workaround in implementation of ds2780 battery and w1 slave
> drivers.

So basically IO routins caled from ->probe() are already locked so we
protect against deadlock. Ok, I see.

I have no objections, patch looks good
Greg, please pull it into your tree
Thank you

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>


-- 
	Evgeniy Polyakov
