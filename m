Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1EDJQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:16:25 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:64101 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750888Ab1EDJQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:16:24 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18xQShSab+V8BL+Q4AY8GHP
Date: Wed, 4 May 2011 02:16:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
Message-ID: <20110504091619.GV2092@atomide.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@stericsson.com> [110502 12:13]:

Good to see this, looks like this should work for omaps too.

The numbering solves the issue where we have multiple
pinmux domains (base + offset for each domain).

Then I would assume that for most cases the pin access can be
described with:

unsigned long pinmux_base;	/* Can have multiple pinux domains */
u16 pinmux_reg_offset;		/* Register offset from pinmux_base */
u16 flags;			/* Register width etc */

Which can be accessed with read[bwl] and write[bwl], so we
can have default access functions in the pinux framework and
don't necessarily have to implement them for each platform.

Does this work for you? If so, then we can have the data in the
same format for all the architectures for devicetree.

And then we can have pin_get and pin_set functions, so platforms
can implement their custom flags like wake-up trigger etc with
just read[bwl] and write[bwl].

Also noticed one typo:

> +/* Plobal array of descriptors, one for each physical pin */
> +static DEFINE_SPINLOCK(pin_desc_lock);
> +static struct pin_desc pin_desc[MACH_NR_PINS];

s/Plobal/Global/

Regards,

Tony

