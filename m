Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab2AKNJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 08:09:22 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:24654
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218Ab2AKNJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:09:20 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dhc1ahc1bh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Date: Wed, 11 Jan 2012 21:09:11 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Eric Miao <eric.miao@linaro.org>, <patches@linaro.org>,
        <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <kernel@pengutronix.de>, <dan.j.williams@intel.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/6] dma/imx-sdma: check whether event_id0 < 32 when set
 event_mask
Message-ID: <20120111130910.GC27484@b20223-02.ap.freescale.net>
References: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org>
 <1326178910-14044-6-git-send-email-richard.zhao@linaro.org>
 <20120110142008.GE26599@S2101-09.ap.freescale.net>
 <20120110142939.GB2019@richard-laptop>
 <20120110153836.GA27831@S2101-09.ap.freescale.net>
 <20120111005322.GB2414@b20223-02.ap.freescale.net>
 <20120111014730.GE2414@b20223-02.ap.freescale.net>
 <CAMPhdO9sGWTomtyMSTe_jC2GfvtdLR=M-z3Uzpesm9efBzhSqA@mail.gmail.com>
 <20120111131615.GC20968@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120111131615.GC20968@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 09:16:17PM +0800, Shawn Guo wrote:
> On Wed, Jan 11, 2012 at 02:37:08PM +0800, Eric Miao wrote:
> > I think Richard has made the issue quite clear here, the original
> 
> Yes, he has made it clear, but only after I asked for more comments,
> not with the empty commit message.
> 
> > code does seem to have some problems even to me, who do not
> > understand the very details of the SDMA:
> > 
> > -                       sdmac->event_mask0 = 1 << sdmac->event_id0;
> > -                       sdmac->event_mask1 = 1 << (sdmac->event_id0 - 32);
> > 
> > 1. if sdmac->event_id0 >= 32, which will cause event_mask0 to be incorrect
> > 2. if sdmac->event_id < 32, sdmac->event_mask1 will be incorrect
> > 
> My testing tells this is not the case.  The event_mask0 will be 0 in
> case 1) and event_mask1 will be 0 in case 2), which is quite what we
> expect.  And I do not believe you will see any functionality bug with
> the existing code.
Please see my mail mentioned "we shoud not let it depends on gcc's
behavior."
> 
> See, that's why we need verbose commit message to make the patch and
> the problem it's trying to address very clear.
I never doubt it.

Thanks
Richard
> 
> Regards,
> Shawn
> 

