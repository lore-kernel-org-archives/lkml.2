Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab2K3Qq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:46:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44323 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab2K3Qqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:46:55 -0500
Date: Fri, 30 Nov 2012 11:46:51 -0500 (EST)
Message-Id: <20121130.114651.461648561907776096.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: thierry.reding@avionic-design.de, sparclinux@vger.kernel.org,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: SPARC and OF_GPIO
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121130093520.631503E070C@localhost>
References: <20121107065258.GA22325@avionic-0098.mockup.avionic-design.de>
	<20121107.023419.1656398773495533906.davem@davemloft.net>
	<20121130093520.631503E070C@localhost>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 30 Nov 2012 09:35:20 +0000

> On non-sparc I've actually been moving in the direction of resolving
> resources at .probe time to make it easier to handle deferred probing.
> So if, for example, a device irq line is routed to a GPIO instead of the
> core interrupt controller, then the irq number won't be known until
> after the gpio driver .probe occurs. For addresses, this situation is
> unlikely, but for all the other kinds of resources (gpios, regs, clocks, irqs,
> etc) it is a problem that we're actually seeing.

Every interrupt in the device tree is resolvable with, at worst, very
small bus drivers, and that's what we pack into the generic sparc OF
device creation layer.

Actually much of it is generic and not bus type specific at all, and
is a simply mask and match into an interrupt routing table property.
