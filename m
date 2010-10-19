Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab0JSPDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:03:54 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:12035
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752516Ab0JSPDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:03:53 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);(null);(null)
X-FB-SS: 5,
X-WSS-ID: 0LAJLT1-02-A3E-02
X-M-MSG: 
Date: Tue, 19 Oct 2010 17:03:03 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>
Subject: Re: [PATCH 5/5] x86, NMI: Remove do_nmi_callback logic
Message-ID: <20101019150303.GQ5969@erda.amd.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
 <1287195738-3136-6-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1287195738-3136-6-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.10.10 22:22:18, Don Zickus wrote:
> From: Huang Ying <ying.huang@intel.com>
> 
> do_nmi_callback related logic is removed, because it is useless, just
> adds code complexity.
> 
> unknown_nmi_panic sysctl is reserved to keep kernel ABI unchanged.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/include/asm/nmi.h    |   10 +++++++++-
>  arch/x86/kernel/apic/hw_nmi.c |    1 -
>  arch/x86/kernel/apic/nmi.c    |   29 +----------------------------
>  arch/x86/kernel/traps.c       |   17 +++++++++++------
>  4 files changed, 21 insertions(+), 36 deletions(-)

> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index accb2f4..9ef8e15 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -83,6 +83,8 @@ EXPORT_SYMBOL_GPL(used_vectors);
>  
>  static int ignore_nmis;
>  
> +int unknown_nmi_panic;

I didn't apply the patches, so I am not really sure, but I think this
could be static now.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

