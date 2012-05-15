Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966157Ab2EOSYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:24:23 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42876 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964946Ab2EOSYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:24:20 -0400
Message-ID: <4FB29F2A.2000607@linux.vnet.ibm.com>
Date: Tue, 15 May 2012 23:53:38 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bojan Smojver <bojan@rexursive.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>, bp@alien8.de
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org> <1337039996.1628.9.camel@shrek.rexursive.com> <4FB269BF.3090801@linux.vnet.ibm.com> <201205151942.36335.rjw@sisk.pl>
In-Reply-To: <201205151942.36335.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051518-5564-0000-0000-000002BBB723
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 11:12 PM, Rafael J. Wysocki wrote:

> On Tuesday, May 15, 2012, Srivatsa S. Bhat wrote:
>> On 05/15/2012 05:29 AM, Bojan Smojver wrote:
>>
>>> On Mon, 2012-05-14 at 21:47 +1000, Bojan Smojver wrote:
>>>> No. That hangs my box.
>>>>
>>>> This triggers a bug in workqueues code (essentially the same as the
>>>> previous patch, except for sys_sync() not being done):
>>>
>>> Alan/Srivatsa,
>>>
>>> Coming back to the explanation of how this whole thing works, it would
>>> seem that at the point of image writing all devices are fully functional
>>> (not just some, as I mistakenly believed). However, the processes are
>>> supposed to be already frozen, right? Calling suspend_prepare(), which
>>> will essentially try to freeze the processes and kernel threads, seems
>>> like the wrong thing to do.
>>>
>>> Did you guys mean that we should be calling
>>> pm_notifier_call_chain(PM_SUSPEND_PREPARE) only here?
>>>
>>
>>
>> Exactly! And also arrange for the corresponding PM_POST_SUSPEND notification
>> to happen at the end of suspend-to-ram stage...
> 
> Actually, no.  The notifiers are supposed to be called when user space is
> available, otherwise some things will break badly (firmware loading for
> one example IIRC).
> 


Oh, you are right. The notifiers are called before freezing userspace.
Sorry, I had overlooked that.
 
Regards,
Srivatsa S. Bhat

