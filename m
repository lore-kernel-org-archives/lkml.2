Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1FCHwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 03:52:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48476 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1FCHwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 03:52:14 -0400
Date: Fri, 3 Jun 2011 08:52:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, patches@linaro.org,
        grant.likely@secretlab.ca, kernel@pengutronix.de, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/4] Move plat-mxc gpio driver into drivers/gpio
Message-ID: <20110603075201.GE10532@n2100.arm.linux.org.uk>
References: <1306985632-18820-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306985632-18820-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 11:33:48AM +0800, Shawn Guo wrote:
>  arch/arm/plat-mxc/gpio.c                        |  361 -------------------
>  drivers/gpio/gpio-mxc.c                         |  433 +++++++++++++++++++++++

I'm wondering why just moving this driver into drivers/gpio has
resulted in it growing by 72 lines - and it's not clear from the
diffs why that is because of the way they're broken up.

Would it not be better to have the first patch to merely move
arch/arm/plat-mxc/gpio.c to drivers/gpio/gpio-mxc.c, making whatever
config changes are necessary.  Then subsequent patches should change
drivers/gpio/gpio-mxc.c as required - which means we can see what
changes are being made.

As the series currently stands, from the review point of view it's
effectively adding an entirely new driver, converting everything over
to it, and then deleting the old.
