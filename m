Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab2DFKKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 06:10:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38976 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778Ab2DFKKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 06:10:34 -0400
X-Sasl-enc: /qn3ZDXiMaDAZfxwuYEA1CrS9/9nAtl+x/cJPrtsWUWW 1333707033
Message-ID: <4F7EC111.4010608@ladisch.de>
Date: Fri, 06 Apr 2012 12:10:25 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
CC: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: semaphore and mutex in current Linux kernel (3.2.2)
References: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com> <20120401121943.GA11893@gmail.com> <491D6B4EAD0A714894D8AD22F4BDE0439F9560@SCYBEXDAG02.amd.com> <20120403075245.GD26826@gmail.com> <491D6B4EAD0A714894D8AD22F4BDE0439F98F4@SCYBEXDAG02 <4F7DA8FD.1020909@ladisch.de> <491D6B4EAD0A714894D8AD22F4BDE0439F9E45@SCYBEXDAG02.amd.com>
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE0439F9E45@SCYBEXDAG02.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen, Dennis (SRDC SW) wrote:
> On Thu, Apr 5, 2012 at 10:15 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
>> It would not make sense to spin too long, especially if some other
>> process wants to run on the same CPU.
>>
>>> int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
>>> {
>>>       ...
>>>       while (owner_running(lock, owner)) {
>>>               if (need_resched())
>>>                       break;
>>>
>>>               arch_mutex_cpu_relax();
>>>       }
>>>       ...
>>> }
>>>
>>> D+ means the App in CPU1 is sleeping in a UNINTERRUPTIBLE state. This is very interesting,
>>> How does this happen?
>>
>> Your experiment shows that there must be some condition that makes the
>> code break out of the spin loop ...
>
> I guess this is related with RCU component, but I don't found the right place where the code
> Located yet.

"On the internet, nobody can hear you being subtle."

If some other process wants to run on the same CPU, needs_resched() is set.
(This might happen to make the cursor blink, for keyboard input, or when
somebody starts a rogue process like ps.)


Regards,
Clemens
