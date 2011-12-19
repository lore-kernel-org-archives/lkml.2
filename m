Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1LSDOD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 22:14:03 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:18005
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053Ab1LSDOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 22:14:02 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzz8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 19 Dec 2011 11:27:13 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Marek Vasut <marek.vasut@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Wolfgang Denk <wd@denx.de>, Stefano Babic <sbabic@denx.de>,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <b32955@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] MXS: Convert mutexes in clock.c to spinlocks
Message-ID: <20111219032712.GB4962@S2100-06.ap.freescale.net>
References: <1324217174-6574-1-git-send-email-marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1324217174-6574-1-git-send-email-marek.vasut@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 03:06:13PM +0100, Marek Vasut wrote:
> The mutexes can't be safely used under certain circumstances. I noticed this
> issue during some network instability at home:
> 
Yes, this is a known issue.  And there was some discussion[1] about
why mutex is needed.  But I really have not thought about why we can
not use spinlock only, since using mutex only leads to the issue we
are seeing here, and using spinlock in enable/disable and mutex in
rate/parent will not work, because the mxs clocks have enable/disable
and rate/parent functions access the same register.  I know it's not
good to hold spinlock in rate/parent functions for a long time, but
do we have a way around rather than using spinlock for both sets of
functions?

-- 
Regards,
Shawn

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/137282

