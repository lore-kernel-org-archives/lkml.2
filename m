Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab2KGHeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:34:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35722 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2KGHeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:34:23 -0500
Date: Wed, 07 Nov 2012 02:34:19 -0500 (EST)
Message-Id: <20121107.023419.1656398773495533906.davem@davemloft.net>
To: thierry.reding@avionic-design.de
Cc: sparclinux@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: SPARC and OF_GPIO
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121107065258.GA22325@avionic-0098.mockup.avionic-design.de>
References: <20121105095315.GG5847@avionic-0098.mockup.avionic-design.de>
	<20121106.184058.636480855516538607.davem@davemloft.net>
	<20121107065258.GA22325@avionic-0098.mockup.avionic-design.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@avionic-design.de>
Date: Wed, 7 Nov 2012 07:52:58 +0100

> It seems like OF_ADDRESS would be trickier. A comment around line 60 in
> drivers/of/platform.c says that SPARC doesn't need functions defined in
> the enclosing #ifdef CONFIG_OF_ADDRESS block. I'm not sure it would be
> acceptable to remove the conflict nonetheless, even if the functions
> aren't used. One benefit would be that the code could receive some extra
> compile coverage.
 ...
> Finally, OF_IRQ is again just generic code to map device tree data to
> IRQ domains. While I didn't see the IRQ_DOMAIN symbol selected anywhere
> in SPARC it should still be possible to run drivers that properly
> implement IRQ domains on SPARC, right? Or is there any reason why they
> wouldn't work?

These are the two most conflicted areas for Sparc.

For addresses, we fully compute the full fully resolved physical
address of all registers of an OF device very early at bootup time
when we first scan the device tree.

Same goes for interrupts, we fully compute them early in the bootup
process.  Also, we support multiple interrupts for a device.
