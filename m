Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab0GWE6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 00:58:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38658 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab0GWE6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 00:58:19 -0400
Date: Fri, 23 Jul 2010 06:58:07 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Gregory Bean <gbean@codeaurora.org>
Cc: akpm@linux-foundation.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] gpio: remove spurious gpio_unexport debug error.
Message-ID: <20100723045807.GA14875@pengutronix.de>
References: <1279832758-25442-1-git-send-email-gbean@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1279832758-25442-1-git-send-email-gbean@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jul 22, 2010 at 02:05:58PM -0700, Gregory Bean wrote:
> Make gpio_unexport generate success instead of an -EINVAL
> if asked to unexport a line which is not exported, because
> the only result of that condition is a pr_debug
> which complains of what is really a harmless no-op:
> when an unexported gpio is unexported again, nothing happens.
> That's not a failure, just a trivial border case.
> Since gpio_free calls gpio_unexport unconditionally
> and exported gpio lines are uncommon, most calls to
> gpio_free with debug flags enabled generate -EINVAL
> warnings in the log, causing unnecessary stress.
I noticed that a few days ago, too.  Just didn't come around to fix it
myself.
 
> Signed-off-by: Gregory Bean <gbean@codeaurora.org>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
