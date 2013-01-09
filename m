Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3AIK0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 05:26:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42600 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab3AIK0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 05:26:06 -0500
Date: Wed, 9 Jan 2013 10:25:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 1/4] gpiolib: introduce descriptor-based GPIO interface
Message-ID: <20130109102548.GD3931@n2100.arm.linux.org.uk>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <1357629535-26033-2-git-send-email-acourbot@nvidia.com> <201301081259.29839.arnd@arndb.de> <CAAVeFu+4VbCbj9TaeMm+NMDJ9_M4-j4O0ONF7Yh_un63wS38+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFu+4VbCbj9TaeMm+NMDJ9_M4-j4O0ONF7Yh_un63wS38+Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 10:06:16AM +0900, Alexandre Courbot wrote:
> On Tue, Jan 8, 2013 at 9:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > Please avoid the use of IS_ERR_OR_NULL(), especially on interfaces you
> > introduce yourself. AFAICT, gpiod_get cannot return NULL, so you
> > should not check for that.
> 
> Sure - you sound like IS_ERR_OR_NULL() is generally considered evil,
> may I ask why this is the case?

I think I've explained that in the past; many people just do not think.
They just use whatever macro they feel like is the right one.  We keep
seeing this, and this is a persistent problem. It's getting to be more
of a problem because people are starting to argue back when you point
out that they're wrong.

People are even starting to believe that documentation which specifies
explicitly "values where IS_ERR() is true are considered errors,
everything else is valid" means that the use of IS_ERR_OR_NULL() in such
cases is permissible.  (I've had such an argument with two people
recently.)

So, interfaces which have well defined return values and even interfaces
which specify _how_ errors should be checked end up being checked with
the wrong macros.  People constantly translate IS_ERR() to IS_ERR_OR_NULL()
even when it's inappropriate.

People don't think and people don't read documentation.  People don't
remember this level of detail.  Whatever the excuse, the problem remains.
IS_ERR_OR_NULL() always gets used inappropriately and without any regard
to whether it's correct or not.

So yes, IS_ERR_OR_NULL() _is_ pure evil.  IMHO this macro is doing more
harm than good.
