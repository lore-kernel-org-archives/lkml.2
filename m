Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1HVSvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 14:51:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60799 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab1HVSu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 14:50:57 -0400
Date: Mon, 22 Aug 2011 11:47:43 -0700 (PDT)
Message-Id: <20110822.114743.2119393178497975105.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, davidb@codeaurora.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: of_iomap() matched with plan iounmap()
From: David Miller <davem@davemloft.net>
In-Reply-To: <201108221607.25179.arnd@arndb.de>
References: <201108191426.19152.arnd@arndb.de>
	<20110819.062609.1865751197015675220.davem@davemloft.net>
	<201108221607.25179.arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 22 Aug 2011 11:47:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 22 Aug 2011 16:07:25 +0200

> How about renaming the sparc of_ioremap/of_iounmap pair to
> resource_iomap/resource_iounmap? I believe that it is not
> (any more) tied to device tree based probing at all, and also
> could be useful for other subsystems on non-sparc architectures.

Sure, but it would be even nicer if other platforms used pre-computed
resources :-)

It would make OF devices match how PCI devices are managed, and that's
one of the main reasons I implemented it this way.

I know someone is going to say that OF resource resolution is "hard" or
difficult to untangle with how drivers on other platforms work.  But
that situation only exists because other platforms didn't do preresolved
OF resources from the beginning.

Having resource resolution handling and/or knowledge scattered throughout
all of the non-sparc OF drivers is very unwise.
