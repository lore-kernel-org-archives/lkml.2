Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0IMBGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 21:06:12 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:8742 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab0IMBGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 21:06:11 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L8NUWP-01-DOY-02
X-M-MSG: 
Date: Mon, 13 Sep 2010 03:02:49 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR
 error
Message-ID: <20100913010248.GH21909@erda.amd.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-3-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1284087065-32722-3-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.09.10 22:51:02, Huang Ying wrote:
> memory parity error is only valid for IBM PC-AT, newer machine use 7
> bit (0x80) of 0x61 port for PCI SERR. While memory error is usually
> reported via MCE. So corresponding function name and kernel log string
> is changed.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  arch/x86/include/asm/mach_traps.h |    6 +++---
>  arch/x86/kernel/traps.c           |   24 ++++++------------------
>  2 files changed, 9 insertions(+), 21 deletions(-)
> 
> --- a/arch/x86/include/asm/mach_traps.h
> +++ b/arch/x86/include/asm/mach_traps.h
> @@ -9,11 +9,11 @@
>  
>  #define NMI_REASON_PORT		0x61
>  
> -#define NMI_REASON_MEMPAR	0x80
> +#define NMI_REASON_SERR		0x80
>  #define NMI_REASON_IOCHK	0x40
> -#define NMI_REASON_MASK		(NMI_REASON_MEMPAR | NMI_REASON_IOCHK)
> +#define NMI_REASON_MASK		(NMI_REASON_SERR | NMI_REASON_IOCHK)
>  
> -#define NMI_REASON_CLEAR_MEMPAR	0x04
> +#define NMI_REASON_CLEAR_SERR	0x04
>  #define NMI_REASON_CLEAR_IOCHK	0x08
>  #define NMI_REASON_CLEAR_MASK	0x0f

Haven't you introduced *_MEMPAR with patch 1/6?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

