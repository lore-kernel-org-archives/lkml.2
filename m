Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab2BMR0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:26:38 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:40174 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab2BMR0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:26:37 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/2cmZZd+b3ACwHtoc5s1EV
Date: Mon, 13 Feb 2012 09:26:34 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Internal timers in deep sleep
Message-ID: <20120213172633.GA1426@atomide.com>
References: <CAM8FrK++W4ScR-htTDXeA7iniz9LTXB_29yzhDNfOu5=VLC+mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM8FrK++W4ScR-htTDXeA7iniz9LTXB_29yzhDNfOu5=VLC+mQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcus,

* Marcus Folkesson <marcus.folkesson@gmail.com> [120211 03:37]:
> Is it possible to speed up the time it takes to go to/from deepsleep?
> The pm_suspend() does a lot of things, eg. freeze processes, suspend
> drivers and so on.

Depending on the omap, you can already do suspend while idle or off
while idle. This means the RAM is in self-refresh and the omap is
either suspended or powered off in the idle loop. This is typically
done with a combination of constantly running 32 KiHz clocksource and
wake-up capable GPT1 clockevent timer.

If you have similar timers on your hardware, this may be the way to go.
In this case there's no need to freeze processes, so the latency is
quite minimal.

Regards,

Tony
