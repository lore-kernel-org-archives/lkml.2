Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab1D2WiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:38:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:53659 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab1D2WiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:38:00 -0400
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        KyongHo Cho <pullip.cho@samsung.com>, linaro-mm-sig@lists.linaro.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <201104292029.50680.arnd@arndb.de>
References: <201104212129.17013.arnd@arndb.de>
	 <20110429075958.GV17290@n2100.arm.linux.org.uk>
	 <20110429093209.1926c732@jbarnes-desktop>
	 <201104292029.50680.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Apr 2011 08:37:17 +1000
Message-ID: <1304116637.2513.252.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 20:29 +0200, Arnd Bergmann wrote:
> 
> If that is the case, we can probably work around this by turning the
> entire
> linear mapping (except for the kernel binary) into nonexecutable mode,
> if we don't do that already.
> This is desirable for security purposes anyway 

You'd still have an "edge" problem if you use large pages for the linear
mapping, you can't obviously make part of the kernel text NX and you'd
have to make sure you 'exclude' from those GPU allocations whatever
overlaps with your last executable large page.

In a way, it's a similar problem I have with bolted memory on BookE
where I can't restrict GPU allocations to memory that isn't bolted :-)

Cheers,
Ben.


