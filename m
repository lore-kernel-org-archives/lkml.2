Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab2HMRiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:38:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47293 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861Ab2HMRiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:38:51 -0400
Date: Mon, 13 Aug 2012 18:38:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] efikamx: reintroduce Genesi Efika MX Smarttop via device
 tree
Message-ID: <20120813173847.GH13446@opensource.wolfsonmicro.com>
References: <1344375978-29981-1-git-send-email-matt@genesi-usa.com>
 <20120809101947.GA8474@sirena.org.uk>
 <CAKGA1bkwMvDW7nMWxUbNm3_0ZTR2+uKs8UL_HuisJe7cd8POBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1bkwMvDW7nMWxUbNm3_0ZTR2+uKs8UL_HuisJe7cd8POBA@mail.gmail.com>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 10:42:58AM -0500, Matt Sealey wrote:
> On Thu, Aug 9, 2012 at 5:19 AM, Mark Brown

> > This and many of your other regulators have voltage ranges specified but
> > no consumers which doesn't make sense.  It looks awfully like you've
> > just typed in the maximum range supported by the regulator which is most
> > likely broken.

> Okay I have a question about this; some of the regulators (SW1
> especially) are obviously consumed by the CPU core complex so that
> when DVFS gives us a hint we can clock down and reduce voltage. How on
> earth do we implement that?

> We can drop the maximum range to be better for the CPU (1.3V is too
> high, I think this is legacy from when we may have had a sorted 1GHz
> MX51 coming out) but I can't find any source for where this is hooked
> in.

DVFS doesn't use the device model in Linux (yet!) so there's no device
node and it's all a bit messy.  Shawn Guo is working on some generic DT
bindings for it which should solve that problem but for now in the
specific case of CPU bindings it's OK to not have an consumer, it's
understandable what's going on there.
