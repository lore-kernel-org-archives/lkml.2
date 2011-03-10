Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1CJNt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:49:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41839 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752699Ab1CJNtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:49:55 -0500
Date: Thu, 10 Mar 2011 13:49:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/4] regulator: add ab8500 per-regulator startup delay
Message-ID: <20110310134953.GE22195@opensource.wolfsonmicro.com>
References: <1299764621-2532-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299764621-2532-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 02:43:41PM +0100, Linus Walleij wrote:
> From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> 
> Since some regulators can take some time to come online, we
> define a per-regulator millisecond delay value and assign
> to the slow TV-out regulator.

You should be implementing the enable_time() operation for the regulator
for this.  The core will deal with inserting the delays for you (and
will hopefully at some point be able to do something sensible with this
for the bulk_ operations).
