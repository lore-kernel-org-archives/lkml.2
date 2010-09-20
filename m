Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab0ITJuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:50:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41660 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab0ITJuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:50:04 -0400
Date: Mon, 20 Sep 2010 10:50:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, lrg@slimlogic.co.uk,
        "'Changhwan Youn'" <chaos.youn@samsung.com>,
        "'Jeongbae Seo'" <jeongbae.seo@samsung.com>
Subject: Re: [PATCH] regulator: Add support samsung power domain
Message-ID: <20100920095001.GB31167@sirena.org.uk>
References: <1284717532-9992-1-git-send-email-kgene.kim@samsung.com> <20100917113050.GA4322@rakim.wolfsonmicro.main> <009d01cb588a$d45ce520$7d16af60$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009d01cb588a$d45ce520$7d16af60$%kim@samsung.com>
X-Cookie: Stay the curse.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 03:12:34PM +0900, Kukjin Kim wrote:

> The reason the implementation is located in machine-specific code is that
> the way to handle power domain in S5PV210 and S5PV310 is different but we
> can handle this using platform_device_id.

Yes, I think it's reasonable to implement stuff under arch/arm - my only
issue with what you'd done was that I didn't feel the glue layer was
adding anything.

> > Another option to consider here is using runtime PM - other platforms
> > seem to be going down that route, and are using it to also factor clock
> > management for the IP blocks out (so that the block's clocks get enabled
> > and disabled automatically when the block is active without needing any
> > code in the driver).

> To use runtime PM cannot be a substitute for using regulator API.
> It's related to when to control the power domain whether using regulator API
> is to how to control the power domain.

The runtime PM API will give you very similar reference counting to the
regulator API, for all you're using the regulator API for here there's
not a massive difference.  If you started using voltage scaling then
there'd be more win.

> We have a plan to support runtime PM using regulator API.
> Am I on the right track ?

That's doable.
