Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab0ERAvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 20:51:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:34186 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab0ERAvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 20:51:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,250,1272870000"; 
   d="scan'208";a="799332285"
Subject: Re: [PATCH] x86, MCE, fix MSR_IA32_MCI_CTL2 CMCI threshold setup
From: Huang Ying <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4BF18419.5030600@zytor.com>
References: <1274083710.3564.664.camel@yhuang-dev.sh.intel.com>
	 <4BF18419.5030600@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 08:51:45 +0800
Message-ID: <1274143905.3564.1674.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter,

Thanks for review.

On Tue, 2010-05-18 at 01:59 +0800, H. Peter Anvin wrote:
> On 05/17/2010 01:08 AM, Huang Ying wrote:
> > It is reported that CMCI is not raised when number of corrected error
> > reaches preset threshold. After inspection, it is found that
> > MSR_IA32_MCI_CTL2 threshold field is not setup properly. This patch
> > fixed it.
> > 
> > 
> > Changelog:
> > 
> > v2:
> > 
> > - Rename CMCI_EN to MCI_CTL2_CMCI_EN and CMCI_THRESHOLD_MASK to
> >   MCI_CTL2_CMCI_THRESHOLD_MASK to make naming consistent.
> > 
> 
> This looks like a mix of a renaming patch and new functionality.  Please
> submit the renaming as a one patch and then the new functionality as a
> second patch on top, otherwise it gets hard to see what is actually
> going on.
> 
> If I'm not mistaken, there are at least two functionality changes:
> 
> +#define MCI_CTL2_CMCI_THRESHOLD_MASK	0x7fffULL
> -#define CMCI_THRESHOLD_MASK		0xffffULL
> 
> ... change of mask, and:
> 
> -		val |= CMCI_EN | CMCI_THRESHOLD;
> +		val &= ~MCI_CTL2_CMCI_THRESHOLD_MASK;
> +		val |= MCI_CTL2_CMCI_EN | CMCI_THRESHOLD;
> 
> bit being cleared which wasn't before.

This means we need 3 patches?

Best Regards,
Huang Ying


