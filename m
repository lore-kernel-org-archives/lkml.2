Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1CYOjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:39:14 -0400
Received: from claw.goop.org ([74.207.240.146]:52436 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609Ab1CYOjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:39:13 -0400
Message-ID: <4D8CA902.7090907@goop.org>
Date: Fri, 25 Mar 2011 14:38:58 +0000
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Len Brown <lenb@kernel.org>, venki@google.com, ak@linux.intel.com,
        suresh.b.siddha@intel.com, sfr@canb.auug.org.au, peterz@infradead.org,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, arjan@linux.intel.com,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: [RFC PATCH V4 4/5] cpuidle: driver for xen
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>	<20110322123324.28725.3131.stgit@tringupt.in.ibm.com>	<20110322145054.GB26952@dumpdata.com>	<4D89C40B.4020809@linux.vnet.ibm.com>	<alpine.LFD.2.02.1103231659210.12911@x980> <20110324120522.GB29294@dumpdata.com>
In-Reply-To: <20110324120522.GB29294@dumpdata.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 12:05 PM, Konrad Rzeszutek Wilk wrote:
> On Thu, Mar 24, 2011 at 03:18:14AM -0400, Len Brown wrote:
>> Is a CONFIG_XEN kernel supposed to use just HLT in idle?
> For right now..

For always, I should think.

>> xen_arch_setup() does this:
>>
>>         pm_idle = default_idle;
>>         boot_option_idle_override = IDLE_HALT;
>>
>> which has that effect.  I guess this makes sense b/c the
>> CONFIG_XEN kernel is Dom0 and the real C-sates are done
>> by the hypervisor?
> Correct. There are some patches that make the C-states 
> be visible in the Linux kernel, but that hasn't been ported
> over yet.

All we need is for the idle CPU to block in the hypervisor; a plain
"hlt" is always going to be sufficient (which is overridden as a pvop
into a sched_idle hypercall).

Xen will choose an appropriate power state for the physical cpus
depending on the overall busyness of the system (which any individual
virtual machine can't determine).

    J
