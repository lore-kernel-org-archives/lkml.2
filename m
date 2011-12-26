Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab1LZBqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 20:46:52 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:48386
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986Ab1LZBqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 20:46:47 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 26 Dec 2011 10:00:18 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Eric Miao <eric.miao@linaro.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] tty: serial: imx: move del_timer_sync() to avoid
 potential deadlock
Message-ID: <20111226020017.GK8240@S2100-06.ap.freescale.net>
References: <1324589967-25365-1-git-send-email-eric.miao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1324589967-25365-1-git-send-email-eric.miao@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 05:39:27AM +0800, Eric Miao wrote:
> del_timer_sync() acquires its own lock and doesn't have to be nested
> within the spinlock of sport->port.lock in imx_set_termios(),  which
> will cause potential deadlock.  Fix this by moving it outside.
> 
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Eric Miao <eric.miao@linaro.org>

I queued this for 3.3, and will send a pull-request to Greg.

-- 
Regards,
Shawn

