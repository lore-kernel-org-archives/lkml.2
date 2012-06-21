Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067Ab2FURy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 13:54:56 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:45497 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760052Ab2FURyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 13:54:55 -0400
Date: Thu, 21 Jun 2012 10:54:43 -0700
From: Mike Turquette <mturquette@ti.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, Mitch Bradley <wmb@laptop.org>,
        mturquette@linaro.org, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        skannan@codeaurora.org, Olof Johansson <olof@lixom.net>,
        shawn.guo@linaro.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/4] DT clock bindings
Message-ID: <20120621175443.GL4402@gmail.com>
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
 <87bokd15x7.fsf@octavius.laptop.org>
 <4FE33723.3040403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE33723.3040403@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120621-10:00, Rob Herring wrote:
> On 06/21/2012 02:27 AM, Chris Ball wrote:
> > 
> > 2) Use alloc_bootmem() instead of kzalloc() in of_clk_add_provider(),
> >    because we need to set up clocks during .init_early on ARM (which
> >    happens pre-slab) so that they are available for platform init.
> 
> This depends on 1 as the common clock code would have the same issue.
> Generally, the first place clocks are needed is the timer init. At that
> point, you can call kzalloc. This is where all the clock init used to be
> done until init_early was added and some platforms have moved their
> clock init. I don't think there was really ever much reason to move it
> other than to make the timer init function only deal with timer setup.
> 

Hi Rob,

Just FYI I've been looking at using alloc_bootmem in the common clk code
as a way to get rid of the static initialization stuff (which only
existed due to very early initialization of timers).

The suggested change above to of_clk_add_provider would jive well with
my change to the common clk code.

Regards,
Mike
