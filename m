Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab2FPO1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 10:27:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57243 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab2FPO10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 10:27:26 -0400
Date: Sat, 16 Jun 2012 15:26:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        ulf.hansson@stericsson.com, linus.walleij@linaro.org,
        sebastian.rasmussen@stericsson.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mmc: mmci.c: Defer probe() in case of missing GPIOs
Message-ID: <20120616142652.GC7628@n2100.arm.linux.org.uk>
References: <1339856099-9313-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339856099-9313-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 04:14:59PM +0200, Roland Stigge wrote:
> If the GPIOs used by the MMCI driver are not registered yet when the
> driver is probe()d, they can't be used. This happens if the mmci driver
> is probed before the respective GPIO controller (e.g. on the LPC32xx
> EA3250 board, the PCA9532 GPIO controller would be initialized via DT
> after mmci). Therefore, we defer mmci in this case.

This code is wrong.  There are platforms where plat->gpio_cd is negative
(because there isn't an associated GPIO) and we still expect the driver
to successfully bind.  In that case, the driver gets the CD and WP
information via the status callback.

So this is an incompatible change with existing (and required) driver
behaviour.
