Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab0FNIYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:24:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48009 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab0FNIYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:24:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C15E710.9040002@jp.fujitsu.com>
Date: Mon, 14 Jun 2010 17:23:44 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2/4] x86: ioremap: fix physical address check
References: <4C11FF10.4060203@jp.fujitsu.com> <4C11FFC0.1030006@jp.fujitsu.com> <4C1275BF.3070605@zytor.com> <4C158BCF.6000303@jp.fujitsu.com> <alpine.LFD.2.00.1006140735040.11549@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.00.1006140735040.11549@eddie.linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/14 15:38), Maciej W. Rozycki wrote:
> On Mon, 14 Jun 2010, Kenji Kaneshige wrote:
>
>> - Architectural limit of physical address in x86 32-bit mode is 40-bit
>>    (depnds on processor version).
>
>   According to documentation I happen to have handy this limit is actually
> 52 bits (and space is currently available in the data structures used for
> a possible future extension up to 63 bits).

Thank you for pointing it out. I misunderstood that.

Now I think I need to add additional check to see if specified
physical address can be handled by x86 ioremap(), instead of
changing phys_addr_valid(). The code would be

static void __iomem *__ioremap_caller(...)
{
	...
#if defined(CONFIG_X86_32) && defined(CONFIG_X86_PAE)
	if (phys_addr is higer than 36-bit)  {
		printk(KERN_INFO "ioremap can't map physical address %llx\n",
		return NULL;
	}
#endif
	...
}

Thanks,
Kenji Kaneshige

