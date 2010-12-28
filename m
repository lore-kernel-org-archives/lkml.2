Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab0L1NNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 08:13:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60245 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab0L1NNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 08:13:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VQ0LMKmVp/lTqvzYFEhH4j9WOzaR4Sk8fWCSkW2xXmArs1FBqvV2nGf0SwtBlomTd6
         4BaZCSxSIYHI5CNNSpBrdkqu1pFFxNu/BKJMERziMnFDEtD+xkzUVUkIYpMiKZ3UiG1/
         dQBIzVu6bKLz53djnOFMw3w1ni8gLNjNiAggU=
MIME-Version: 1.0
In-Reply-To: <201012272215.52642.arnd@arndb.de>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
	<201012272215.52642.arnd@arndb.de>
Date: Tue, 28 Dec 2010 21:13:19 +0800
Message-ID: <AANLkTimG6EPdy+crpxc_HDzAMd-4WCaivsTMiQkiFFns@mail.gmail.com>
Subject: Re: [PATCH v0] add nano semaphore in kernel
From: Hillf Danton <dhillf@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 5:15 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 26 December 2010, Hillf Danton wrote:
>>
>> Based upon high resolution timer and idea borrowed from semaphore,
>> nano semaphore is created.
>>
>> Nano semaphore provides finer time resolution depending on system
>> configuration and capabilities.
>>
>> Nano semaphore is not to replace semaphore, but used in application
>> environments where nano seconds are required.
>>
>> Three methods, nano_semaphore_try_down, nano_semaphore_down and
>> nano_semaphore_up are implemented in a header file, and there is no
>> corresponding C file since nano semaphore is not complex.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>
> There are very few users of real semaphores today, and we're trying to
> get rid of them. It's not clear what your requirements are, since you
> have not posted any new users of this, but instead of adding more

I want to add new way to do semaphore with finer time resolution,
without considering much about its potential usage.

And I learn from your comments there is more to do, thanks.

> locking primitives, I would recommend changing one of the existing
> ones (mutex, semaphore, rwsem) to have nanosecond timeouts instead
> of jiffies.
>
> The easiest way would certainly be to change the three users of
> down_timeout() to use nanoseconds.
>

I will try the three instances of down_timeout() soon.

Thanks
Hillf
