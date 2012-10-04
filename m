Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965613Ab2JDPBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 11:01:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965200Ab2JDPBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 11:01:05 -0400
Message-ID: <506DA48C.8050200@redhat.com>
Date: Thu, 04 Oct 2012 17:00:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <20120921115942.27611.67488.sendpatchset@codeblue>  <20120921120000.27611.71321.sendpatchset@codeblue>  <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com>  <50607F1F.2040704@redhat.com> <20121003122209.GA9076@linux.vnet.ibm.com>  <506C7057.6000102@redhat.com> <506D69AB.7020400@linux.vnet.ibm.com>  <506D83EE.2020303@redhat.com> <1349356038.14388.3.camel@twins>
In-Reply-To: <1349356038.14388.3.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 03:07 PM, Peter Zijlstra wrote:
> On Thu, 2012-10-04 at 14:41 +0200, Avi Kivity wrote:
>> 
>> Again the numbers are ridiculously high for arch_local_irq_restore.
>> Maybe there's a bad perf/kvm interaction when we're injecting an
>> interrupt, I can't believe we're spending 84% of the time running the
>> popf instruction. 
> 
> Smells like a software fallback that doesn't do NMI, hrtimer based
> sampling typically hits popf where we re-enable interrupts.

Good nose, that's probably it.  Raghavendra, can you ensure that the PMU
is properly exposed?  'dmesg' in the guest will tell.  If it isn't, -cpu
host will expose it (and a good idea anyway to get best performance).

-- 
error compiling committee.c: too many arguments to function
