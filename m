Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab0LAF0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 00:26:42 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39857 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab0LAF0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 00:26:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4CF5DC81.1080600@jp.fujitsu.com>
Date: Wed, 01 Dec 2010 14:26:25 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, Yong Zhang <yong.zhang0@gmail.com>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: fix incorrect proc spurious output
References: <4CF4B778.90604@jp.fujitsu.com> <AANLkTinSYu9JhqY8NAH+sNAKuO9cUZwJTxK46_8nx3Qh@mail.gmail.com> <20101130100742.GA4856@core2.telecom.by>
In-Reply-To: <20101130100742.GA4856@core2.telecom.by>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for reviewing, Yong, Alexey.
I'll resend the patch with cc:ing stable.

Regards,
Kenji Kaneshige


(2010/11/30 19:07), Alexey Dobriyan wrote:
> On Tue, Nov 30, 2010 at 05:08:13PM +0800, Yong Zhang wrote:
>> 2010/11/30 Kenji Kaneshige<kaneshige.kenji@jp.fujitsu.com>:
>>> Fix the problem that all the /proc/irq/XX/spurious files shows the IRQ
>>> 0 information.
>>>
>>> Current irq_spurious_proc_open() passes on NULL as the 3rd argument,
>>> which is used as an IRQ number in irq_spurious_proc_show(), to the
>>> single_open(). Because of this, all the /proc/irq/XX/spurious file
>>> shows IRQ 0 information regardless of the IRQ number.
>>>
>>> To fix the problem, irq_spurious_proc_open() must pass on the
>>> appropreate data (IRQ number) to single_open().
>>>
>>> Signed-off-by: Kenji Kaneshige<kaneshige.kenji@jp.fujitsu.com>
>>
>> Looks good.
>>
>> Reviewed-by: Yong Zhang<yong.zhang0@gmail.com>
>>
>> BTW, it's introduced by a1afb6371bb5341057056194d1168753f6d77242
>> So should we Cc'ing stable?
> 
> Definitely.
> 
>>>   static int irq_spurious_proc_open(struct inode *inode, struct file *file)
>>>   {
>>> -       return single_open(file, irq_spurious_proc_show, NULL);
>>> +       return single_open(file, irq_spurious_proc_show, PDE(inode)->data);
>>>   }
> 
> 


