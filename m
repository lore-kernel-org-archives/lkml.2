Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab1ADOSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:18:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48605 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1ADOSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:18:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lKqFj6LcXxH6TXwKwkzRJGC8OZJICfQ+wo9xev+ZmSiTeYH/wdaGqb8/hms5OuG9a8
         PKRfLoSAkchqA63Jr2n2xW1uJvQTf4EEYbMxg/84YKAvMgJLZeTlarQj18UTunHrFBFU
         55RnZtD/bSjAKATBmg47RNBsMuWjw5PxX8tbA=
MIME-Version: 1.0
In-Reply-To: <20110104140355.GA1707@ucw.cz>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
	<20110104140355.GA1707@ucw.cz>
Date: Tue, 4 Jan 2011 22:18:49 +0800
Message-ID: <AANLkTinocDQ1J4FR5JO_j7qwLKv1QYPvZ1Y4r+v44esi@mail.gmail.com>
Subject: Re: [PATCH v0] add nano semaphore in kernel
From: Hillf Danton <dhillf@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 10:03 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> +/*
>> + * nano_semaphore_down - acquire the nano semaphore
>> + * @s: the nano semaphore to be acquired
>> + * @nano_secs: the nano seconds to wait if necessary,
>> + *           could be zero if want to wait as long as possible.
>> + *
>> + * Returns >0 if acquired successfully, <=0 otherwise.
>> + *
>> + * Note unlike down() in semaphore, nano_semaphore_down is not looping until
>> + * the nano semaphore is hold, but simply reports the result. And the callers
>> + * could, if they like, loop in simple manner, for instance,
>> + *   while (1 != nano_semaphore_down(s, 800));
>> + *   do_home_work();
>> + *   nano_semaphore_up(s);
>
> But thats spinlock, not semaphore, right?
>

Though spin lock involved, the caller has to sleep 800ns per loop.

> Also, your example does not use the API right -- according to
> description, 42 is correct 'semaphore acquired' reply...
>

As I understand, the example, though could be totally removed, does
not show the recommended usage of nano semaphore, but expresses the
difference from semaphore. The recommended however looks

       nano_semaphore_down(s, 0);
       do_home_work();
       nano_semaphore_up(s);

if you like to wait as long as possible.

Cheers
Hillf
