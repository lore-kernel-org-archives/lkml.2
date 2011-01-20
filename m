Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1ATRDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:03:05 -0500
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:45165 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752240Ab1ATRDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:03:02 -0500
Message-ID: <4D386ABF.9060908@fluff.org>
Date: Thu, 20 Jan 2011 17:02:55 +0000
From: Ben Dooks <ben-linux@fluff.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Richard Zhao <linuxzsc@gmail.com>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com>	<20110111091607.GI12552@n2100.arm.linux.org.uk>	<201101111744.59712.jeremy.kerr@canonical.com>	<20110111103929.GN24920@pengutronix.de> <AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com>
In-Reply-To: <AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/11 11:15, Richard Zhao wrote:
> 2011/1/11 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:

[snip]

> A well running board will not enable/disable PLLs frequently. It don't
> make sense. PLLs are normally disabled on request to enter low power
> mode, rather not because all their child clocks are disabled.   So we
> don't have to consider the time here.

I'd rather see that if all child clocks are disabled the PLL is
powered down then. It means PLLs _could_ be left running even
when power-down mode is selected because the system still thinks
that a peripheral is using them.

If you want to make it so that each low-power mode has to work
out what PLLs need to be disabled and then re-enabled makes me
want to be sick. Hiding this stuff behind specific implementations
is a recipe for disaster.
