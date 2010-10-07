Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab0JGSpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:45:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35668 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0JGSpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:45:05 -0400
Date: Thu, 7 Oct 2010 20:45:01 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>, David Jander <david@protonic.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mfd/mc13xxx: add support for mc13892
Message-ID: <20101007184501.GX29673@pengutronix.de>
References: <20100929162315.GG29811@pengutronix.de> <1285777427-2887-3-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1285777427-2887-3-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Wed, Sep 29, 2010 at 06:23:46PM +0200, Uwe Kleine-König wrote:
> mc13892 is the companion PMIC for Freescale's i.MX51.  It's similar enough
> to mc13782 to support it in a single driver.
> 
> This patch introduces enough compatibility cruft to keep all users of the
> superseded mc13783 driver unchanged.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/mfd/Kconfig         |    9 +-
>  drivers/mfd/Makefile        |    2 +-
>  drivers/mfd/mc13783-core.c  |  743 --------------------------------------
>  drivers/mfd/mc13xxx-core.c  |  840 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/mc13783.h |  247 ++++++-------
>  include/linux/mfd/mc13xxx.h |  154 ++++++++
>  6 files changed, 1113 insertions(+), 882 deletions(-)
>  delete mode 100644 drivers/mfd/mc13783-core.c
>  create mode 100644 drivers/mfd/mc13xxx-core.c
>  create mode 100644 include/linux/mfd/mc13xxx.h
> 
> [...]
> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> new file mode 100644
> index 0000000..93258ad
> --- /dev/null
> +++ b/drivers/mfd/mc13xxx-core.c
> @@ -0,0 +1,840 @@
> +/*
> + * Copyright 2009-2010 Pengutronix
> + * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
> + *
> + * loosely based on an earlier driver that has
> + * Copyright 2009 Pengutronix, Sascha Hauer <s.hauer@pengutronix.de>
> + *
> + * This program is free software; you can redistribute it and/or modify it under
> + * the terms of the GNU General Public License version 2 as published by the
> + * Free Software Foundation.
> + */
> +#define DEBUG
> +#define VERBOSE_DEBUG
David Jander gave me a hint via private mail that I forgot to remove
these two #defines.
Would you care to remove these before Linus pulls?  Should I send a
patch or do you do it by hand?

Thanks to both of you,
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
