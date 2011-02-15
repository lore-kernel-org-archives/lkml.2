Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab1BOJdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:33:54 -0500
Received: from adelie.canonical.com ([91.189.90.139]:39432 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1BOJdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:33:49 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Date: Tue, 15 Feb 2011 17:33:29 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: Saravana Kannan <skannan@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>, Ben Dooks <ben-linux@fluff.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>
References: <1297233693.242364.862698430999.1.gpush@pororo> <201102151526.54280.jeremy.kerr@canonical.com> <20110215083759.GA4152@n2100.arm.linux.org.uk>
In-Reply-To: <20110215083759.GA4152@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102151733.30332.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

> > Why is that? Consider two devices using one clock; one does some
> > initialisation based on the return value of clk_get_rate(), the other
> > calls clk_set_rate() some time later. Now the first device is
> > incorrectly initialised.
> 
> What about a clock sourced from a PLL which provides the dotclock for a
> framebuffer device?  On every mode set, should the clk have to be disabled,
> unprepared, rate set, re-prepared and re-enabled?

Sounds heavy-handed, but I honestly have no idea if that's reasonable or not.

Other options are:

 * Require that the driver has called clk_prepare, and that prepare_count
   is 1 during the set_rate call (indicating that this is the only user); or

 * Leave the set_rate and set_parent semantics as-is and assume that anything
   calling either knows what it's doing (and that it won't affect other
   devices)

Are you OK if we address this separately to the API unification though?

Cheers,


Jeremy
