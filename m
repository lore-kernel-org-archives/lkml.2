Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1I0MNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:13:39 -0400
Received: from sestofw01.enea.se ([192.36.1.252]:17722 "HELO mx-3.enea.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753772Ab1I0MNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:13:38 -0400
Message-ID: <4E81BDEE.2080601@enea.com>
Date: Tue, 27 Sep 2011 14:13:34 +0200
From: Arvid Brodin <arvid.brodin@enea.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-embedded@vger.kernel.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>, <arnd@arndb.de>
Subject: Re: dma_unmap_single() lacking cache sync on some archs?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.23.1.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending with CC to affected parties]

Hi,

I would expect cache synchronization for DMA_TO_DEVICE and DMA_BIDIRECTIONAL
when dma_map_single() is called, and for DMA_FROM_DEVICE and DMA_BIDIRECTIONAL
when dma_unmap_single() is called.

However, on some architechtures (at least avr32, blackfin, ...), cache
synchronization only happens when dma_map_single() is called (and then
irrespective of DMA direction). dma_unmap_single() is a no-op for these archs.

See e.g. http://lxr.linux.no/#linux+v3.0.4/arch/avr32/include/asm/dma-mapping.h#L117

Isn't this a bug?

(Please CC me in responses.)

-- 
Arvid Brodin
Enea Services Stockholm AB

