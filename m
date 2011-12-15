Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1LOGSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:18:01 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33021 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab1LOGR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:17:59 -0500
Date: Thu, 15 Dec 2011 06:17:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        ashishj3 <ashish.jangam@kpitcummins.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Dajun Chen <dchen@diasemi.com>
Subject: Re: linux-next: build failure after merge of the regmap tree
Message-ID: <20111215061757.GC24287@sirena.org.uk>
References: <20111215170517.0b7fc08487881743ca76c192@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215170517.0b7fc08487881743ca76c192@canb.auug.org.au>
X-Cookie: Not recommended for children.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 05:05:17PM +1100, Stephen Rothwell wrote:

> drivers/gpio/gpio-da9052.c:25:35: fatal error: linux/mfd/da9052/gpio.h: No such file or directory

> So, it looks like this would never have built
> (include/linux/mfd/da9052/gpio.h never existed) but noone ever enabled
> CONFIG_PMIC_DA9052 before (which CONFIG_GPIO_DA9052 depends on).

> drivers/gpio/gpio-da9052.c was added with commit 07bfc9152365 ("GPIO:
> DA9052 GPIO module v3") in v3.1-rc1.

The issue here is that the GPIO driver was merged prior to review being
completed for the MFD and then problems with the MFD caused lots of
changes in the rest of the series.  The MFD review is now fine so it's
been merged (via regmap due to use of new regmap features) but the GPIO
driver needs updating.

Ashish or Daneil, could you please send a patch fixing this?  Possibly
just a case of adding the new header.
