Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab1JXPgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:36:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:26999 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390Ab1JXPga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:36:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="66272642"
Subject: RE: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>,
        Russell King <rmk@arm.linux.org.uk>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E5520236801F@CORPEXCH1.na.ads.idt.com>
References: <CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com>
	 <CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202321E20@CORPEXCH1.na.ads.idt.com>
	 <CAJe_ZhfWcUY2ctUFt0iUf2FOfjKj1Aa8hQH5LqFG+bZ+93CcNQ@mail.gmail.com>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202321F65@CORPEXCH1.na.ads.idt.com>
	 <CAJe_ZhfTg17YgyQ9TuKdhtXMu+8W_E2t3cBqZybfarxWu9Zasg@mail.gmail.com>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E552023220AC@CORPEXCH1.na.ads.idt.com>
	 <CAJe_ZhdBSxvH6Zd8JsoLrerapNbLn0a7Lv6KxwivbFuLaSavyg@mail.gmail.com>
	 <20111018074211.GA13483@flint.arm.linux.org.uk>
	 <CAJe_ZhdHcsBNT6iX7TJCqoGZMrPwE2BOt06e8M8PHzuDe3Z70w@mail.gmail.com>
	 <20111018094944.GA30644@flint.arm.linux.org.uk>
	 <CAJe_ZhcDJjP3t_XFG04or4WzwzPHEcHo2ThstGCVFrYvYqTaiQ@mail.gmail.com>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E552023672A3@CORPEXCH1.na.ads.idt.com>
	 <1319428149.9355.60.camel@vkoul-udesk3>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E5520236801F@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Oct 2011 20:57:04 +0530
Message-ID: <1319470024.20054.10.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-24 at 05:36 -0700, Bounine, Alexandre wrote:
> > I think we all agree that this fits the dma_slave case :)
> > 
> > As for changing in dmaengine to u64, if we are thinking this as
> slave
> > usage, then ideally we should not make assumption of the address
> type
> > of
> > peripheral so we should only move the dma_slave_config address
> fields
> > to
> > u64, if that helps in RIO case. Moving other usages would be insane.
> > 
> > At this point we have two proposals
> > a) to make RIO exceptional case and add RIO specific stuff.
> > b) make dmaengine transparent and add additional argument
> > in .device_prep_slave_sg() callback which is subsystem dependent.
> > Current dmacs and those who don't need it will ignore it.
> > 
> > ATM, I am leaning towards the latter, for the main reason to keep
> > dmaengine away from subsystem details.
> > 
> Both proposals will work for RapidIO but second option looks more
> universal and may be used by another subsystem in the future.
> My vote goes to the option b). 
Thanks for the vote :D

I would really like to hear from Dan, Jassi and Russell as well.


-- 
~Vinod

