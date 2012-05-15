Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966704Ab2EOUIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:08:02 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:22552 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966025Ab2EOUH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:07:59 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18KGRogz+D4jUtbjmraAYBf
Date: Tue, 15 May 2012 13:07:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-omap@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that
 supports omap2+ padconf
Message-ID: <20120515200754.GD17852@atomide.com>
References: <20120504150342.GI5140@atomide.com>
 <20120504153251.GE7788@game.jcrosoft.org>
 <20120504163420.GA5613@atomide.com>
 <4FA42631.6060304@wwwdotorg.org>
 <20120504220809.GW5613@atomide.com>
 <4FAAD141.3090306@wwwdotorg.org>
 <20120509204925.GV5088@atomide.com>
 <4FABF553.20601@wwwdotorg.org>
 <CACRpkdbqjofEi-5J+GTMOXFK1VvbXqa6At1fKXCge+5_y6aaRA@mail.gmail.com>
 <4FB1513A.4070002@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB1513A.4070002@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [120514 11:42]:
> On 05/12/2012 05:49 PM, Linus Walleij wrote:
> > On Thu, May 10, 2012 at 7:05 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > 
> >> Also, were you intending pinctrl-simple to actually be the GPIO
> >> controller itself? That'd be another case that one might consider fairly
> >> simple, but then extends to being gpio-simple as well as pinctrl-simple...
> > 
> > We have some pinctrl drivers implementing gpiolib too already,
> > and it's unavoidable I think, as some recent discussion about
> > matcing struct gpio_chip and pinctrl GPIO ranges shows.
> 
> I strongly believe we should only do this when the exact same HW module
> is both pinctrl and GPIO.
> 
> When there are separate HW modules, we should have separate drivers. The
> fact that the two drivers need to co-ordinate with each-other isn't a
> good argument to make them one driver.
> 
> And irrespective of how the drivers are structured, if there are two HW
> modules, we really need two separate nodes in DT to describe them, since
> the SW architecture (1 vs. 2 drivers) shouldn't influence the DT
> representation unduly.

Yes.
 
> > Maybe "-simple" isn't such a good name for this thing. Noone thinks
> > any kind of pin control is simple in any sense of the word anyway :-D
> > 
> > Tony, would pinctrl-dt-only.c be a better name perhaps?
> 
> That might be OK for the filename, but it doesn't seem like a useful
> change for the DT compatible value.

Yeah let's see if we can come up with some better name.

Regards,

Tony
