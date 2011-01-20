Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab1ATNZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 08:25:03 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61073 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab1ATNY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 08:24:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p7vvfueR6vc4mwWN6lc1tYAqNJ3Mv2Z2cMl6p7EdjYB1VMG2jqHgt1u7Z2qZHGHCii
         5qirne2VPrGt1FeEAFA9UTMO/zTxIC8SItaSLm1710ZVXihMbAJth8MZYMCSJhdA7hoO
         CJWKBNkCB+JX6hVYfm27nR7VXD2irF4EyThZE=
MIME-Version: 1.0
In-Reply-To: <20110120130625.GA14436@elte.hu>
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
	<20110119135546.bb7e8f62.akpm@linux-foundation.org>
	<1295484358.15213.25.camel@yhuang-dev>
	<20110119165247.cca2f434.akpm@linux-foundation.org>
	<1295520247.28776.152.camel@laptop>
	<AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com>
	<1295522876.28776.158.camel@laptop>
	<AANLkTin3_NuGG_E0Juy7=1Q7PcMJ6id1ZU-Gngfp_=dg@mail.gmail.com>
	<20110120121455.GA7680@elte.hu>
	<AANLkTikv3h_QoHs4uj6CNJdC7tb_-e0osKa47KWEJvFV@mail.gmail.com>
	<20110120130625.GA14436@elte.hu>
Date: Thu, 20 Jan 2011 21:24:58 +0800
Message-ID: <AANLkTimWTXL57f6wP868jKFkaoAwyegg_WkbuQEYEpm4@mail.gmail.com>
Subject: Re: [PATCH -v10 0/4] Lock-less list
From: huang ying <huang.ying.caritas@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 9:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * huang ying <huang.ying.caritas@gmail.com> wrote:
>
>> On Thu, Jan 20, 2011 at 8:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * huang ying <huang.ying.caritas@gmail.com> wrote:
>> >
>> >> > But will all that stuff be accepted? Please stop sending infrastructure bits and
>> >> > focus on your larger RAS picture, once you have consensus on that from all
>> >> > parties involved, then, and only then, does it make sense to submit everything,
>> >> > including infrastructure.
>> >>
>> >> I am not sending hardware error reporting infrastructure.  As far as I know, Linus
>> >> and Andrew suggest to use printk for hardware error reporting.  And now, I just
>> >> try to write APEI driver and reporting hardware error with printk.  Is it
>> >> acceptable?  Do you have some other idea about hardware error reporting?
>> >
>> > Erm, how could you possible have missed the perf based RAS daemon work of Boris,
>> > which we've pointed out about half a dozen times already?
>>
>> Even if there is some other hardware error reporting infrastructure
>> such as perf based, I think we still need printk too. After all, as
>> Linus pointed out, printk is the most popular error reporting
>> mechanism so far. Do you think so?
>
> Of course, that's why the upstream EDAC code uses printk too. In fact it does all
> sorts of in-kernel decoding to make the printk output more useful - the /dev/mcelog
> method of pushing all decoding to user-space is fundamentally flawed.
>
> So yes, printk is the primary output channel and having a readable printk output
> pretty much overrides any other concern.
>
> But that is not what you are doing. I get the impression that you are using printk
> as an _excuse_ to not have to work with the RAS people and run some parallel
> framework so that you do not have to work with them or listen to them. It is rather
> counter-productive. Working together is useful.

No.  I am not working on some other hardware error reporting framework
now.  I just want to make printk works better for hardware error
reporting.  For example, printk is not NMI-safe yet, so I need
lockless list and memory allocator to record the information in NMI
handler and printk them later.  And maybe in the future, we can make
printk NMI safe with similar method.  I think there is no
contradiction between my work and other RAS people's work.

Best Regards,
Huang Ying
