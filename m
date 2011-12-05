Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab1LER0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:26:06 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54882 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab1LER0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:26:01 -0500
Message-ID: <4EDCFE9F.9050605@linux.vnet.ibm.com>
Date: Mon, 05 Dec 2011 22:55:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, ebiederm@xmission.com,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] PM / Sleep: Make [un]lock_system_sleep() generic
References: <20111204200208.25620.515.stgit@srivatsabhat.in.ibm.com> <20111205171443.GB627@google.com>
In-Reply-To: <20111205171443.GB627@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120507-7014-0000-0000-000000366C5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 10:44 PM, Tejun Heo wrote:

> Hello,
> 
> On Mon, Dec 05, 2011 at 01:32:38AM +0530, Srivatsa S. Bhat wrote:
>> +static inline void lock_system_sleep(void)
>> +{
>> +	/* simplified freezer_do_not_count() */
>> +	current->flags |= PF_FREEZER_SKIP;
>> +	mutex_lock(&pm_mutex);
>> +}
>> +
>> +static inline void unlock_system_sleep(void)
>> +{
>> +	mutex_unlock(&pm_mutex);
>> +	/* simplified freezer_count() */
>> +	current->flags &= ~PF_FREEZER_SKIP;
>> +}
> 
> BTW, don't we want try_to_freeze() there?  What's the reason for not
> using freezer_count()?
> 


I wanted these APIs to be generic, not restricted to work only for userspace
processes. Both freezer_do_not_count() and freezer_count() are effective only
when current->mm is non-NULL (ie., only for userspace ones).
I think I have documented this in the patch which added these things to the
2 APIs. See commit 6a76b7a in linux-pm/linux-next.

As for try_to_freeze(), we can surely add that. I think I missed it while
open-coding the relevant part of freezer_count(). I'll send it as a separate
patch. Thank you very much.

Regards,
Srivatsa S. Bhat

