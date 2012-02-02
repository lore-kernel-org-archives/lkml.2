Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab2BBXDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:03:24 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:30802 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab2BBXDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:03:22 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18vNt5b0/u7Y1clIr8+f8Ux
Date: Thu, 2 Feb 2012 15:03:17 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2] pinctrl: pin configuration states
Message-ID: <20120202230317.GA1426@atomide.com>
References: <1328124889-9780-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328124889-9780-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Linus Walleij <linus.walleij@stericsson.com> [120201 11:04]:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This introduce a pin configuration state structure and activation
> functions similar to the pinmux map. It basically names a few
> states and define the custom configuration values to be applied to
> groups and pins alike when switching to a certain state.
...

> +For simple systems that just configure the pins on boot and then forget about
> +them, the first configuration table may be sufficient. However some systems
> +may need to switch configuration states at runtime, and in that case the
> +system may want to ground both pins by simply calling:
> +
> +ret = pinconf_activate_state("pinctrl-foo", "idle");

For dynamic changing of pin states during runtime we should not change
the states based on string parsing. This is because some of these pins
may need to be changed every time when entering and exiting idle.

Or did I miss something after a quick glance of this?

Regards,

Tony
