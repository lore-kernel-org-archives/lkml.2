Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab1DIAHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 20:07:46 -0400
Received: from mail.perches.com ([173.55.12.10]:4599 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757888Ab1DIAHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 20:07:45 -0400
Subject: Re: [RFC][WAS:bcmai][PATCH V2] axi: add AXI bus driver
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <BANLkTimQBAHgFaH0RVCOYBGSKuHN2Dprmw@mail.gmail.com>
References: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
	 <1302290881.1664.7.camel@Joe-Laptop>
	 <BANLkTi=QwBOxfxy13PxeX+LRuccV_p06zA@mail.gmail.com>
	 <1302292554.1664.12.camel@Joe-Laptop>
	 <BANLkTimQBAHgFaH0RVCOYBGSKuHN2Dprmw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 17:07:43 -0700
Message-ID: <1302307663.1664.19.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-09 at 02:03 +0200, Rafał Miłecki wrote:
> 2011/4/8 Joe Perches <joe@perches.com>:
> > On Fri, 2011-04-08 at 21:46 +0200, Rafał Miłecki wrote:
> >> 2011/4/8 Joe Perches <joe@perches.com>:
> >> > On Fri, 2011-04-08 at 21:45 +0200, Rafał Miłecki wrote:
> >> >> diff --git a/include/linux/axi/axi.h b/include/linux/axi/axi.h
> >> > []
> >> >> +#define axi_info     pr_info
> >> >> +#ifdef CONFIG_AXI_DEBUG
> >> >> +#define axi_debug    pr_debug
> >> >> +#else
> >> >> +#define axi_debug    do { } while (0)
> >> >> +#endif
> >> >> +#define axi_err              pr_err
> >> > I think redefining standard functionality like
> >> > this doesn't gain anything and loses some basic
> >> > grep capability.
> >> But on the other hand using:
> >> pr_info, pr_err, BUT axi_debug
> >> can easily lead to mistakes.
> >> Or is this possible to re-define pr_debug locally?
> > It is, but is that CONFIG_AXI_DEBUG actually
> > worthwhile?
> > If you think so, doesn't adding this to the Makefile
> > give you the same capability?
> > ccflags-$(CONFIG_CONFIG_AXI_DEBUG) := -DDEBUG

Just CONFIG_AXI_DEBUG of course.

> But pr_debug does not depend on DEBUG define:
> http://lxr.free-electrons.com/source/tools/perf/util/include/linux/kernel.h#L94
> How do you expect -DDEBUG to affect pr_debug? Could you explain this
> to me, please?

Sure.  You're not looking at the right place.

Look instead at include/linux/printk.h

/* If you are writing a driver, please use dev_dbg instead */
#if defined(DEBUG)
#define pr_debug(fmt, ...) \
	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
#elif defined(CONFIG_DYNAMIC_DEBUG)
/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
#define pr_debug(fmt, ...) \
	dynamic_pr_debug(fmt, ##__VA_ARGS__)
#else
#define pr_debug(fmt, ...) \
	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
#endif

cheers, Joe

