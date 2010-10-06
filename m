Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0JFN3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:29:54 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40561 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab0JFN3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:29:53 -0400
Message-ID: <4CAC79CE.4020800@canonical.com>
Date: Wed, 06 Oct 2010 14:29:50 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: Zdenek Kabelac <zkabelac@redhat.com>
CC: chich21@mail.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux kernel 2.6.34.7 lvm error
References: <8CD30F86F2A0A2B-BE8-179A8@web-mmc-m02.sysops.aol.com> <4CA99462.5050707@redhat.com> <4CA9D18F.7070003@redhat.com>
In-Reply-To: <4CA9D18F.7070003@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 02:07 PM, Zdenek Kabelac wrote:
> Dne 4.10.2010 10:46, Zdenek Kabelac napsal(a):
>> Dne 3.10.2010 11:56, chich21@mail.com napsal(a):
>>> With Linux kernel 2.6.34.7 from www.kernel.org the following error occurs.
>>>
>>> Issuing this command produces error.
>>>
>>> vgchange -ay
>>>
>>> outputs:
>>> Internal error: Maps lock 14317216 < unlock 14321312
>>>
>>> vgchange is part of lvm-tools.
>>>
>>> This doesn't happen with kernel 2.6.34 or 2.6.34.1 from www.kernel.org.
>>>
>>> Is there a patch for 2.6.34.x series coming for this error. As there is one
>>> for 2.6.35.x series.
>>>
>>> Please CC email me related posts.
>>
>>
>> Bug is related to stack guard fix - kernel 2.6.36-rc4 has this problem fixed.
>> Bug is present in 2.6.36-rc3 - so something between them fixes the problem.
>>
>> It looks like the [stack] mapping loses 1 page after each mlock/munlock cycle.
>> I'm probably going to play bisect game to find out missing fix.
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=638525
>>
> 
> So - after bisecting - it seems that commit:
> 
> 39aa3cb3e8250db9188a6f1e3fb62ffa1a717678
> "mm: Move vma_stack_continue into mm.h"  by Stefan
> 
> had a nice 'bug-fixing' side effect which have not been mentioned in its
> description - it fixes misbehaving of mlock/munlock [stack] mapping size.
>

I have been asking for that to get picked up for stable (though no response,
yet). Unfortunately the better description (and the cc stable) got lost when
Linus merged two patches together).

The problem also might be related to the LVM version used (I could not see the
message with LVM2.02.54 with a kernel that still shows the gaps on the split
stack vma). But it definitely confuses anything that verifies the output of
/proc/<pid>/maps.

-Stefan

> So I assume this commit should be backported to stable kernels as well when
> there is stack-guard patch already added.
> 
> Cc: stable@
> 
> Zdenek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


