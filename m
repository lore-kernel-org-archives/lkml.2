Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1EJWhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:37:03 -0400
Received: from mail.perches.com ([173.55.12.10]:1450 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab1EJWhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:37:02 -0400
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>
In-Reply-To: <BANLkTi=XSevO72NqCYOYuketjE8XjeQU+A@mail.gmail.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
	 <1304365077.7792.40.camel@Joe-Laptop>
	 <BANLkTi=XSevO72NqCYOYuketjE8XjeQU+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 15:37:00 -0700
Message-ID: <1305067020.19586.130.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 00:18 +0200, Linus Walleij wrote:
> 2011/5/2 Joe Perches <joe@perches.com>:
> > On Mon, 2011-05-02 at 21:16 +0200, Linus Walleij wrote:
> >> From: Linus Walleij <linus.walleij@linaro.org>
> >> diff --git a/drivers/pinmux/core.c b/drivers/pinmux/core.c
> > Trivial comments follow
> >> +static inline int pin_is_valid(int pin)
> >> +{
> >> +     return ((unsigned)pin) < MACH_NR_PINS;
> >> +}
> > Couldn't pin just be declared unsigned or maybe u32?
> No, because like in the GPIO subsystem you *may* want to send in invalid
> pins, and those are identified by negative numbers.

Then I think this is clearer and the compiler
should produce the same code.

static inline bool pin_is_valid(int pin)
{ 
	return pin >= 0 && pin < MACH_NR_PINS;
}

cheers, Joe

