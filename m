Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1BUGcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 01:32:01 -0500
Received: from kroah.org ([198.145.64.141]:33557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab1BUGbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 01:31:46 -0500
Date: Sun, 20 Feb 2011 22:31:54 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kim B. Heino" <Kim.Heino@bluegiga.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Jackson <mpfj@mimc.co.uk>, Dennis Aberilla <denzzzhome@yahoo.com>
Subject: Re: linux-next: build warning after merge of the driver-core tree
Message-ID: <20110221063154.GA30091@kroah.com>
References: <20110221163727.0addb3ab.sfr@canb.auug.org.au>
 <20110221165023.c3216b96.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221165023.c3216b96.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 04:50:23PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Mon, 21 Feb 2011 16:37:27 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the driver-core tree, today's linux-next build (x86_64
> > allmodconfig) produced this warning:
> > 
> > drivers/rtc/rtc-m41t94.c: In function 'm41t94_remove':
> > drivers/rtc/rtc-m41t94.c:139: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type
> > include/linux/platform_device.h:133: note: expected 'const struct platform_device *' but argument is of type 'struct spi_device *'
> > 
> > Revealed by commit 71d642908d4e8e7a2a4a6e0490432e719ff466d5 ("Driver
> > core: convert platform_{get,set}_drvdata to static inline functions").
> > The warning is in code introduced by commit
> > 8fc2c767b06067b417c565c4e75731e68ed41fd8 ("rtc: add support for ST M41T94
> > SPI RTC").
> 
> There are also:
> 
> drivers/rtc/rtc-ds1390.c: In function 'ds1390_remove':
> drivers/rtc/rtc-ds1390.c:161: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type
> 
> Introduced in commit 06de18085122b873012cb23f043e2bdcf5f50923 ("rtc: add
> Dallas DS1390/93/94 RTC chips").
> 
> drivers/rtc/rtc-ds3234.c: In function 'ds3234_remove':
> drivers/rtc/rtc-ds3234.c:161: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type
> 
> Introduced in commit 2f9b75e09ec3f62f2ebecec0ac9aec58656c2459 ("rtc: add
> device driver for Dallas DS3234 SPI RTC chip").

Wow, all of these are driver errors, it's amazing it was all working
properly before.  It's not the core's fault here, so there's nothing I
can do in my tree :(

thanks,

greg k-h
