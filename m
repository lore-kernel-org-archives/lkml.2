Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1IVDZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 23:25:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39061 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1IVDZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 23:25:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110921211007.GA13605@suse.de>
References: <1316619573-9104-1-git-send-email-consul.kautuk@gmail.com>
	<20110921155444.GA27121@suse.de>
	<CAFPAmTR1bHBronJqVWh_osjJvsPi_gWqJ50Ls-WgCi7CMAViUA@mail.gmail.com>
	<20110921211007.GA13605@suse.de>
Date: Thu, 22 Sep 2011 08:55:12 +0530
Message-ID: <CAFPAmTTBpLEH8pozfTknnLYVGnjTCXooM_eiTr5ZcaE4poWGFg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Trivial: devtmpfsd: Setting task running/interruptible
 states
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Jiri Kosina <trivial@kernel.org>, jkosina@suse.cz,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 2:40 AM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Sep 21, 2011 at 09:54:01PM +0530, kautuk.c @samsung.com wrote:
>> Hi Greg,
>>
>> On Wed, Sep 21, 2011 at 9:24 PM, Greg KH <gregkh@suse.de> wrote:
>> > On Wed, Sep 21, 2011 at 09:09:33PM +0530, Kautuk Consul wrote:
>> >> This trivial patch makes the following changes in devtmpfsd() :
>> >
>> > This is not the definition of "trivial" in that you are changing the
>> > logic of the code, not just doing spelling changes.
>>
>> Well, I didn't really change the performance/functionality so I called
>> it trivial.
>
> You changed the code logic,

Hmm. Not the code logic of devtmpfsd as such but of the loop involved.

> which is not trivial at all in this area.

Ok.
If you want, maybe I could send another patch for this without marking
it "trivial".

>
> And actually unneeded from what I can tell, right?

Well, there *are* 2 overheads.
As I mentioned, the overheads which I tried to remove by this patch is an extra
memory barrier as well as setting of the task state to TASK_RUNNING.
Of course, they are very minimal and that's why I called this change "trivial".

>
>> >
>> >> - Set the state to TASK_INTERRUPTIBLE using __set_current_state
>> >>   instead of set_current_state as the spin_unlock is an implicit
>> >>   memory barrier.
>> >
>> > Why?  What is this hurting with the original code?
>>
>> Nothing really hurting, that's why I called this patch trivial.
>> There is an extra memory barrier we have to go through by way of
>> set_current_state, which is mb().
>> That would lead to more overhead on the parallel pipelines of the processor
>> as they will have to cease being parallel for instructions before and after
>> the memory barrier despite the fact that the spin_unlock already covers this.
>> We can do without this because as per the Documentation/memory-barriers.txt,
>> atomic operations and unlocks give reliable ordering to instructions.
>
> But the current code is correct, and not hurting anything, and it's not
> on a "fast path" at all, so I'd prefer to keep it as-is and not change
> it for the sake of changing it, so I'm not going to accept this patch,
> sorry.

Ok.
However, I see many changes going in which are purely cosmetic like
restructuring or clean-up of a function, etc.
So this is a category of change that lies (in importance) between a
cosmetic/trivial
change and a minor logic change.
Since this patch is still technically correct, do you mean to say that
this cannot even
be looked as some sort of a "technical" cleanup ?

Also, I see you did not include my comment about the removal of the setting of
TASK_RUNNING. Do you at least accept that ?
If that is so, maybe you could accept the first patch I sent.

Anyway, thanks for the info.

>
> greg k-h
>
