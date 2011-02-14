Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1BNTDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:03:31 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:20590
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921Ab1BNTD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:03:28 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGMFJI-01-4W2-02
X-M-MSG: 
Date: Mon, 14 Feb 2011 20:01:57 +0100
From: Robert Richter <robert.richter@amd.com>
To: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
Subject: Re: [patch v2 2/3] This patch enhances OProfile to support System
 zs hardware sampling feature
Message-ID: <20110214190157.GS5874@erda.amd.com>
References: <20110121100651.821690659@linux.vnet.ibm.com>
 <20110121100842.039354578@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110121100842.039354578@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.01.11 05:06:53, Heinz Graalfs wrote:
> From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
> 
> OProfile is enhanced to export all files for controlling System z's hardware sampling,
> and to invoke hwsampler exported functions to initialize and use System z's hardware sampling.
> 
> The patch invokes hwsampler_setup() during oprofile init and exports following
> hwsampler files under oprofilefs if hwsampler's setup succeeded:
> 
> A new directory for hardware sampling based files
> 
>  /dev/oprofile/hwsampling/
> 
> The userland daemon must explicitly write to the following files
> to disable (or enable) hardware based sampling
> 
>  /dev/oprofile/hwsampling/hwsampler
> 
> to modify the actual sampling rate
> 
>  /dev/oprofile/hwsampling/hw_interval
> 
> to modify the amount of sampling memory (measured in 4K pages)
> 
>  /dev/oprofile/hwsampling/hw_sdbt_blocks
> 
> The following files are read only and show
> the possible minimum sampling rate
> 
>  /dev/oprofile/hwsampling/hw_min_interval
> 
> the possible maximum sampling rate
> 
>  /dev/oprofile/hwsampling/hw_max_interval
> 
> The patch splits the oprofile_timer_[init/exit] function so that it can be also called
> through user context (oprofilefs) to avoid kernel oops.
> 
> Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
> Signed-off-by: Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
> Signed-off-by: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
> ---
>  arch/s390/oprofile/Makefile          |    3 
>  arch/s390/oprofile/hwsampler_files.c |  146 +++++++++++++++++++++++++++++++++++
>  arch/s390/oprofile/init.c            |    7 +
>  drivers/oprofile/oprof.c             |   32 +++++++
>  drivers/oprofile/oprof.h             |    2 
>  drivers/oprofile/timer_int.c         |   16 +++
>  include/linux/oprofile.h             |   21 +++++
>  7 files changed, 222 insertions(+), 5 deletions(-)

Applied with following changes:
    * whitespace changes in Makefile and timer_int.c

I reworked some changes in a follow-on patch which I apply on top of
your patch set.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

