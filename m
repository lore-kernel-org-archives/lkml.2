Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1DSXTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:19:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496Ab1DSXTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:19:45 -0400
Date: Tue, 19 Apr 2011 16:19:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kernel@pengutronix.de
Subject: Re: [PATCH] leds: provide helper to register "leds-gpio" devices
Message-Id: <20110419161913.a1c18599.akpm@linux-foundation.org>
In-Reply-To: <20110405163338.GA11832@n2100.arm.linux.org.uk>
References: <20110405073030.GI13963@pengutronix.de>
	<1301992655-8514-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<20110405163338.GA11832@n2100.arm.linux.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 17:33:39 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Tue, Apr 05, 2011 at 10:37:35AM +0200, Uwe Kleine-K__nig wrote:
> > +struct platform_device *__init gpio_led_register_device(
> > +		const struct gpio_led_platform_data *pdata);
> 
> Please don't add __init annotations to declarations.

Reasons?

A year or so ago we had to *add* an __init to a declaration, because
one architecture was generating a short-mode-addressing relative branch
to the callee, assuming the target was in the same section as the call
site.  When the linker went to resolve the branch, it discovered that
the target was in fact in a different section and was too far away to
be able to use the short-mode addressing.  IIRC, that architecture was
arm.

