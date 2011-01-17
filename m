Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1AQB1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 20:27:54 -0500
Received: from adelie.canonical.com ([91.189.90.139]:36926 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1AQB1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 20:27:53 -0500
To: linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Mon, 17 Jan 2011 09:27:43 +0800
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101170927.44239.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Based on the discussion from this thread, my plan is to:

* Change the 'common struct clk' patches to only use a spinlock for locking. 
This means that clk_{en,dis}able will acquire a per-clk spinlock (for enable 
counts), and be callable from atomic contexts.

* Rework the initial docs (posted in the first mail of this thread) to 
illustrate the new locking requirements.

* Request input from the platforms that require clk_enable (etc) to sleep, 
about how we can merge the two implementations.

Russell - is this OK?

Cheers,


Jeremy
