Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab1AKK10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:27:26 -0500
Received: from adelie.canonical.com ([91.189.90.139]:35864 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab1AKK1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:27:21 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/2] Add a common struct clk
Date: Tue, 11 Jan 2011 18:27:11 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
References: <1294199462.347935.472473715866.0.gpush@pororo> <1294199462.348449.192344022926.1.gpush@pororo> <20110111101636.GF26617@pengutronix.de>
In-Reply-To: <20110111101636.GF26617@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101111827.12291.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,
 
> The i.MX clk implementation disables the old parent if clk is enabled
> and enables the new parent if clk is enabled (modulo bugs). Shouldn't
> we do this here aswell?

Sounds reasonable, yes.

> I thought about returning -EBUSY if clk_set_parent is called for an
> enabled clk, but this way we could never reparent the cpu clock which I
> think is done in the Freescale BSP for power saving.

I think that the possibility for changing the parent really depends on the 
implementation; in some cases we may want to disallow it, in others it might 
be fine.

Related: do we really need globally-accessible clk_{get,set}_parent in the clk 
API? For cases where we need to set the parent, we probably need details about 
the platform clock configuration (eg, which clocks are possible parents). In 
this case, we could just call into the clock driver directly.

Cheers,


Jeremy
