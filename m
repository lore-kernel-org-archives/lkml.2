Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab1JDNTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 09:19:47 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54898 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab1JDNTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 09:19:46 -0400
Message-ID: <4E8B07EA.4020307@linux.vnet.ibm.com>
Date: Tue, 04 Oct 2011 18:49:38 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, len.brown@intel.com,
        mingo@elte.hu, akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@lists.linux-foundation.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CPU hotplug, freezer: Fix bugs in CPU hotplug call path
References: <4E88BF33.10407@linux.vnet.ibm.com> <1317636215.12973.16.camel@twins>
In-Reply-To: <1317636215.12973.16.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 03:33 PM, Peter Zijlstra wrote:
> On Mon, 2011-10-03 at 01:14 +0530, Srivatsa S. Bhat wrote:
>> +static atomic_t tasks_frozen = ATOMIC_INIT(0);
>> +
>> +void set_tasks_frozen_flag(void)
>> +{
>> +       atomic_set(&tasks_frozen, 1);
>> +}
>> +
>> +void clear_tasks_frozen_flag(void)
>> +{
>> +       atomic_set(&tasks_frozen, 0);
>> +}
>> +
>> +int tasks_are_frozen(void)
>> +{
>> +       int ret;
>> +       ret = atomic_read(&tasks_frozen);
>> +       return ret;
>> +} 
> 
> What's the point of using atomic_t here? Neither set nor read are
> actually atomic ops.
> 

Hi Peter,
Thank you for the review. I'll send version 2 of the patch with
the changes incorporated.

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
