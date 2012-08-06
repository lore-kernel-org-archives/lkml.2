Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab2HFSWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:22:33 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56231 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab2HFSWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:22:32 -0400
Message-ID: <50200AEF.5080904@us.ibm.com>
Date: Mon, 06 Aug 2012 11:20:31 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Avi Kivity <avi@redhat.com>, paulmck@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mingo@kernel.org, a.p.zijlstra@chello.nl, prarit@redhat.com,
        tglx@linutronix.de
Subject: Re: rcu: INFO: rcu_preempt detected stalls on CPUs/tasks on v3.6
References: <500ED719.2010002@gmail.com> <50112D3B.4020201@redhat.com> <50127B16.5040401@gmail.com> <50153138.4020304@redhat.com> <5015A5A8.7030601@gmail.com> <50161D5E.4030009@redhat.com> <50165046.9020705@gmail.com> <501654D3.7020504@redhat.com> <50168162.4010508@gmail.com> <50168981.3000001@redhat.com> <501EA58D.4090606@gmail.com> <501FFD2A.4010905@us.ibm.com>
In-Reply-To: <501FFD2A.4010905@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080618-5518-0000-0000-000006A040C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 10:21 AM, John Stultz wrote:
> On 08/05/2012 09:55 AM, Sasha Levin wrote:
>> On 07/30/2012 03:17 PM, Avi Kivity wrote:
>>> Possible causes:
>>>   - the APIC calibration in the guest failed, so it is programming too
>>> low values into the timer
>>>   - it actually needs 1 us wakeups and then can't keep up (esp. as kvm
>>> interrupt injection is slowing it down)
>>>
>>> You can try to find out by changing
>>> arch/x86/kvm/lapic.c:start_lapic_timer() to impose a minimum wakeup of
>>> (say) 20 microseconds which will let the guest live long enough for you
>>> to ftrace it and see what kind of timers it is programming.
>> I've kept trying to narrow it down, and found out It's triggerable 
>> using adjtimex().
Sorry, one more question: Could you provide details on how is it 
trigger-able using adjtimex?

thanks
-john

