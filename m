Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab2HILzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:55:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40770 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2HILzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:55:38 -0400
Date: Thu, 9 Aug 2012 12:55:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Sergio Aguirre <saaguirre@ti.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/3] mfd: twl6040: Add twl6040-gpio child
Message-ID: <20120809115531.GB8474@sirena.org.uk>
References: <1342603220-13287-1-git-send-email-peter.ujfalusi@ti.com>
 <1342603220-13287-3-git-send-email-peter.ujfalusi@ti.com>
 <CACRpkdZJcy5HOZkjMCVJW5beExoCHOBb=BiB4GOGR7sM+5Xsww@mail.gmail.com>
 <5016967D.2020104@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5016967D.2020104@ti.com>
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 05:13:17PM +0300, Peter Ujfalusi wrote:

> If the board needs the gpo driver, but in the driver(s) I need to check for
> the existence of the "ti,twl6040-gpo" node and check if the status is "okay".
> I think it is easier to just get the value of "ti,use-gpo", if it exist and it
> is 1 I enable the GPIO driver otherwise I don't.

Will having the GPIO driver actually cause any problems if it's not in
use?  It's not like things like RTC which are directly visible to
userspace and so can create problems if they're non-functional, unless
it does something like grab resources that might be needed by another
subfunction driver there's not really a substantial cost in just
instantiating it (people who are really space pressured probably won't
build the driver in in the first place).
