Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1JTPU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:20:58 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:55663 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab1JTPU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:20:57 -0400
Message-ID: <4EA03C4F.1040500@linux.vnet.ibm.com>
Date: Thu, 20 Oct 2011 20:50:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CPU hotplug, x86 microcode: Revalidate microcode before
 microcode update
References: <4E9F05F9.7080901@linux.vnet.ibm.com> <20111020123126.GC12080@aftab>
In-Reply-To: <20111020123126.GC12080@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11102015-2674-0000-0000-000000EB2C2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2011 06:01 PM, Borislav Petkov wrote:
> Hi Srivatsa,
> 
> On Wed, Oct 19, 2011 at 01:16:41PM -0400, Srivatsa S. Bhat wrote:
>> However, since I am not aware of what hpa's new ucode loading solution
>> is, nor how it will handle this case, I thought of posting this patch
>> (now tested and fine-tuned),
> 
> Hehe, please don't tell me you tested it by really hotswapping an x86
> CPU :-).
> 

Of course not :-) I just saw to it that the kernel boots fine, and my usual
test case (suspend/resume with other things) works well (as expected...)

>> so that it can be applied in case this
>> patch is deemed to be necessary/desirable to avoid breaking hot-swap cases.
>>
>> Thanks,
>> Srivatsa S. Bhat
>>
>> ---
>>
>> This patch is intended to go with the patch posted at
>> http://thread.gmane.org/gmane.linux.kernel/1200882/focus=1200991
>>
>> Since that patch optimizes microcode update by keeping the microcode image
>> in kernel memory and not freeing it up even when the CPU goes offline, it
>> means we would be applying the same microcode image when the CPU comes back
>> online.
>>
>> However, if physically hotplugging of CPUs is supported, then we could
>> physically hot-unplug CPUs and then hot-plug new (and possibly a different
>> type of) CPUs. In such a case, it would be wrong to blindly apply the same
>> old microcode (that the kernel maintained for the old CPU) to this new CPU.
>>
>> Hence, this patch adds a validation to check whether the microcode revision
>> we have in kernel memory and the revision that needs to be applied to the
>> CPU that was just brought online, are the same or not. If they happen to be
>> different, then it invalidates and frees the kernel's copy of the microcode,
>> triggering a fresh request to userspace to get the appropriate microcode
>> image for this CPU.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> Ok, seriously, I think your patch looks very good and it should be doing
> what it's supposed to and the commit message is very good in explaining
> what happens, but, unless there's a real problem it fixes, it is not
> needed.
> 
> I know, I know, what about the hotswapping case, you'd say. Well,
> this is not real, I'd guess hotswapping on x86 is still no more than
> scribbles on some whiteboard (unless I'm proven wrong, of course) so
> fixing hypothetical cases is not something we should do - the kernel
> bloat level is not very low as it is right now and there are _much_ more
> _real_ issues which could make much better use of your expertise and
> patches.
> 
> :-)
> 

Thank you very much for appreciating my patch :-) I feel honoured!

By the way, I am perfectly fine with not getting this patch into the kernel.
My only intention in posting this patch was that, in case this becomes
necessary for some reason, it will be handy to push into the kernel (since
I had already written the patch by the time you indicated this won't really
be necessary).

And moreover, even I am not much aware of where hotswapping stands on x86,
so I thought I'd let experts like you decide whether this patch is
needed or not.

> So, this should probably be x86 maintainers' call, but I, for one, don't
> think this patch is necessary, IMHO.
> 

Sure, thanks for your invaluable feedback!

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab

