Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0L0NMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 08:12:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50429 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab0L0NMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 08:12:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=U80qoBf3TZb/8csYkqHITCCk7LPHGkjaCdgLaix0/M7MIHOOWwWeWDh0bXolkI3N47
         K++31q3TDw6JpcqNoaSuAMS1gfiRlpeUuzeGSGSpU2sthwYdrkSPPZYg+ZXEbkqbRz1Y
         //EbAtKH33fuzACu6XWiDHanpiQJKV6R7seKQ=
MIME-Version: 1.0
In-Reply-To: <20101226131205.GA5757@zhy>
References: <AANLkTinvHP4rZ6PSyEOJ_ZJ2chRJX0ZyzuhNoCRrO1wK@mail.gmail.com>
	<AANLkTikVQU6ozp0H1u7ghd0=miYyUJL62uP=0FBZSLok@mail.gmail.com>
	<AANLkTimc0FwBhj5MsnibTTq94AgaQgqCKEXNSOvM_XjE@mail.gmail.com>
	<20101225021209.GA11183@zhy>
	<AANLkTimez6segEYEsdsvELqvHjrfY4rPQg6CG_7vyxCq@mail.gmail.com>
	<20101226131205.GA5757@zhy>
Date: Mon, 27 Dec 2010 21:12:50 +0800
Message-ID: <AANLkTimO-dACVbTtLWEPLVWwN_dgNOaEb-1JDv+8ku+_@mail.gmail.com>
Subject: Re: [PATCH] fix unsafe operation in high resolution timer
From: Hillf Danton <dhillf@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 9:12 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Sat, Dec 25, 2010 at 10:19:11PM +0800, Hillf Danton wrote:
>> > But for a hrtimer which is not free in its callback, like a
>> > static defined one. the hrtimer could be referenced at the same
>> > time. So here you cann't just delete the two lines.
>>
>> After callback, as you agree, it is hard to determine in the current
>> implementation if the hrtimer is static defined, though another bit
>> could be added, say, in the flag word of hrtimer
>
> Yeah, that is an option, like a flag FREE_IN_CALLBACK/ONESHOT which
> indicate that. Or just let the callback return another value like

The result of callback sounds fine.
Hillf

> HRTIMER_FREED. But as I said before I'm not sure what's the best way
> to fix that. And maybe there's more suitable method.
>
> BTW, is there any user who free the hrtimer in its callback?
>
>> , so cutting the two
>> lines off is deserved.
>> And more, who will take care of the NORESTART again after callback?
>
> It's not related to NORESTART, just HRTIMER_STATE_CALLBACK.
> hrtimer'strategy somehow depends on HRTIMER_STATE_CALLBACK.
> You can take a look at the caller of hrtimer_callback_running().
>
> Thanks,
> Yong
>
