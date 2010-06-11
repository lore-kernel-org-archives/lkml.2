Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab0FKQwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:52:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1057 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757765Ab0FKQwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:52:39 -0400
Subject: Re: [PATCH] staging/wlags49_hs: Fix build error when CONFIG_SYSFS
 is  not set
From: Joe Perches <joe@perches.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Henk de Groot <pe1dnn@amsat.org>, devel@driverdev.osuosl.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikH_CAVo7sblakUfhI-ysIXk2z1KZz0YkjCDL3m@mail.gmail.com>
References: <1276238148.22216.30.camel@lenovo>
	 <1276238502.1556.512.camel@Joe-Laptop.home>
	 <AANLkTikH_CAVo7sblakUfhI-ysIXk2z1KZz0YkjCDL3m@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 09:52:36 -0700
Message-ID: <1276275156.1637.52.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 08:46 -0400, Javier Martinez Canillas wrote:
> >>  extern void register_wlags_sysfs(struct net_device *);
> >>  extern void unregister_wlags_sysfs(struct net_device *);
> >>  #else
> >> -static void register_wlags_sysfs(struct net_device *) { return; };
> >> -static void unregister_wlags_sysfs(struct net_device *) { return; };
> >> +#define register_wlags_sysfs(net_device) { }
> >> +#define unregister_wlags_sysfs(net_device) { }
> >>  #endif
> > Yes, that works, but a better fix would be to remove the
> > semicolons after the function close braces.
> > ---
> Why would it be better? With a macro you avoid the overhead of a
> function call that does nothing.

Check the generated code.
$ make drivers/staging/wlags49_h2/wl_sysfs.lst

> I personally think a macro fit better in this case.

Check the general kernel use of macros vs functions.
Functions verify proper arguments, macros do not.


