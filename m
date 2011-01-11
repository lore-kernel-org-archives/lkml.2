Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1AKOgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:36:02 -0500
Received: from adelie.canonical.com ([91.189.90.139]:58408 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1AKOf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:35:59 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: Locking in the clk API
Date: Tue, 11 Jan 2011 22:35:42 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
References: <201101111016.42819.jeremy.kerr@canonical.com> <201101111830.18597.jeremy.kerr@canonical.com> <20110111121816.GB774@linux-sh.org>
In-Reply-To: <20110111121816.GB774@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101112235.43061.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> Again, you are approaching it from the angle that an atomic clock is a
> special requirement rather than the default behaviour.

I'm not considering it a special requirement, but it's still a requirement 
(that the called function does not sleep).

The problem with the inverse logic (clk_enable/clk_enable_sleepable) is that 
now you've made the caller need to know what kind of clock it has, or might 
have one day.

 * For clk_enable/clk_enable_atomic, the decision is: is this call in an
   atomic context?

 * For clk_enable/clk_enable_sleepable, the decision is: might the clock code
   have given us a sleeping clock?

Note that it's much easier to guarantee correctness for the first than it is 
for the second.

Cheers,


Jeremy
