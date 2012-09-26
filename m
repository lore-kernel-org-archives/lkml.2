Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab2IZIwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:52:17 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:47198 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab2IZIwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:52:15 -0400
Message-ID: <5062C215.8030602@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 14:21:33 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86/fixup_irq: Clean the offlining CPU from the irq affinity
 mask
References: <1348669924.19514.6.camel@cliu38-desktop-build> <5062A442.2030207@linux.vnet.ibm.com> <27240C0AC20F114CBF8149A2696CBE4A189F97@SHSMSX101.ccr.corp.intel.com> <5062B602.6000502@linux.vnet.ibm.com> <27240C0AC20F114CBF8149A2696CBE4A18A27F@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A18A27F@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092608-5490-0000-0000-000002325168
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 01:40 PM, Liu, Chuansheng wrote:
>> Btw, on a slightly different note, I'm also rather surprised that the above
>> code doesn't care about the return value of chip->irq_set_affinity() ..
>> Shouldn't we warn if that fails?
> 
> It seems another case when irq_set_affinity is NULL whenever affinity is changed or not before that,
> For this case, I suppose the chip is not supporting set_affinity, then the chip should set all
> related irqs into just CPU0, otherwise, it will bring some trouble, do you agree?
> 

Hmm.. no, I wouldn't jump to do that. Moreover, note that there are patches in -tip to
enable CPU 0 hotplug. So doing the above might not be terribly helpful going forward.

> I guess this case should be covered outside fixup_irqs() code.
> 
 
Regards,
Srivatsa S. Bhat

