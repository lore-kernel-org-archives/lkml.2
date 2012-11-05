Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2KEIo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:44:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64319 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab2KEIoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:44:25 -0500
Date: Mon, 5 Nov 2012 09:44:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: David Miller <davem@davemloft.net>
Cc: pebolle@tiscali.nl, linux-kernel@vger.kernel.org, isdn@linux-pingi.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH 8/9] isdn: Remove unused variable causing a compile build
 warning
Message-ID: <20121105084419.GC2699@gmail.com>
References: <20121103224832.GA24262@gmail.com>
 <1352024091.1434.17.camel@x61.thuisdomein>
 <20121104105332.GC27124@gmail.com>
 <20121104.123013.700345271120279281.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121104.123013.700345271120279281.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Nov 2012, David Miller wrote:

> From: Lee Jones <lee.jones@linaro.org>
> Date: Sun, 4 Nov 2012 11:53:32 +0100
> 
> > On Sun, 04 Nov 2012, Paul Bolle wrote:
> > 
> >> On Sat, 2012-11-03 at 23:48 +0100, Lee Jones wrote:
> >> > On Sat, 03 Nov 2012, Paul Bolle wrote:
> >> > > On Sat, 2012-11-03 at 23:02 +0100, Lee Jones wrote:
> >> > > > This patch fixes:
> >> > > > drivers/isdn/i4l/isdn_common.c: In function ‘isdn_ioctl’:
> >> > > > drivers/isdn/i4l/isdn_common.c:1278:8: warning: unused variable ‘s’ [-Wunused-variable]
> >> > > 
> >> > > Did you have CONFIG_NETDEVICES not set in this build?
> >> > 
> >> > Ah yes, I see it. The function went down further than I thought
> >> > it did. So the real fix is to ensure 's' is defined inside of
> >> > some ifdef CONFIG_NETDEVICES guards. 
> >> 
> >> What puzzles me is that we only find these "#ifdef CONFIG_NETDEVICES"
> >> guards in this file and not in isdn_net.c, were all the ioctl commands
> >> guarded that way seem to be calling into. On first glance that doesn't
> >> make much sense.
> >> 
> >> (Actually the idea of having ISDN without NETDEVICES is a bit puzzling
> >> too. But there are too many parts of the isdn subsystem that I'm
> >> unfamiliar with to say whether that can make sense.)
> > 
> > I'm in the same position as you Paul. I just noticed the warning so
> > fixed it following the current way of doing things. Any, more
> > substantial changes requiring greater knowledge of the subsystem
> > would have to be done by someone else.
> 
> I think the most appropriate thing to do is make CONFIG_ISDN depend
> upon CONFIG_NETDEVICES in the Kconfig file.

... and then remove the CONFIG_NETDEVICES guards in isdn_common.c?

If that's suitable more suitable I can do that instead?

Just need a yay or nay and I'll make it happen.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
