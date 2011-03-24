Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab1CXT1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:27:15 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:32797 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687Ab1CXT1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:27:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TslVoINfUzWjNHMkoFTWqEr6gFWBHsClxltuJx2d9hPQxoZoeuX3/zCBzdnxKceBPg
         2LnElYPwTZHe5LfEfXQ9UNs1Ey2OLDkClEqL225I3PwR5L8jvKn49YtYeo0udyD86JmI
         RR2SrRoTP3boO9TkYW/IbgJprWhTHGBhUgv+k=
MIME-Version: 1.0
In-Reply-To: <20110324192247.GA5477@elte.hu>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
	<20110324142146.GA11682@elte.hu>
	<alpine.DEB.2.00.1103240940570.32226@router.home>
	<AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
	<20110324172653.GA28507@elte.hu>
	<20110324185258.GA28370@elte.hu>
	<alpine.LFD.2.00.1103242005530.31464@localhost6.localdomain6>
	<20110324192247.GA5477@elte.hu>
Date: Thu, 24 Mar 2011 21:27:09 +0200
X-Google-Sender-Auth: _iAPM6QIYoP1czodZWIA8Jq3l9c
Message-ID: <AANLkTinBwM9egao496WnaNLAPUxhMyJmkusmxt+ARtnV@mail.gmail.com>
Subject: Re: [boot crash #2] Re: [GIT PULL] SLAB changes for v2.6.39-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 9:22 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> On Thu, 24 Mar 2011, Ingo Molnar wrote:
>> > RIP: 0010:[<ffffffff810570a9>]  [<ffffffff810570a9>] get_next_timer_interrupt+0x119/0x260
>>
>> That's a typical timer crash, but you were unable to debug it with
>> debugobjects because commit d3f661d6 broke those.
>>
>> Christoph, debugobjects do not need to run with interupts
>> disabled. And just because they were in that section to keep all the
>> debug stuff together does not make an excuse for not looking at the
>> code and just slopping it into some totally unrelated ifdef along with
>> a completely bogus comment.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  mm/slub.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6/mm/slub.c
>> ===================================================================
>> --- linux-2.6.orig/mm/slub.c
>> +++ linux-2.6/mm/slub.c
>> @@ -849,11 +849,11 @@ static inline void slab_free_hook(struct
>>               local_irq_save(flags);
>>               kmemcheck_slab_free(s, x, s->objsize);
>>               debug_check_no_locks_freed(x, s->objsize);
>> -             if (!(s->flags & SLAB_DEBUG_OBJECTS))
>> -                     debug_check_no_obj_freed(x, s->objsize);
>>               local_irq_restore(flags);
>>       }
>>  #endif
>> +     if (!(s->flags & SLAB_DEBUG_OBJECTS))
>> +             debug_check_no_obj_freed(x, s->objsize);
>
> Thanks, this did the trick!
>
> Tested-by: Ingo Molnar <mingo@elte.hu>
>
> With this fix i got the warning below - pinpointing a net/bluetooth/hci_core.c
> timer bug.

Applied, thanks!
