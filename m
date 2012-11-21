Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2KUOvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:51:43 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33832 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab2KUOvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:51:41 -0500
MIME-Version: 1.0
In-Reply-To: <20121121144624.GA21766@kroah.com>
References: <1353475147-28308-1-git-send-email-sachin.kamat@linaro.org>
	<20121121144624.GA21766@kroah.com>
Date: Wed, 21 Nov 2012 20:21:40 +0530
Message-ID: <CAK9yfHy9Pnaoc-bdynFAE=U7=Njz00T8FRdLXTRvhopSxXS9Ng@mail.gmail.com>
Subject: Re: [PATCH 1/1] tty: vt: Remove redundant null check before kfree.
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2012 20:16, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Nov 21, 2012 at 10:49:07AM +0530, Sachin Kamat wrote:
>> kfree on a NULL pointer is a no-op.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/tty/vt/consolemap.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
>> index 2aaa0c2..248381b 100644
>> --- a/drivers/tty/vt/consolemap.c
>> +++ b/drivers/tty/vt/consolemap.c
>> @@ -410,10 +410,8 @@ static void con_release_unimap(struct uni_pagedir *p)
>>               kfree(p->inverse_translations[i]);
>>               p->inverse_translations[i] = NULL;
>>       }
>> -     if (p->inverse_trans_unicode) {
>> -             kfree(p->inverse_trans_unicode);
>> -             p->inverse_trans_unicode = NULL;
>> -     }
>> +     kfree(p->inverse_trans_unicode);
>> +     p->inverse_trans_unicode = NULL;
>
> kfree with NULL is a no-op, but the line after that just caused a kernel
> crash if it was NULL, so I can't accept this type of thing.
>
> Please be more careful.

My mistake. Apologies for the same.

Do we need to assign the pointer to NULL after freeing?

>
> What's with the patches@linaro.org email address?  What is that for?
That is a logging mechanism (done by patchwork) for all patches sent
by Linaro engineers.

>
> thanks,
>
> greg k-h



-- 
With warm regards,
Sachin
