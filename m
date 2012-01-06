Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab2AFGxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 01:53:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57308 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503Ab2AFGxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 01:53:36 -0500
Date: Thu, 5 Jan 2012 22:53:30 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH V1] regulator: fixed: Move drivers to
 subsys_initcall_sync()
Message-ID: <20120106065329.GC3496@opensource.wolfsonmicro.com>
References: <1325693335-1905-1-git-send-email-ldewangan@nvidia.com>
 <20120105055900.GE11867@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9DEC@BGMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9DEC@BGMAIL01.nvidia.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 01:05:25PM +0530, Laxman Dewangan wrote:

> > I don't really think this is worth faffing about with, it seems at least
> > as likely to create more problems with things that depend on the
> > regulator as it is to make the regulator work.  Really we need Grant's

> Yes, I agree, the init ordering need to be done properly but this is how we
> have as of now to make ordering.
> I have the switchA which is connected on regulatorA (from PMIC) and the
> switchB which is in the gpio of the pmic. The fixed regulator registration for
> switchA and switchB are failing because it did not found the valid supply/gpio.
> The one way to resolve the call probe of the fixed regulator only when pmic
> initialization is done and it is in subsys_init().
> The other way is to do the platform device registration of the fixed regulator
> is in subsys_initcall_sync() in place of arch_init, although driver is in
> subsys_initcall() to postponed the probe calling.

> What do you suggest on this case?

Honestly I'd suggest that you contribute to the effort to get the probe
ordering handling code implemented in mainline.  This just seems like a
big can of worms to open up for something that's hopefully just going to
be a short term thing.  It's a real problem but this seems fairly niche
and like if we start doing more than we're already doing we're going to
end up running around chasing our own tails on this stuff.  I'm really
not sure what the status is on that work, though - it may be that you
actually need to pick the patches up and push them forwards yourself.
