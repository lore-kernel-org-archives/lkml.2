Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab0JXUyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 16:54:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932438Ab0JXUyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 16:54:11 -0400
MIME-Version: 1.0
In-Reply-To: <4CC49AAB.5090809@fusionio.com>
References: <4CC49274.3030803@fusionio.com> <AANLkTik4qAzZPLO8HHBCM34_NLEEdPj04RyXPfeR-wSv@mail.gmail.com>
 <4CC49A4B.8010300@fusionio.com> <4CC49AAB.5090809@fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 24 Oct 2010 13:53:41 -0700
Message-ID: <AANLkTin-xocNea5k2m+P2a9XGfyoOf_0ZN=kj0fxm8Pg@mail.gmail.com>
Subject: Re: [GIT PULL] Revert of the IO stat fix
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 1:44 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> The patch itself is sound, the problems are around the area of it not
>> really liking non-elevator devices with the elv_quiesce_start/end()
>> parts. I had the below patch for that, but then I could not decide
>> whether we were fully safe on queue free after talking to Vivek about
>> it.
>
> Forgot to include it, here it is. I'll be offline from now and 1-2 days
> forward.

Hmm. I actually like this patch more than the revert. Except that I
think the __elv_quiesce_start/end() functions should be static, and
not exposed in the header file. There don't seem to be any other files
that would want to use them anyway, and the whole change looks very
sane since all the outside users used to have to take the lock
explicitly (and thus moving it inside the elv_quiesce_start/end
functions seems to be a nice cleanup).

So if this patch is supposed to fix things and doesn't have any
*known* problems, but you're just not entirely sure about it and we're
talking just a few days of you being gone, I'd almost rather take the
risk. If worst comes to worst, I can revert both this patch and the
original one. We _are_ in the middle of the merge window after all, so
I'm much more open to risks than I would be later in the -rc series..

                                 Linus
