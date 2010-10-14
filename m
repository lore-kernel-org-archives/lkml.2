Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0JNB0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 21:26:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38790 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074Ab0JNB0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 21:26:50 -0400
X-User-Agent: K-9 Mail for Android
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com> <4CB64D8F.9080800@zytor.com> <alpine.DEB.2.00.1010131739010.27124@chino.kir.corp.google.com> <4CB65262.3070507@zytor.com> <alpine.DEB.2.00.1010131744540.27124@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1010131744540.27124@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 13 Oct 2010 18:21:48 -0700
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <cbd8b37e-a1a3-4275-8acb-a76476211366@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And the value of those additional options is what?  I'd consider adding this to the sewer pit called CONFIG_EMBEDDED (with a BUG_ON, not a warning... sheesh) but only if there is any demonstrable value other than a trivial amount of code (kilobytes?) in exchange for a bunch of crap #ifdef.

"David Rientjes" <rientjes@google.com> wrote:

>On Wed, 13 Oct 2010, H. Peter Anvin wrote:
>
>> > You can already set the lowmem_reserve_ratio via 
>> > /proc/sys/vm/lowmem_reserve_ratio.
>> 
>> And why is it then so hard to put in a single line in /etc/sysctl.conf
>> for you?
>> 
>
>Because disabling CONFIG_ZONE_DMA allows for additional extensions: 
>disabling CONFIG_GENERIC_ISA_DMA and CONFIG_ISA_DMA_API.  We've also run 
>for a couple years without those.
>
>> > We've run without ZONE_DMA for a couple years because we don't have such 
>> > hardware limitations and would appreciate the ability to disable it with a 
>> > config option rather than hacking the kernel to get it to compile.  I'm 
>> > sure Casey would as well as you can see in the thread "A question about 
>> > ZONE_DMA".
>> > 
>> > I don't see the harm in being able to conveniently disable the zone if you 
>> > know what you're doing.
>> 
>> There are going to be a lot of very strange bug reports as a result.
>> 
>
>We have config options all over the kernel that change the behavior of 
>syscalls without worrying about bug reports popping up from users who 
>knowingly have disabled the option, I don't see this as being any 
>different.  If you're concerned about, we could add a
>
>#ifndef CONFIG_ZONE_DMA
>	WARN_ON_ONCE(gfp_mask & __GFP_DMA);
>#endif
>
>in the page allocator.

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
