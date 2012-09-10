Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab2IJUcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:32:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385Ab2IJUcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:32:02 -0400
Message-ID: <504E4E34.1040603@redhat.com>
Date: Mon, 10 Sep 2012 16:31:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: habanero@linux.vnet.ibm.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, KVM <kvm@vger.kernel.org>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE handler
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>  <500D2162.8010209@redhat.com>  <1347023509.10325.53.camel@oc6622382223.ibm.com>  <504A37B0.7020605@linux.vnet.ibm.com>  <1347046931.7332.51.camel@oc2024037011.ibm.com>  <20120908084345.GU30238@linux.vnet.ibm.com>  <1347283005.10325.55.camel@oc6622382223.ibm.com>  <1347293035.2124.22.camel@twins>  <20120910165653.GA28033@linux.vnet.ibm.com>  <1347297124.2124.42.camel@twins>  <1347307972.7332.78.camel@oc2024037011.ibm.com> <1347308360.2124.59.camel@twins>
In-Reply-To: <1347308360.2124.59.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 04:19 PM, Peter Zijlstra wrote:
> On Mon, 2012-09-10 at 15:12 -0500, Andrew Theurer wrote:
>> +       /*
>> +        * if the target task is not running, then only yield if the
>> +        * current task is in guest mode
>> +        */
>> +       if (!(p_rq->curr->flags & PF_VCPU))
>> +               goto out_irq;
>
> This would make yield_to() only ever work on KVM, not that I mind this
> too much, its a horrid thing and making it less useful for (ab)use is a
> good thing, still this probably wants mention somewhere :-)

Also, it would not preempt a non-kvm task, even if we need
to do that to boost a VCPU. I think the lines above should
be dropped.

-- 
All rights reversed
