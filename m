Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab0LUUrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 15:47:02 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:11263 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab0LUUrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 15:47:00 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19MHpqSLgPbh7kjbU4lM43G
Date: Tue, 21 Dec 2010 12:46:51 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sutharsan R <sutharsan.ram@gmail.com>
Cc: greg@kroah.com, linux-arm@vger.kernel.org, srmt@cypress.com,
        david.cross@cypress.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] adding gpmc configuration functions, west bridge
 related
Message-ID: <20101221204651.GM5829@atomide.com>
References: <AANLkTi==X9maghSd3YwG6g3cQek3gV9-3Fx8W+n_zLmp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi==X9maghSd3YwG6g3cQek3gV9-3Fx8W+n_zLmp@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sutharsan R <sutharsan.ram@gmail.com> [101220 18:41]:
> This patch adds and exports gpmc configuration functions.
> 'gpmc' configuration functions will be used by
> westbridge device controller driver in staging tree.
> This patch is part of the work to get westbridge device controller driver
> out of staging tree.

Looks good in general..

> +EXPORT_SYMBOL(cywb_pnand_platform_retime);

But this you should not need. I know tusb6010 is
still doing that, but you can pass it in the platform_data
and then there's no need to export it.

Then in your driver you can do:

if (xxxxx->retime)
	xxxxx->retime(123);

That way the driver will stay generic. The set_power
functions are doing that in drivers/usb/musb if you
need examples.

Also, this will need a slight update based on Adrian Hunter's
patch "OMAP2/3: GPMC: put sync_clk value in picoseconds
instead of nanosecond" that I'll be queuing.

Regards,

Tony
