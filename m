Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab1AQBTv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 20:19:51 -0500
Received: from ozlabs.org ([203.10.76.45]:41785 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab1AQBTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 20:19:48 -0500
From: Jeremy Kerr <jk@ozlabs.org>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Date: Mon, 17 Jan 2011 09:19:44 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
References: <201101111016.42819.jeremy.kerr@canonical.com>
In-Reply-To: <201101111016.42819.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101170919.45100.jk@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Based on the discussion from this thread, my plan is to:

* Change the 'common struct clk' patches to only use a spinlock for locking. 
This means that clk_{en,dis}able will acquire a per-clk spinlock (for enable 
counts), and be callable from atomic contexts.

* Rework the initial docs (posted in the first mail of this thread) document 
to illustrate the new locking requirements.

* Request input from the platforms that require clk_enable (etc) to sleep, 
about how we can merge the two implementations.

Russell - is this OK?

Cheers,


Jeremy
