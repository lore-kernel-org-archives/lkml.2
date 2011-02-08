Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab1BHH2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 02:28:39 -0500
Received: from adelie.canonical.com ([91.189.90.139]:39579 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1BHH2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 02:28:38 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Date: Tue, 8 Feb 2011 15:28:26 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
References: <1297058877.800158.458894385837.1.gpush@pororo> <201102081054.58005.jeremy.kerr@canonical.com> <4D50B8C0.7050701@bluewatersys.com>
In-Reply-To: <4D50B8C0.7050701@bluewatersys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102081528.27108.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

> If a platform does not provide ops->get_rate and a driver writer does
> not know this, they could naively use the 0 return from clk_get_rate in
> calculations, which is especially bad if they ever divide by the rate.

This would be fairly evident on first boot though :)

> At the very least the documentation for clk_get_rate should state that
> the return value needs to be checked and that 0 means the rate is unknown.

Yes, sounds good. I was hesitant to change the documentation for parts of the 
API that are unchanged, but since we're formalising this 'return 0' behaviour, 
it seems reasonable to update the comment in this case.

> We do currently have the slightly indirect route to getting a clock of
> doing: clk_get -> __clk_get -> clk->ops->get. I'm guessing that the long
> term goal is to remove the middle step once everything is using the
> common clock api?

That may never happen; I imagine that some platforms won't be converted at 
all.

 __clk_get has previously been used as a platform-specific hook to do 
refcounting, which is exactly what we're doing here (via ops->get), so thought 
it was best to use the existing __clk_get name to do this.

> Also, how come you decided to keep the clk_get -> __clk_get call in
> clkdev.c, but ifdef'ed clk_put? If you just leave clk_put as is in
> clkdev.c and change clk_put to __clk_put in the generic clock code then
> you need zero changes to clkdev.c

Yep, makes sense, I'll look at doing this.

> Okay. Should we document for the implementer that clk_enable/disable
> must not sleep then? I don't think atomically is necessarily the right
> word to use here. For example Documentation/serial/driver uses "This
> call must not sleep".

OK, I'll clarify the comment.

Cheers,


Jeremy
