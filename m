Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0DTNQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 09:16:11 -0400
Received: from 83-238-130-35.ip.netia.com.pl ([83.238.130.35]:58674 "EHLO
	mail.supercomputing.pl" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab0DTNQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:16:09 -0400
Message-ID: <4BCDA912.3070406@supercomputing.pl>
Date: Tue, 20 Apr 2010 15:16:02 +0200
From: nevee <nevee@supercomputing.pl>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: conflicting types for =?UTF-8?B?4oCYc25fZG1hX2ZsdXNo4oCZ?=
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,
I had a problem in arch/ia64/include/asm/sn/io.h:
----------------------------------------------------------------------
arch/ia64/sn/pci/pcibr/pcibr_dma.c:237: error: conflicting types for 
‘sn_dma_flush’
/tmp/linux-2.6.33.2/arch/ia64/include/asm/sn/io.h:21: error: previous 
declaration of ‘sn_dma_flush’ was here
arch/ia64/sn/pci/pcibr/pcibr_dma.c:412: error: conflicting types for 
‘sn_dma_flush’
/tmp/linux-2.6.33.2/arch/ia64/include/asm/sn/io.h:21: error: previous 
declaration of ‘sn_dma_flush’ was here
CC arch/ia64/sn/kernel/huberror.o
make[4]: *** [arch/ia64/sn/pci/pcibr/pcibr_dma.o] Error 1
make[3]: *** [arch/ia64/sn/pci/pcibr] Error 2
make[2]: *** [arch/ia64/sn/pci] Error 2
make[2]: *** Waiting for unfinished jobs....
----------------------------------------------------------------------

Tested versions: 2.6.32.11, 2.6.33.2 also 2.6.34-rc5

arch/ia64/include/asm/sn/io.h:21:

extern void sn_dma_flush(unsigned long);

should be:

extern void sn_dma_flush(unsigned long long);

for:

arch/ia64/sn/pci/pcibr/pcibr_dma.c:237:

void sn_dma_flush(u64 addr)
{...}

After this change, works fine.
Cheers,
nevee
