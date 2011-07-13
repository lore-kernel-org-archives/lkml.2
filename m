Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1GMOqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 10:46:01 -0400
Received: from void.printf.net ([89.145.121.20]:43559 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab1GMOp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 10:45:59 -0400
From: Chris Ball <cjb@laptop.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org, matsumur@nts.ricoh.co.jp,
        linux-pci@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock frequency
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com>
	<alpine.DEB.2.02.1107121123140.1767@lazy>
	<m2ei1v76f1.fsf@bob.laptop.org> <201107122000.50309.arnd@arndb.de>
Date: Wed, 13 Jul 2011 10:45:44 -0400
In-Reply-To: <201107122000.50309.arnd@arndb.de> (Arnd Bergmann's message of
	"Tue, 12 Jul 2011 20:00:50 +0200")
Message-ID: <m2sjqa2q93.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Jul 12 2011, Arnd Bergmann wrote:
> I would very much expect that to be nonreproducible. The first row
> in each test is the result of a single write() system call and does
> not get averaged out. More importantly the time for each write
> depends a lot of the state of the card before the write.
>
> For instance when you do a lot of random writes to a card, optionally
> take it out and put it into a different machine, and then do a large
> linear write, that linear write will be very slow because the
> card has to garbage collect all the random writes that were done
> earlier. After a few writes (usually one is enough), it gets back
> to the full performance.

That makes sense.  Do you think this explains Manoj getting a slower
first file copy speed (757ms vs. 480ms) after applying his patch?
(Manoj, perhaps you could retry your test without GC being needed?)

What would we expect lowering the SD base clock frequency from 200MHz
to 50MHz to do to performance theoretically?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
