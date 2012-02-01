Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2BARgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:36:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65399 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab2BARgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:36:44 -0500
Date: Wed, 1 Feb 2012 21:36:39 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH] bq27x00_battery: fix flag register read
Message-ID: <20120201173639.GA12255@oksana.dev.rtsoft.ru>
References: <1326574249-31334-1-git-send-email-notasas@gmail.com>
 <12065816.FDViioMQvj@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12065816.FDViioMQvj@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 02:49:03AM -0800, Pali Rohár wrote:
> On Saturday 14 January 2012 22:50:49 Grazvydas Ignotas wrote:
> > When reading flags, bq27x00_read() argument is inverted and causes
> > reads 2 of bytes for bq27200 and 1 byte for bq27500, while their register
> > sizes are 1 and 2 bytes respectively. This causes bq27500 upper flag
> > bits always to be returned as 0, causing full charge state to never be
> > reported correctly, so fix it.
> > 
> > Cc: Pali Rohár <pali.rohar@gmail.com>
> > Cc: Lars-Peter Clausen <lars@metafoo.de>
> > Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> > ---
> >  drivers/power/bq27x00_battery.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/power/bq27x00_battery.c
> > b/drivers/power/bq27x00_battery.c index 98bf567..86decb4 100644
> > --- a/drivers/power/bq27x00_battery.c
> > +++ b/drivers/power/bq27x00_battery.c
> > @@ -312,7 +312,7 @@ static void bq27x00_update(struct bq27x00_device_info
> > *di) struct bq27x00_reg_cache cache = {0, };
> >  	bool is_bq27500 = di->chip == BQ27500;
> > 
> > -	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, is_bq27500);
> > +	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
> >  	if (cache.flags >= 0) {
> >  		if (!is_bq27500 && (cache.flags & BQ27000_FLAG_CI)) {
> >  			dev_info(di->dev, "battery is not calibrated! ignoring capacity
> > values\n");
> 
> Yes, you are right, this patch fixing flags register reading.
> Anton Vorontsov, can you send this patch to linux 3.3?

Applied to battery-urgent.git, thanks guys!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
