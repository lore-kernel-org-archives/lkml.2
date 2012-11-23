Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2KWIRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:17:04 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:29468
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734Ab2KWIRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:17:01 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI154dI1432Izz1de0h1202h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 23 Nov 2012 16:43:17 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
Message-ID: <20121123084314.GB25754@S2100-06.ap.freescale.net>
References: <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
 <CAKohpo=B_7rVwePziyNe0rTMokcib_FgEN28cy4nByAzbUyaqg@mail.gmail.com>
 <20121121204324.21126.99677@nucleus>
 <20121121205424.GA25470@core.coreip.homeip.net>
 <20121121223859.GQ3290@n2100.arm.linux.org.uk>
 <20121122021750.GD25470@core.coreip.homeip.net>
 <20121122093033.GA5764@n2100.arm.linux.org.uk>
 <20121123071931.GB12631@core.coreip.homeip.net>
 <CAKohpo=8-rduLZgEyHOtxrJLYfo3F5Op7Z_S8hpLS=nRmMgqmA@mail.gmail.com>
 <20121123080858.GA22619@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121123080858.GA22619@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 12:08:58AM -0800, Dmitry Torokhov wrote:
> On Fri, Nov 23, 2012 at 12:57:54PM +0530, Viresh Kumar wrote:
> > On 23 November 2012 12:49, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > Ahh, I see. Then I think my first patch was correct albeit it had bad changelog
> > > message. If provided stubs for clk_prepare()/clk_unprepare() for
> > > platforms that did not define HAVE_CLK and pushed the check for
> > > HAVE_CLK_PREPARE down into drivers/clk/clk.c so __clk_prepare() would
> > > either call platform implementation or just be an empty function.
> > >
> > > Am I correct or I am still missing something?
> > 
> > I believe you are still missing it :)
> > 
> > clk.c will only be compiled when we have COMMON_CLK and
> > COMMON_CLK selects HAVE_CLK_PREPARE.
> > 
> > So, using HAVE_CLK_PREPARE in clk.c is useless, as its always true.
> > I feel, the best solution would be to simply drop patch 1 and apply others.
> 
> Right... OK, I'll drop the first patch.
> 
Removing HAVE_CLK_PREPARE from ARCH_MXS stands valid though.  I will
send another patch to do that.

Shawn

