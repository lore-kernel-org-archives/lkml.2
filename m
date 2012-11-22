Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab2KVSpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:45:12 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36477 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab2KVSpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:45:10 -0500
MIME-Version: 1.0
In-Reply-To: <20121122003835.GA24936@kroah.com>
References: <1353475147-28308-1-git-send-email-sachin.kamat@linaro.org>
	<20121121144624.GA21766@kroah.com>
	<50AD5916.3030604@suse.cz>
	<20121121230057.GA29095@kroah.com>
	<50AD60EC.3090302@suse.cz>
	<20121122003835.GA24936@kroah.com>
Date: Thu, 22 Nov 2012 10:49:43 +0530
Message-ID: <CAK9yfHxu1xgDmQJLN80f40cxMsamVreH_k6nngkOWv-x9_wzSA@mail.gmail.com>
Subject: Re: [PATCH 1/1] tty: vt: Remove redundant null check before kfree.
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2012 06:08, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 22, 2012 at 12:17:00AM +0100, Jiri Slaby wrote:
>> On 11/22/2012 12:00 AM, Greg KH wrote:
>> > On Wed, Nov 21, 2012 at 11:43:34PM +0100, Jiri Slaby wrote:
>> >> On 11/21/2012 03:46 PM, Greg KH wrote:
>> >>> On Wed, Nov 21, 2012 at 10:49:07AM +0530, Sachin Kamat wrote:
>> >>>> --- a/drivers/tty/vt/consolemap.c
>> >>>> +++ b/drivers/tty/vt/consolemap.c
>> >>>> @@ -410,10 +410,8 @@ static void con_release_unimap(struct uni_pagedir *p)
>> >>>>                  kfree(p->inverse_translations[i]);
>> >>>>                  p->inverse_translations[i] = NULL;
>> >>>>          }
>> >>>> -        if (p->inverse_trans_unicode) {
>> >>>> -                kfree(p->inverse_trans_unicode);
>> >>>> -                p->inverse_trans_unicode = NULL;
>> >>>> -        }
>> >>>> +        kfree(p->inverse_trans_unicode);
>> >>>> +        p->inverse_trans_unicode = NULL;
>> >>>
>> >>> kfree with NULL is a no-op, but the line after that just caused a kernel
>> >>> crash if it was NULL, so I can't accept this type of thing.
>> >>
>> >> Greg, I'm not sure -- what do you mean here? The change actually looks
>> >> fine to me... We do not dereference p->inverse_trans_unicode there.
>> >
>> > If we never dereference it, why is it being set to NULL?
>>
>> I'm not disputing the assignment. Let it there. But I do not see any
>> issues with the patch. What problem do you see exactly?
>
> {sigh}  Nothing.  I don't know what I was thinking, my apologies
> Sachin, there's nothing wrong with this patch.
>
> I blame my fried brain, after reviewing all of those __dev* removal
> patches :)
>
> Sachin, can you resend these patches so I can apply them?

No problem Greg. I will send them again.

>
> thanks,
>
> greg k-h



-- 
With warm regards,
Sachin
