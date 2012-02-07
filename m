Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2BGM2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 07:28:33 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44811 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab2BGM2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 07:28:31 -0500
Message-ID: <4F3118EA.7040302@codemonkey.ws>
Date: Tue, 07 Feb 2012 06:28:26 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: qemu-devel <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Northup <digitaleric@google.com>, KVM list <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com>	<CAG7+5M0s_F93G3dPrRQaFMVv_hPzpd-wYEPApJUDGhh3vJuy-A@mail.gmail.com>	<4F2C6517.3040203@codemonkey.ws> <4F302E0D.20302@freescale.com>
In-Reply-To: <4F302E0D.20302@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 01:46 PM, Scott Wood wrote:
> On 02/03/2012 04:52 PM, Anthony Liguori wrote:
>> On 02/03/2012 12:07 PM, Eric Northup wrote:
>>> On Thu, Feb 2, 2012 at 8:09 AM, Avi Kivity<avi@redhat.com>   wrote:
>>> [...]
>>>>
>>>> Moving to syscalls avoids these problems, but introduces new ones:
>>>>
>>>> - adding new syscalls is generally frowned upon, and kvm will need
>>>> several
>>>> - syscalls into modules are harder and rarer than into core kernel code
>>>> - will need to add a vcpu pointer to task_struct, and a kvm pointer to
>>>> mm_struct
>>> - Lost a good place to put access control (permissions on /dev/kvm)
>>> for which user-mode processes can use KVM.
>>>
>>> How would the ability to use sys_kvm_* be regulated?
>>
>> Why should it be regulated?
>>
>> It's not a finite or privileged resource.
>
> You're exposing a large, complex kernel subsystem that does very
> low-level things with the hardware.

As does the rest of the kernel.

>  It's a potential source of exploits
> (from bugs in KVM or in hardware).  I can see people wanting to be
> selective with access because of that.

As is true of the rest of the kernel.

If you want finer grain access control, that's exactly why we have things like 
LSM and SELinux.  You can add the appropriate LSM hooks into the KVM 
infrastructure and setup default SELinux policies appropriately.

> And sometimes it is a finite resource.  I don't know how x86 does it,
> but on at least some powerpc hardware we have a finite, relatively small
> number of hardware partition IDs.

But presumably this is per-core, right?  And they're recycled, right?  IOW, 
there isn't a limit of number of guests <= number of hardware partitions IDs. 
It just impacts performance.

Regards,

Anthony Liguori

>
> -Scott
>
>

