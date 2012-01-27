Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab2A0OcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:32:06 -0500
Received: from smtp-out-222.synserver.de ([212.40.185.222]:1056 "EHLO
	smtp-out-222.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2A0OcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:32:04 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14128
Message-ID: <4F22B593.3010402@metafoo.de>
Date: Fri, 27 Jan 2012 15:32:51 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>, Russell King <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: How is dmaengine_prep_slave_single supposed to be used?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've tried using dmaengine_prep_slave_single in one of my drivers an run
into an issue, the dma_address attribute of the sg element is not
initialized and thus the dma transfer and the DMA transfer fails.

Quoting from Documentation/dmaengine.txt:

   The peripheral driver is expected to have mapped the scatterlist for
   the DMA operation prior to calling device_prep_slave_sg, and must
   keep the scatterlist mapped until the DMA operation has completed.

So this is clearly not the case with dmaengine_prep_slave_single, so I'm
wondering how is ut supposed to be used and can it work properly at all?

Thanks,
- Lars
