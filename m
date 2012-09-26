Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2IZJDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:03:23 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:42451 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2IZJDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:03:22 -0400
Message-ID: <5062C4AE.6090203@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 14:32:38 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH RESEND] x86/fixup_irq: Clean the offlining CPU from the
 irq affinity mask
References: <1348681092.19514.10.camel@cliu38-desktop-build> <5062C183.20301@linux.vnet.ibm.com> <27240C0AC20F114CBF8149A2696CBE4A18A494@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A18A494@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092609-1396-0000-0000-000001EC94CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 02:26 PM, Liu, Chuansheng wrote:
>> A return value of 0 and 1 are acceptable. So this check isn't correct.
>>
>> Regards,
>> Srivatsa S. Bhat
>>
> Which case value 1 is acceptable, could you share? Thanks.

I can see the following in include/linux/irq.h:

/*
 * Return value for chip->irq_set_affinity()
 *
 * IRQ_SET_MASK_OK      - OK, core updates irq_data.affinity
 * IRQ_SET_MASK_NOCPY   - OK, chip did update irq_data.affinity
 */
enum {
        IRQ_SET_MASK_OK = 0,
        IRQ_SET_MASK_OK_NOCOPY,
};

And see some of those ->irq_set_affinity() implementations at various
places.

Regards,
Srivatsa S. Bhat

> 
>> OMG, why did you drop the other hunk which cleared the cpu *before*
>> invoking ->irq_set_affinity()? IMO, altering irq affinity involves more work
>> than just altering the mask; that's why you have that ->irq_set_affinity()
>> function. So, if you alter the mask *after* calling ->irq_set_affinity(),
>> its not right..
> Sorry the mistake, will update.
> 

