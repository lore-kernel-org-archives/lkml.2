Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab1G0KR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:17:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:32857 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab1G0KR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:17:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,275,1309762800"; 
   d="scan'208";a="35006662"
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jaswinder Singh <jaswinder.singh@linaro.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linus.walleij@stericsson.com,
        per.friden@stericsson.com, wei.zhang@freescale.com,
        ebony.zhu@freescale.com, iws@ovro.caltech.edu, s.hauer@pengutronix.de,
        maciej.sosnowski@intel.com, saeed@marvell.com, shawn.guo@freescale.com,
        yur@emcraft.com, agust@denx.de, iwamatsu.nobuhiro@renesas.com,
        per.forlin@stericsson.com, jonas.aberg@stericsson.com,
        anemo@mba.ocn.ne.jp
In-Reply-To: <20110727095909.GB16623@intel.com>
References: <CAJe_ZhdYg4EpaNbBW+dayjSORqM=E6myT3oOG5VTsiQnh3erTA@mail.gmail.com>
	 <CABE8wwt8J_r9cExG+EAqqK=XVmAyLYhv+-T49Rr9hhKudD8n2g@mail.gmail.com>
	 <CAJe_ZheVyLk-yqyF_XO80xX3j7_7mDPnv-me+n=X_hNWycSLwg@mail.gmail.com>
	 <CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com>
	 <CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com>
	 <CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com>
	 <CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
	 <1311740499.1536.56.camel@vkoul-udesk3>
	 <CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com>
	 <1311757347.1536.103.camel@vkoul-udesk3> <20110727095909.GB16623@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jul 2011 15:04:24 +0530
Message-ID: <1311759264.1536.113.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 12:59 +0300, Mika Westerberg wrote:
> On Wed, Jul 27, 2011 at 02:32:26PM +0530, Koul, Vinod wrote:
> > Can you please help me understand why channel number "x" is important
> > and strictly needed by some client?
> 
> At least in ep93xx we have even channel numbers for TX and odd for RX (or
> vice versa, can't rememeber). This is a hardware restriction. So the client
> code then filters the channels based on that using ->chan_id.
> 
> As the caps are not per channel, that is the only way I was able to make it
> work.
Thanks, 
Is this a dma controller limitation or due to the fact even channels get
assigned h/w interface corresponding to TX and so on.

At least on dw synopsis controllers all channels are same and you need
to assign the respective h/w interface of the port (rx and tx) you are
transferring to. If we pass and configure this in driver then client
would just need channel with capabilities and not specific number.

I am not sure if this is true for other type of controllers...

-- 
~Vinod

