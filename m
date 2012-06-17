Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2FQQXW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 12:23:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57453 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab2FQQXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 12:23:21 -0400
Date: Sun, 17 Jun 2012 17:21:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        ulf.hansson@stericsson.com, linus.walleij@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        aletes.xgr@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/2] mmc: mmci.c: Defer probe() in case of yet
	uninitialized GPIOs
Message-ID: <20120617162142.GA26446@n2100.arm.linux.org.uk>
References: <1339927893-8842-1-git-send-email-stigge@antcom.de> <1339927893-8842-2-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339927893-8842-2-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 12:11:32PM +0200, Roland Stigge wrote:
> If the GPIOs used by the MMCI driver are not registered yet when the driver is
> probe()d, they can't be used. This happens if the mmci driver is probed before
> the respective GPIO controller (e.g. on the LPC32xx EA3250 board, the PCA9532
> GPIO controller would be initialized via DT after mmci). Therefore, we defer
> mmci in this case.

I'm much happier with this.  Provided the change to the GPIO OF stuff is
fine.
