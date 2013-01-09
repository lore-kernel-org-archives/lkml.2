Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3AIKo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 05:44:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42625 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3AIKo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 05:44:26 -0500
Date: Wed, 9 Jan 2013 10:44:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>, linux-arch@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 1/4] gpiolib: introduce descriptor-based GPIO interface
Message-ID: <20130109104414.GF3931@n2100.arm.linux.org.uk>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <201301081259.29839.arnd@arndb.de> <CAAVeFu+4VbCbj9TaeMm+NMDJ9_M4-j4O0ONF7Yh_un63wS38+Q@mail.gmail.com> <201301091035.23206.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301091035.23206.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 10:35:22AM +0000, Arnd Bergmann wrote:
> On Wednesday 09 January 2013, Alexandre Courbot wrote:
> > On Tue, Jan 8, 2013 at 9:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > Please avoid the use of IS_ERR_OR_NULL(), especially on interfaces you
> > > introduce yourself. AFAICT, gpiod_get cannot return NULL, so you
> > > should not check for that.
> > 
> > Sure - you sound like IS_ERR_OR_NULL() is generally considered evil,
> 
> Correct.
> 
> > may I ask why this is the case?
> 
> It's very hard to get right: either you are interested in the error code,
> and then you don't have one in some cases, or you don't care but have
> to check for it anyway. When you define a function, just make it clear
> what the expected return values are, either NULL for error or a negative
> ERR_PTR value, but not both.

Indeed, and any code which does this:

	if (IS_ERR_OR_NULL(ptr))
		return PTR_ERR(ptr);

is buggy because on NULL it returns 0, which is generally accepted as being
"success".
