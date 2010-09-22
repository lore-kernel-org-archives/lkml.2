Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab0IVQdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:33:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:1085 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab0IVQdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:33:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,408,1280732400"; 
   d="scan'208";a="660004241"
Message-ID: <4C9A2FB3.105@linux.intel.com>
Date: Wed, 22 Sep 2010 09:32:51 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jean Pihet <jean.pihet@newoldbits.com>
CC: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>	<201009171736.14170.trenn@suse.de>	<20100917162412.GB3341@elte.hu>	<201009180026.59482.trenn@suse.de>	<AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>	<4C9A21AD.1000800@linux.intel.com> <AANLkTim6B+Je=LykgJb9=0vK5Br1rkft619BRJkBcHdP@mail.gmail.com>
In-Reply-To: <AANLkTim6B+Je=LykgJb9=0vK5Br1rkft619BRJkBcHdP@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 9/22/2010 8:36 AM, Jean Pihet wrote:
> On Wed, Sep 22, 2010 at 5:33 PM, Arjan van de Ven<arjan@linux.intel.com>  wrote:
>>   On 9/22/2010 8:31 AM, Jean Pihet wrote:
>>> Hi,
>>>
>>> Here is a patch that redefines the power events API. The advantages
>>> are: easier maintainance of the kernel and the
>>> user space tools, a cleaner and more generic interface, more
>>> parameters for fine tracing and even documentation!
>>>
>>> Thomas, this patch has your patch above merged in ('power-trace: Use
>>> power_switch_state instead of power_start and power_end'). The revised
>>> ACPI patch is coming asap.
>>>
>>> The trace points for x86 and OMAP are also udated accordingly.
>>>
>>> The pytimechart tool needs an update for the new API. This can be done
>>> as soon as the kernel code gets merged in.
>> unfortunately this code is changing a userspace ABI... we really shouldn't
>> do that if we can avoid it,
>> and here we can avoid it.
>>
>> applications ARE using this stuff!
> What are the apps that are using it? I know about builtin-timechart,
> pytimechart. Is powertop using this as well?

powertop 2.x codebase is as well.

and a bunch of tools we have internal here at Intel.

the thing with ABIs is that you don't know how many users you have.. at 
least here you know the lower bound is 3 different tools that are open 
source.
.... and likely many local tools that aren't.

