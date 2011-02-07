Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1BGIIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:08:53 -0500
Received: from adelie.canonical.com ([91.189.90.139]:54629 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab1BGIIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:08:51 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [RFC, PATCH 3/3] clk: add warnings for incorrect enable/prepare semantics
Date: Mon, 7 Feb 2011 16:08:40 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
References: <201102011711.31258.jeremy.kerr@canonical.com> <1297058877.800990.238556019385.3.gpush@pororo> <20110207080555.GC27982@pengutronix.de>
In-Reply-To: <20110207080555.GC27982@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102071608.42855.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

> This implies the warning is only issued on clocks that have a prepare
> callback.  If we want to enforce the new API the warning here shouldn't
> depend on clk->ops->prepare.  (clk_prepare and clk_unprepare need to
> be changed then to adapt the prepare_count even in the absence of
> clk->ops->prepare.)

Yeah, it's a decision about either adding a small cost to all clk_prepare()s 
(ie, adding cost when there is no prepare callback), or checking for the 
correct prepare/enable semantics for all clocks (even when it doesn't matter 
for that particular clock). I chose the first as more important, but happy to 
go either way here.

Cheers,


Jeremy
