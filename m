Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935606Ab0KQWix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:38:53 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33818 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935070Ab0KQWix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:38:53 -0500
Message-ID: <4CE4592F.6060104@oracle.com>
Date: Wed, 17 Nov 2010 14:37:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: BKL: remove extraneous #include <smp_lock.h>
References: <201011172159.oAHLx1tu001236@hera.kernel.org> <20101117140526.d532b373.randy.dunlap@oracle.com> <AANLkTimO6CN9wOQco_1bqRmwBS7KfWW1CvumKFuiOWGH@mail.gmail.com>
In-Reply-To: <AANLkTimO6CN9wOQco_1bqRmwBS7KfWW1CvumKFuiOWGH@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/10 14:23, Linus Torvalds wrote:
> On Wed, Nov 17, 2010 at 2:05 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>> smp_lock.h was removed from hardirq.h.  smp_lock.h provided the function prototype
>> for kernel_locked().  Should source files now #include <linux/smp_lock.h> ?
>> even when not being built for SMP?
> 
> Hmm. I think that part was a mistake, but I suspect the simplest fix
> for it is to simply get rid of "kernel_locked()". It has no other
> users than the hardirq.h one, so let's just move it there.
> 
> Something like the attached?
> 
> NOTE! The reason I _only_ take the CONFIG_LOCK_KERNEL version from
> smp_lock.h is because:
> 
>  - LOCK_KERNEL is defined by init/Kconfig as "(SMP || PREEMPT) && BKL"
> 
>  - inside hardirq.h we only use "kernel_locked()" inside "PREEMPT && BKL"
> 
>  - so "PREEMPT && BKL" implies "LOCK_KERNEL"
> 
>  - so the !LOCK_KERNEL kernel_locked() case is irrelevant.
> 
> unless I did a thinko somewhere.
> 
> Does this work in all configurations? TOTALLY UNTESTED! Caveat emptor.

It goes from one use of kernel_locked in *.[ch] to no uses of kernel_locked(),
so yes, it works for me.  (I did one previously-failing build with this patch,
and it built with no errors.)

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
