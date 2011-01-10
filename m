Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1AJUYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:24:52 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:42426 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab1AJUYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:24:51 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V8 12/13] ptp: Added a clock driver for the IXP46x.
References: <cover.1293820862.git.richard.cochran@omicron.at>
	<8151196c018776704df34748f333bdb159497d0b.1293820862.git.richard.cochran@omicron.at>
	<m3ei8plpa0.fsf@intrepid.localdomain>
	<20110107170752.GB8666@riccoc20.at.omicron.at>
Date: Mon, 10 Jan 2011 21:24:15 +0100
In-Reply-To: <20110107170752.GB8666@riccoc20.at.omicron.at> (Richard Cochran's
	message of "Fri, 7 Jan 2011 18:07:52 +0100")
Message-ID: <m31v4kpkwg.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Cochran <richardcochran@gmail.com> writes:

> But before that, I have a big favor to ask you. Can you please look at
> the TODO in my patch and give me a hint? I don't know how to relate
> the port instance (NPE A,B,C) to the two time stamping channels.

I assume you mean this:
+ * PHYSICAL_ID(p->id) ?
+ * TODO - Figure out correct mapping.

Unfortunately I can's find this information in the devel manual. I think
there are 3 channels (not two), each for one Ethernet port. IXP465 can
have a port on each NPE.

PHYSICAL_ID etc. are described at the start of the file:
 * logical port         0x00            0x10            0x20
 * NPE                  0 (NPE-A)       1 (NPE-B)       2 (NPE-C)
 * physical PortId      2               0               1

This means the first port (usually "eth0") is connected to NPE-B, the
second port to NPE-C, and the third port to NPE-A (not available on
IXP42x).

Also, the manual says NPE-B can serve 3 additional Ethernet ports
(6 total).

I only have access to IXP425 (and 421) hardware. I think someone with
the actual IXP465 has to check the details.
-- 
Krzysztof Halasa
