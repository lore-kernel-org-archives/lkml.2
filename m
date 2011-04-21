Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab1DUEnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 00:43:10 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38038 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1DUEnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 00:43:08 -0400
Message-ID: <4DAFB5D3.1030804@linux.vnet.ibm.com>
Date: Thu, 21 Apr 2011 10:12:59 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Kevin Hilman <khilman@ti.com>
CC: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [linux-pm] [RFC PATCH V3 1/4] cpuidle: Move dev->last_residency
 update to driver	enter routine; remove dev->last_state
References: <20110420065445.332.13688.stgit@tringupt.in.ibm.com> <20110420065523.332.58678.stgit@tringupt.in.ibm.com> <87pqog6dfw.fsf@ti.com>
In-Reply-To: <87pqog6dfw.fsf@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/20/2011 10:57 PM, Kevin Hilman wrote:
> Trinabh Gupta<trinabh@linux.vnet.ibm.com>  writes:
>
>> Cpuidle subsystem only suggests the state to enter and does not
>> guarantee if the suggested state is entered. The actual entered state
>> may be different because of software or hardware demotion. Software
>> demotion is done by the back-end cpuidle driver and can be accounted
>> correctly. Current cpuidle code uses last_state field to capture the
>> actual state entered and based on that updates the statistics for the
>> state entered.
>>
>> Ideally the driver enter routine should update the counters,
>> and it should return the state actually entered rather than the time
>> spent there.
>
> OK, the return type was changed to return the state index instead of the
> time, but since the governors are still relying on dev->last_residency,
> drivers are required to update it.
>
> Because of that, why not keep the update of the  time/usage counters
> in common code rather than duplicating it (9 times in this patch) into
> all the drivers?

Hi Kevin,

Thanks for your review. Yes, we can do like this and it would prevent
duplication of code. I just wanted to make cpuidle handle only selection
and entering of state, and leave everything else to the driver which
knows best about these things.

But both are functionally same and definitely statistics update inside
cpuidle_idle_call() prevents duplication of code.

Thanks,
-Trinabh
