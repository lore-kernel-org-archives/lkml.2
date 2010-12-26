Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab0LZNMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 08:12:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39468 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0LZNMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 08:12:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pcc2bS6sfI1lM2uqB8WbKAh7p0GCZI7fH6o6HpopLR8BqBhDpovKAE/TRdmCdqCy18
         GiRiiQM6lxtNfy3ZwQsdysy1jMHNAa5XXHMqI37mdLjrHi22heeHF8s1itlBp5uoF+F4
         PKpzyl1axLdytArV3sQJvJkSL9uBFZ9ZQ6eX8=
Date: Sun, 26 Dec 2010 21:12:05 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix unsafe operation in high resolution timer
Message-ID: <20101226131205.GA5757@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <AANLkTinvHP4rZ6PSyEOJ_ZJ2chRJX0ZyzuhNoCRrO1wK@mail.gmail.com>
 <AANLkTikVQU6ozp0H1u7ghd0=miYyUJL62uP=0FBZSLok@mail.gmail.com>
 <AANLkTimc0FwBhj5MsnibTTq94AgaQgqCKEXNSOvM_XjE@mail.gmail.com>
 <20101225021209.GA11183@zhy>
 <AANLkTimez6segEYEsdsvELqvHjrfY4rPQg6CG_7vyxCq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTimez6segEYEsdsvELqvHjrfY4rPQg6CG_7vyxCq@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 10:19:11PM +0800, Hillf Danton wrote:
> > But for a hrtimer which is not free in its callback, like a
> > static defined one. the hrtimer could be referenced at the same
> > time. So here you cann't just delete the two lines.
> 
> After callback, as you agree, it is hard to determine in the current
> implementation if the hrtimer is static defined, though another bit
> could be added, say, in the flag word of hrtimer

Yeah, that is an option, like a flag FREE_IN_CALLBACK/ONESHOT which
indicate that. Or just let the callback return another value like
HRTIMER_FREED. But as I said before I'm not sure what's the best way
to fix that. And maybe there's more suitable method.

BTW, is there any user who free the hrtimer in its callback?

> , so cutting the two
> lines off is deserved.
> And more, who will take care of the NORESTART again after callback?

It's not related to NORESTART, just HRTIMER_STATE_CALLBACK.
hrtimer'strategy somehow depends on HRTIMER_STATE_CALLBACK.
You can take a look at the caller of hrtimer_callback_running().

Thanks,
Yong
