Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab1JQRKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:10:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:42131 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599Ab1JQRKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:10:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,360,1315206000"; 
   d="scan'208";a="74721439"
Subject: Re: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data
 transfers
From: Vinod Koul <vinod.koul@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>,
        Dan <dan.j.williams@intel.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
In-Reply-To: <CAJe_ZhdjMTsqSTDwV_zaAQKmCbjOtRVc951wxqKScaCR-DBG9Q@mail.gmail.com>
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com>
	 <1317492077.1573.1839.camel@vkoul-udesk3>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202291E40@CORPEXCH1.na.ads.idt.com>
	 <1317965252.1573.2238.camel@vkoul-udesk3>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E552022D6C9A@CORPEXCH1.na.ads.idt.com>
	 <1318700142.23438.45.camel@vkoul-udesk3>
	 <CAJe_ZhdjMTsqSTDwV_zaAQKmCbjOtRVc951wxqKScaCR-DBG9Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 22:31:24 +0530
Message-ID: <1318870884.23438.174.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 21:22 +0530, Jassi Brar wrote:
> On 15 October 2011 23:05, Vinod Koul <vinod.koul@intel.com> wrote:
> 
> > Another alternate approach could be to add one more argument to
> > prep_slave_sg API which allows us to pass additional runtime specific
> > parameters. This can be NULL and unused for existing drivers and used in
> > RIO and any future subsystems which want to use dmaengine.
> > Thoughts...?
> >
> That doesn't sound much different than passing the data via
> dma_chan.private during prep_slave_sg. Only now we add to
> the number of arguments.
Yes agreed, but we already decided and marked it as depreciated.

> And then either this argument would be RapidIO specific (unfair
> to other users) or generic. In latter case what would it look like ?
My initial thoughts were to add an argument which only the specific dmac
knows howto decode and is filled by its client. As i said for existing
users and people who don't require dynamic information wouldn't bother.
The pros
 - allows us to support RIO kind of subsystems where one needs to pass
subsystem specific information for programing the dmac
 - doesn't require us to add subsystem specific stuff in dmaengine,
today its RIO tomorrow some other folks may want to add. We want to
maintain dmaengine as a generic framework, while also trying to support
multiple audiences.
Cons:
 - there is no guarantee;  dmac expects foo and clients pass bar

I am okay if we have alternate way to support this with above goal :)

-- 
~Vinod

