Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2BVKs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:48:56 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:43142 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab2BVKsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:48:55 -0500
Message-ID: <4F44C7E9.6000303@linux.vnet.ibm.com>
Date: Wed, 22 Feb 2012 16:18:09 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/1] linux headers: header file(s) changes to enable spinlock
 use jumplabel
References: <20120217082527.15283.72980.sendpatchset@oc5400248562.ibm.com> <4F403268.7040804@goop.org> <20120219092456.GB10038@redhat.com> <4F41D72E.7000605@goop.org> <4F41E4C1.9010901@linux.vnet.ibm.com> <20120220093350.GF10038@redhat.com>
In-Reply-To: <20120220093350.GF10038@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12022210-5816-0000-0000-000001666E97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 03:03 PM, Gleb Natapov wrote:
> On Mon, Feb 20, 2012 at 11:44:25AM +0530, Raghavendra K T wrote:
>> On 02/20/2012 10:46 AM, Jeremy Fitzhardinge wrote:
[...]
>> But does pvlock have to use jump
>>>> label? I looked at the code and it is used like paravirt patching. Meaning
>>>> it is patched only once on a boot up when XEN is detected. May be use
>>>> paravirt patching instead of jump label? What if jump label will want
>>>> to use spinlock for some reason in the future (it uses mutex currently)?
>>>
>>> The point of the pv ticketlocks is to avoid any pvop calls on the
>>> lock/unlock fastpath, relegating them to only the slow path.
>>> Unfortunately, the pv unlock case can't be identical with the non-pv
>>> unlock, and jump_labels are lighter weight and more efficient than pvops.
>>>
>>> It doesn't matter if jump_labels start using spinlocks; all we need the
>>> jump_label machinery to do is patch the jump sites in the code so that
>>> one of two execution paths can be selected.  Since all the ticketlock
>>> jump_label patching happens before SMP is enabled, there's no problem
>>> with changing a lock while a cpu is executing the code.
>>>
>>
>> I also felt agreeing with Jeremy. seemed to me that latter is more
>> performance friendly. no?.
>>
>
> I thought not about pvop, but about alternative().  jump_labels is used
> by spinlock to patch out jump into nops It can be done via alternative()
> too I think.

I had remembered that this discussion already happened with Jeremy's V5
of ticketlock patches. pulling out link :

https://lkml.org/lkml/2011/10/13/384

