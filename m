Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab2ENSiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:38:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49183 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2ENSix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:38:53 -0400
Message-ID: <4FB1513A.4070002@wwwdotorg.org>
Date: Mon, 14 May 2012 12:38:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Tony Lindgren <tony@atomide.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-omap@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that supports
 omap2+ padconf
References: <20120503065131.GA3738@game.jcrosoft.org> <20120503152708.GC5140@atomide.com> <4FA30805.5050804@wwwdotorg.org> <20120504044305.GD7788@game.jcrosoft.org> <20120504150342.GI5140@atomide.com> <20120504153251.GE7788@game.jcrosoft.org> <20120504163420.GA5613@atomide.com> <4FA42631.6060304@wwwdotorg.org> <20120504220809.GW5613@atomide.com> <4FAAD141.3090306@wwwdotorg.org> <20120509204925.GV5088@atomide.com> <4FABF553.20601@wwwdotorg.org> <CACRpkdbqjofEi-5J+GTMOXFK1VvbXqa6At1fKXCge+5_y6aaRA@mail.gmail.com>
In-Reply-To: <CACRpkdbqjofEi-5J+GTMOXFK1VvbXqa6At1fKXCge+5_y6aaRA@mail.gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2012 05:49 PM, Linus Walleij wrote:
> On Thu, May 10, 2012 at 7:05 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> Also, were you intending pinctrl-simple to actually be the GPIO
>> controller itself? That'd be another case that one might consider fairly
>> simple, but then extends to being gpio-simple as well as pinctrl-simple...
> 
> We have some pinctrl drivers implementing gpiolib too already,
> and it's unavoidable I think, as some recent discussion about
> matcing struct gpio_chip and pinctrl GPIO ranges shows.

I strongly believe we should only do this when the exact same HW module
is both pinctrl and GPIO.

When there are separate HW modules, we should have separate drivers. The
fact that the two drivers need to co-ordinate with each-other isn't a
good argument to make them one driver.

And irrespective of how the drivers are structured, if there are two HW
modules, we really need two separate nodes in DT to describe them, since
the SW architecture (1 vs. 2 drivers) shouldn't influence the DT
representation unduly.

> Maybe "-simple" isn't such a good name for this thing. Noone thinks
> any kind of pin control is simple in any sense of the word anyway :-D
> 
> Tony, would pinctrl-dt-only.c be a better name perhaps?

That might be OK for the filename, but it doesn't seem like a useful
change for the DT compatible value.
