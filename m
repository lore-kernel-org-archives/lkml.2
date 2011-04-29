Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1D2LVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 07:21:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54596 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1D2LVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 07:21:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Date: Fri, 29 Apr 2011 13:21:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201104212129.17013.arnd@arndb.de> <20110428131531.GK17290@n2100.arm.linux.org.uk> <1304036754.2513.201.camel@pasglop>
In-Reply-To: <1304036754.2513.201.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104291321.16191.arnd@arndb.de>
X-Provags-ID: V02:K0:faj4QMQtkOaSSntxnCWZnKaTekN5hCd0Ir51cSwu3e/
 PiEe1wpI2WaaIO7288IxJwIl2aiU6oHFn1ldnHUb9vYZYRmPET
 qQ7rZBvm1VeWE+va1SCOcGuTLlke0fsjhJW6fz1bxZWYzEVM7e
 JMBuTUDgMmwvHXLBvqxry5LNRzQ4Bo7PlB5e5Tb/7bwnVI4CCn
 paNgmoJSt36WWNEcAEAuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 April 2011, Benjamin Herrenschmidt wrote:
> 
> > However, dma_alloc_coherent() memory can't be used with the dma_sync_*
> > API as its return address (unlike other architectures) is not in the
> > kernel direct mapped memory range.
> 
> Well, on non-coherent architectures, dma_sync_* are cache flushes, I
> don't see the point of doing those on a non-cachable mapping anyways.
> 
The point was that you cannot do

#define dma_alloc_coherent dma_alloc_noncoherent

on ARM, as some other architectures do.

	Arnd
