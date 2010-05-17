Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab0EQSAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:00:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48144 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab0EQSAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:00:48 -0400
Message-ID: <4BF18419.5030600@zytor.com>
Date: Mon, 17 May 2010 10:59:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, MCE, fix MSR_IA32_MCI_CTL2 CMCI threshold setup
References: <1274083710.3564.664.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1274083710.3564.664.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 01:08 AM, Huang Ying wrote:
> It is reported that CMCI is not raised when number of corrected error
> reaches preset threshold. After inspection, it is found that
> MSR_IA32_MCI_CTL2 threshold field is not setup properly. This patch
> fixed it.
> 
> 
> Changelog:
> 
> v2:
> 
> - Rename CMCI_EN to MCI_CTL2_CMCI_EN and CMCI_THRESHOLD_MASK to
>   MCI_CTL2_CMCI_THRESHOLD_MASK to make naming consistent.
> 

This looks like a mix of a renaming patch and new functionality.  Please
submit the renaming as a one patch and then the new functionality as a
second patch on top, otherwise it gets hard to see what is actually
going on.

If I'm not mistaken, there are at least two functionality changes:

+#define MCI_CTL2_CMCI_THRESHOLD_MASK	0x7fffULL
-#define CMCI_THRESHOLD_MASK		0xffffULL

... change of mask, and:

-		val |= CMCI_EN | CMCI_THRESHOLD;
+		val &= ~MCI_CTL2_CMCI_THRESHOLD_MASK;
+		val |= MCI_CTL2_CMCI_EN | CMCI_THRESHOLD;

bit being cleared which wasn't before.

	-hpa
