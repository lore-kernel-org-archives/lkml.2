Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab2CWKsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 06:48:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42387 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab2CWKr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 06:47:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120210210423.GJ5650@redhat.com>
References: <1328751082.5611.6.camel@lappy> <CA+5PVA6HNqYv7kw3Oq_+05LwrXwtnNnZDkntcrncT2OmGXDd=w@mail.gmail.com>
 <CA+1xoqfYPYi2godgsgmnX7z7GQL+spNmMZhpdGU4UqfYGTB06g@mail.gmail.com>
 <4F34EC35.7010109@linux.vnet.ibm.com> <1328900283.25989.45.camel@laptop>
 <1328900633.25989.47.camel@laptop> <20120210200250.GG5650@redhat.com>
 <1328905121.25989.52.camel@laptop> <20120210203117.GI5650@redhat.com>
 <1328906163.25989.59.camel@laptop> <20120210210423.GJ5650@redhat.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 23 Mar 2012 12:47:38 +0200
Message-ID: <CA+1xoqeSMSaXCUbZyB2GAXc+2i=gcX3+zP41ss45YUjyr7F_zA@mail.gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/smp.c:119 native_smp_send_reschedule+0x25/0x43()
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Josh Boyer <jwboyer@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm just wondering about the status of the patches to fix this issue,
this is still happening on linux-next.

On Fri, Feb 10, 2012 at 11:04 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Fri, Feb 10, 2012 at 09:36:03PM +0100, Peter Zijlstra wrote:
>> On Fri, 2012-02-10 at 15:31 -0500, Don Zickus wrote:
>> > So my second patch which I will eventually post will just skip the WARN_ON
>> > if the system is going down.  Not sure if that is the proper way to address
>> > this problem or change all of the stop_this_cpu code to use a different
>> > bitmask than the cpu_online bitmask (but then you run the risk of a stuck
>> > IPI I guess if the cpu is halted without notifying anyone).
>>
>> Yeah, the async hard kill of all cpus is bound to make problems.. what
>> I'm wondering is, why is this in the normal shutdown path and not
>> specific to a hard panic?
>
> I didn't write the original code, I just changed it from REBOOT_IRQ to
> NMI and left all the stop_this_cpu stuff alone.
>
>>
>> Trying to make this work is just not going to be pretty, and in the
>> panic case we really don't care much.
>
> Sure.
>
> Cheers,
> Don
