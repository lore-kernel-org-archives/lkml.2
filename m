Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1LSEDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:03:52 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35700 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab1LSEDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:03:50 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] MXS: Convert mutexes in clock.c to spinlocks
Date: Mon, 19 Dec 2011 05:03:45 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wolfgang Denk <wd@denx.de>, Stefano Babic <sbabic@denx.de>,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <b32955@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
References: <1324217174-6574-1-git-send-email-marek.vasut@gmail.com> <20111219032712.GB4962@S2100-06.ap.freescale.net>
In-Reply-To: <20111219032712.GB4962@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112190503.46668.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Dec 18, 2011 at 03:06:13PM +0100, Marek Vasut wrote:
> > The mutexes can't be safely used under certain circumstances. I noticed
> > this
> 
> > issue during some network instability at home:
> Yes, this is a known issue.  And there was some discussion[1] about
> why mutex is needed.

Thanks for pointing this out, I was unaware of it.

> But I really have not thought about why we can
> not use spinlock only, since using mutex only leads to the issue we
> are seeing here, and using spinlock in enable/disable and mutex in
> rate/parent will not work, because the mxs clocks have enable/disable
> and rate/parent functions access the same register.  I know it's not
> good to hold spinlock in rate/parent functions for a long time, but
> do we have a way around rather than using spinlock for both sets of
> functions?

Yea, spinlock is not good either. On the other hand, is it really held for so 
long ?

M
