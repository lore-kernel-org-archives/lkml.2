Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab1D2WzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:55:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:36613 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab1D2WzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:55:20 -0400
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <BANLkTinNMxpAcjpBR7r1f1RA31kww=v6Fw@mail.gmail.com>
References: <201104212129.17013.arnd@arndb.de>
	 <20110428093039.GU17290@n2100.arm.linux.org.uk>
	 <1304024836.2513.198.camel@pasglop> <201104291326.25634.arnd@arndb.de>
	 <4DBAA9B4.3070306@vmware.com>
	 <BANLkTinNMxpAcjpBR7r1f1RA31kww=v6Fw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Apr 2011 08:55:06 +1000
Message-ID: <1304117706.2513.269.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 09:34 -0400, Jerome Glisse wrote:
> 
> Radeon memory controller can do non snooped pci transaction, as far as
> i have tested most of the x86 pci bridge don't try to be coherent then
> ie they don't analyze pci dma and ask for cpu flush they just perform
> the request (and i guess it's what all bridge will do), so it endup
> being noncoherent. I haven't done any benchmark of how faster it's for
> the GPU when it's not snooping but i guess it can give 50% boost as it
> likely drastictly reduce pci transaction overhead.
> 
> I am talking here about device that you plug into any pci or pcie
> slot, so it's not igp integrated into northbridge or into the cpu.

Right, the card has nothing to do with the snooping process, it's purely
a feature of the bridge, based on a flag optionally set by the card. As
I said earlier, bridges have the freedom to ignore it, which we do on
ppc, so that's a non issue.

Cheers,
Ben.

