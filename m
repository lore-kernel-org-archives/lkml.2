Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198Ab1BLQKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 11:10:32 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:49219 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab1BLQKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 11:10:25 -0500
Message-ID: <4D56B0E6.5040600@free.fr>
Date: Sat, 12 Feb 2011 17:10:14 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
References: <4D473FD5.1090903@free.fr> <20110201080223.GB20372@elte.hu> <1296566732.4d4809cc1f963@imp.free.fr> <20110202062632.GA12256@elte.hu> <4D4CA3FD.6000901@zytor.com> <1296924395.4d4d7eeb6f1fe@imp.free.fr> <4D4F31BC.3000709@zytor.com> <1297108754.4d504f1281802@imp.free.fr> <4D50505D.2070402@zytor.com>
In-Reply-To: <4D50505D.2070402@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin a écrit :
> On 02/07/2011 11:59 AM, castet.matthieu@free.fr wrote:
>> For .39 I hope we could remove most of the RWX rights after init (This means
>> make low memory trampoline NX or !RW).
>> This should be possible on :
>> - 32 bit if wakeup use trampoline_32 [1] that doesn't enable paging in low
>> memory (can be NX)
>> - trampoline_64 need fix to support NX on data section. It tries to read data
>> section before enabling NX. A possible fix is to use its own page table [2]. And
>> the kernel one can be NX.
> 
> No, you're really barking down the wrong path on this.  The trampoline
> code is tiny; I don't think it is really worth trying to NX-ify it.  The
Even if the trampoline is tiny, a hole is a hole.

The trampoline code job is to jump from low memory (realmode) to somewhere in kernel text.
Why should we enable paging or use kernel page table for doing that ?

> additional complexity caused by not being able to execute in this space
> will really damage some other incoming code, so it isn't an option as
> far as I'm concerned.
> 
What do you plan to add that won't be compatible with that ?


Matthieu

