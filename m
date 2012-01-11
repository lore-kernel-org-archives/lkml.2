Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab2AKNtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 08:49:22 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46114 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2AKNtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:49:20 -0500
MIME-Version: 1.0
In-Reply-To: <20120111133458.GD20968@S2101-09.ap.freescale.net>
References: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org>
 <1326178910-14044-6-git-send-email-richard.zhao@linaro.org>
 <20120110142008.GE26599@S2101-09.ap.freescale.net> <20120110142939.GB2019@richard-laptop>
 <20120110153836.GA27831@S2101-09.ap.freescale.net> <20120111005322.GB2414@b20223-02.ap.freescale.net>
 <20120111014730.GE2414@b20223-02.ap.freescale.net> <CAMPhdO9sGWTomtyMSTe_jC2GfvtdLR=M-z3Uzpesm9efBzhSqA@mail.gmail.com>
 <20120111131615.GC20968@S2101-09.ap.freescale.net> <20120111130910.GC27484@b20223-02.ap.freescale.net>
 <20120111133458.GD20968@S2101-09.ap.freescale.net>
From: Eric Miao <eric.miao@linaro.org>
Date: Wed, 11 Jan 2012 21:48:58 +0800
X-Google-Sender-Auth: meKGgkiI4X6et7FoyCGegyQ4hzM
Message-ID: <CAMPhdO_sZGUwNmrrh1uemOff1mzG4WLFPLq2jbPt1n+mfydcpA@mail.gmail.com>
Subject: Re: [PATCH 6/6] dma/imx-sdma: check whether event_id0 < 32 when set event_mask
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Richard Zhao <richard.zhao@freescale.com>, patches@linaro.org,
        vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, dan.j.williams@intel.com,
        Richard Zhao <richard.zhao@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 9:35 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Wed, Jan 11, 2012 at 09:09:11PM +0800, Richard Zhao wrote:
>> On Wed, Jan 11, 2012 at 09:16:17PM +0800, Shawn Guo wrote:
>> > On Wed, Jan 11, 2012 at 02:37:08PM +0800, Eric Miao wrote:
>> > > I think Richard has made the issue quite clear here, the original
>> >
>> > Yes, he has made it clear, but only after I asked for more comments,
>> > not with the empty commit message.
>> >
>> > > code does seem to have some problems even to me, who do not
>> > > understand the very details of the SDMA:
>> > >
>> > > -                       sdmac->event_mask0 = 1 << sdmac->event_id0;
>> > > -                       sdmac->event_mask1 = 1 << (sdmac->event_id0 - 32);
>> > >
>> > > 1. if sdmac->event_id0 >= 32, which will cause event_mask0 to be incorrect
>> > > 2. if sdmac->event_id < 32, sdmac->event_mask1 will be incorrect
>> > >
>> > My testing tells this is not the case.  The event_mask0 will be 0 in
>> > case 1) and event_mask1 will be 0 in case 2), which is quite what we
>> > expect.  And I do not believe you will see any functionality bug with
>> > the existing code.
>> Please see my mail mentioned "we shoud not let it depends on gcc's
>> behavior."
>
> In this case, I would rather believe that the author is smart enough
> to write the code intentionally based on his good understanding on
> behavior of arm-gcc.

Either using the tricky gcc behavior which _will_ vary along version changes,
or using "hard to understand code" is BAD idea. We don't write good code
depending on author's "smartness", we write code so that it's understandable
and maintainable.
