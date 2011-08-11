Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1HKV0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:26:07 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:5352 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab1HKV0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:26:05 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1432N98dK4015Lzz1202hzzz32i668h839h944h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LPS8RT-02-E0Z-02
X-M-MSG: 
Date: Thu, 11 Aug 2011 23:23:54 +0200
From: Robert Richter <robert.richter@amd.com>
To: Thomas Meyer <thomas@m3y3r.de>
CC: "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia@diku.dk>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Subject: Re: Missing put_cpu() in arch/s390/oprofile/hwsampler.c?
Message-ID: <20110811212354.GD11702@erda.amd.com>
References: <1312825916.5589.150.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1312825916.5589.150.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.08.11 13:51:53, Thomas Meyer wrote:
> The function hws_oom_callback() seems to miss a corresponding put_cpu().

Yes, it looks broken.

Heinz, can you send a fix please?

Thanks,

-Robert

> 
> Or is this done in another function? I didn't find it.
> 
> thomas
> 
> ---
> 
>  Check for get/put_cpu() imbalances
> 
>  The simplified semantic patch that makes this report is:
> 
> * get_cpu()
> ... when != put_cpu()
> ? get_cpu()
> 
> drivers/crypto/n2_core.c:986:25-26: WARNING: Possible missing put_cpu()!
> drivers/crypto/n2_core.c:1041:25-26: WARNING: Possible missing put_cpu()!
> drivers/scsi/fcoe/fcoe.c:1163:29-30: WARNING: Possible missing put_cpu()!
> drivers/scsi/fcoe/fcoe.c:1630:47-48: WARNING: Possible missing put_cpu()!
> arch/um/sys-i386/ldt.c:53:17-18: WARNING: Possible missing put_cpu()!
> arch/powerpc/kernel/machine_kexec_64.c:188:18-19: WARNING: Possible missing put_cpu()!
> arch/ia64/sn/kernel/sn2/sn_hwperf.c:618:52-53: WARNING: Possible missing put_cpu()!
> arch/s390/oprofile/hwsampler.c:553:16-17: WARNING: Possible missing put_cpu()!
> arch/s390/kernel/vtime.c:430:22-23: WARNING: Possible missing put_cpu()!
> arch/s390/kernel/vtime.c:473:15-16: WARNING: Possible missing put_cpu()!
> arch/blackfin/kernel/cplbinfo.c:89:9-10: WARNING: Possible missing put_cpu()!
> 
> This list contains some false positives.
> 
> Thanks to Julia for the semantic patch to find these kind of errors!
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

