Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0KYMUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 07:20:40 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57616 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab0KYMUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 07:20:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=c8XEp9ZNkBi5A5hiIH4k89875nHeDsbWxyTSnjWfv1hPXgpAZbQuSgFojije449xFO
         Y3ftzKHv6sycxyxKZCEbcloH/me7Uov1n5UfeQmwMTKdrwobYDvkMnHorXbgi5mtMBfu
         rD6O5mh8CFEwikyuHSxQnfXZidhBrde8baHio=
MIME-Version: 1.0
In-Reply-To: <20101124083519.GF2212@linux-sh.org>
References: <4CE79C2F.5090001@gmail.com>
	<20101124080658.GC2212@linux-sh.org>
	<AANLkTikXxzcr+Ybru9vCt0+w6s-UYVNEudxvecF-0Xse@mail.gmail.com>
	<20101124083519.GF2212@linux-sh.org>
Date: Thu, 25 Nov 2010 13:20:37 +0100
Message-ID: <AANLkTimWtBkoXfr6d4ujsfeJiMEvtLV2EgMzowv4LvDv@mail.gmail.com>
Subject: Re: [PATCH 08/16 v4] pramfs: headers
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/24 Paul Mundt <lethal@linux-sh.org>:
> On Wed, Nov 24, 2010 at 09:23:02AM +0100, Marco Stornelli wrote:
>> 2010/11/24 Paul Mundt <lethal@linux-sh.org>:
>> >
>> >> +#ifdef CONFIG_PRAMFS_WRITE_PROTECT
>> >> +static inline void pram_memunlock_range(void *p, unsigned long len)
>> >> +{
>> >> +#ifndef CONFIG_X86
>> >> + ? ? local_irq_disable();
>> >> +#endif
>> >> + ? ? preempt_disable();
>> >> + ? ? pram_writeable(p, len, 1);
>> >> +}
>> >> +
>> > This needs some explaining, or killing. While the latter is preferable,
>> > we can also work with the former.
>> >
>>
>> Maybe I didn't understand, you mean preemt_disable() without disabling
>> the interrupt?
>
> I mean what exactly is this supposed to be doing? It looks pretty
> questionable for SMP for starters, it doesn't explain why x86 is special,
> etc. It looks like you wanted a spinlock with IRQs disabled but probably
> opted not to use it because you were throwing this around interfaces that
> could sleep, which looks like a really scary thing for latency. It's also
> making architecture assumptions without any explanation of why. This
> needs to be explained, and in some amount of detail, as it's not entirely
> obvious.
>

Ok, it's not clear, I'll try to explain. My idea here is avoid "open
windows" with the memory not locked (lock here means not protected).
The problem here is that if you call set_memory_rw/set_memory_ro with
interrupt disabled (for x86) you'll fall in a bug_on() condition. I
can add that the use of these functions has been discussed in the v1
patch series with Andi Kleen.

Marco
