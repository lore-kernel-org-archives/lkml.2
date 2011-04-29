Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017Ab1D2Wxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:53:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:41372 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab1D2Wxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:53:54 -0400
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <4DBAA9B4.3070306@vmware.com>
References: <201104212129.17013.arnd@arndb.de>
	 <20110428093039.GU17290@n2100.arm.linux.org.uk>
	 <1304024836.2513.198.camel@pasglop> <201104291326.25634.arnd@arndb.de>
	 <4DBAA9B4.3070306@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Apr 2011 08:53:40 +1000
Message-ID: <1304117620.2513.268.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 14:06 +0200, Thomas Hellstrom wrote:
> I think Jerome has mentioned at one point that the Radeon graphics
> cards support non-coherent mappings.

If the card is PCI/PCI-X/PCIe then coherency is not its business, it's
the business of the host bridge. However, on PCIe at least, the card can
indeed set a "no snoop" attribute on DMA transactions to request "no
coherency". At least the systems have the latitude to just ignore that
bit (like we do on all ppc afaik) :-)

> Fwiw, the PowerVR SGX MMU also supports this mode of operation,
> although  it being functional I guess depends on the system
> implementation.

Right, it's not a GPU thing, it's really a system design thing.

Cheers,
Ben.


