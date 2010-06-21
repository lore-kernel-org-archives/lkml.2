Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab0FUVqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:46:12 -0400
Received: from kroah.org ([198.145.64.141]:41604 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab0FUVpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:45:47 -0400
Date: Mon, 21 Jun 2010 14:38:46 -0700
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Dmitry Torokhov <dtor@mail.ru>,
       Anisse Astier <anisse@astier.eu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Magnus Damm <damm@opensource.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Paul Mundt <lethal@linux-sh.org>, Eric Miao <eric.y.miao@gmail.com>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Driver core: reduce duplicated code
Message-ID: <20100621213846.GB25511@kroah.com>
References: <20100618073950.GA12822@pengutronix.de>
 <1277129511-2732-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1277129511-2732-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 04:11:44PM +0200, Uwe Kleine-König wrote:
> This makes the two similar functions platform_device_register_simple
> and platform_device_register_data one line inline functions using a new
> generic function platform_device_register_resndata.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> still unsolved is the naming issue, what do you think about
> platform_device_register?

We already have a platform_device_register() function :)

> I marked the new function as __init_or_module in a separate patch to
> make reverting it a bit easier, still I think it should be possible to
> fix the caller if a problem occurs.
> 
> I changed the semantic slightly to only call
> platform_device_add_resources if data != NULL instead of size != 0.  The
> idea is to support wrappers like:
> 
> 	#define add_blablub(id, pdata) \
> 		platform_device_register_resndata(NULL, "blablub", id, \
> 			NULL, 0, pdata, sizeof(struct blablub_platform_data))
> 
> that don't fail if pdata=NULL.  Ditto for res.

That's fine, but why would you want to have a #define for something like
this?  Is it really needed?

Anyway, this version looks fine to me, I'll go apply it.

thanks,

greg k-h
