Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab2AKNYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 08:24:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45350 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547Ab2AKNYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:24:16 -0500
Date: Wed, 11 Jan 2012 21:35:00 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: Eric Miao <eric.miao@linaro.org>, patches@linaro.org, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        dan.j.williams@intel.com, Richard Zhao <richard.zhao@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/6] dma/imx-sdma: check whether event_id0 < 32 when set
 event_mask
Message-ID: <20120111133458.GD20968@S2101-09.ap.freescale.net>
References: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org>
 <1326178910-14044-6-git-send-email-richard.zhao@linaro.org>
 <20120110142008.GE26599@S2101-09.ap.freescale.net>
 <20120110142939.GB2019@richard-laptop>
 <20120110153836.GA27831@S2101-09.ap.freescale.net>
 <20120111005322.GB2414@b20223-02.ap.freescale.net>
 <20120111014730.GE2414@b20223-02.ap.freescale.net>
 <CAMPhdO9sGWTomtyMSTe_jC2GfvtdLR=M-z3Uzpesm9efBzhSqA@mail.gmail.com>
 <20120111131615.GC20968@S2101-09.ap.freescale.net>
 <20120111130910.GC27484@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111130910.GC27484@b20223-02.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 09:09:11PM +0800, Richard Zhao wrote:
> On Wed, Jan 11, 2012 at 09:16:17PM +0800, Shawn Guo wrote:
> > On Wed, Jan 11, 2012 at 02:37:08PM +0800, Eric Miao wrote:
> > > I think Richard has made the issue quite clear here, the original
> > 
> > Yes, he has made it clear, but only after I asked for more comments,
> > not with the empty commit message.
> > 
> > > code does seem to have some problems even to me, who do not
> > > understand the very details of the SDMA:
> > > 
> > > -                       sdmac->event_mask0 = 1 << sdmac->event_id0;
> > > -                       sdmac->event_mask1 = 1 << (sdmac->event_id0 - 32);
> > > 
> > > 1. if sdmac->event_id0 >= 32, which will cause event_mask0 to be incorrect
> > > 2. if sdmac->event_id < 32, sdmac->event_mask1 will be incorrect
> > > 
> > My testing tells this is not the case.  The event_mask0 will be 0 in
> > case 1) and event_mask1 will be 0 in case 2), which is quite what we
> > expect.  And I do not believe you will see any functionality bug with
> > the existing code.
> Please see my mail mentioned "we shoud not let it depends on gcc's
> behavior."

In this case, I would rather believe that the author is smart enough
to write the code intentionally based on his good understanding on
behavior of arm-gcc.

-- 
Regards,
Shawn
