Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab0G3Sq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:46:56 -0400
Received: from exprod7ob116.obsmtp.com ([64.18.2.218]:60030 "EHLO
	exprod7ob116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759736Ab0G3Sqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 14:46:39 -0400
Message-ID: <4C52ED8C.9070709@genband.com>
Date: Fri, 30 Jul 2010 09:19:40 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davem@davemloft.net
Subject: where are the memory barriers in net driver rx DMA operations?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2010 15:19:41.0984 (UTC) FILETIME=[A2340A00:01CB2FFA]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17538.007
X-TM-AS-Result: No-1.374100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Documentation/DMA-API-HOWTO.txt says that memory barriers are still
required when accessing consistent mappings.  The example they give is
for reordering stores to consistent memory but I assume this also
applies to reordering loads.

However, I see many net drivers accessing the descriptor ring (in
consistent memory), checking the status bit for the buffer, then calling
dma_unmap_single() and accessing the data without any explicit memory
barrier.  Does the unmapping call act as a barrier in this case?

Thanks,

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
