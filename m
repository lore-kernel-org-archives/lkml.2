Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab1LWPbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 10:31:32 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38986 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab1LWPbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 10:31:31 -0500
Date: Fri, 23 Dec 2011 15:31:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: use usleep_range() instead of
 mdelay()/udelay()
Message-ID: <20111223153129.GC13175@sirena.org.uk>
References: <4EF18515.9030800@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF18515.9030800@linaro.org>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 11:04:53AM +0400, Dmitry Antipov wrote:
> From 00753f3d48c4b6c45c1778c3e37bc9949ed79e77 Mon Sep 17 00:00:00 2001
> From: Dmitry Antipov <dmitry.antipov@linaro.org>
> Date: Wed, 21 Dec 2011 11:01:42 +0400
> Subject: [PATCH] regulator: use usleep_range() instead of mdelay()/udelay()

Follow the instructions in Documentation/SubmittingPatches.

> -			if (delay >= 1000) {
> -				mdelay(delay / 1000);
> -				udelay(delay % 1000);
> -			} else if (delay) {
> -				udelay(delay);
> -			}
> +			usleep_range(delay, delay + 1000);

These two aren't obviously equivalent in several respects and you
haven't provided any explanation for what you're trying to accomplish.
