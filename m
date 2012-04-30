Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab2D3IBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 04:01:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38566 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2D3IBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 04:01:41 -0400
MIME-Version: 1.0
In-Reply-To: <4F9E44AD.8020701@kernel.org>
References: <4F9E39F1.5030600@kernel.org>
	<CAOJsxLE3A3b5HSrRm0NVCBmzv7AAs-RWEiZC1BL=se309+=WTA@mail.gmail.com>
	<4F9E44AD.8020701@kernel.org>
Date: Mon, 30 Apr 2012 11:01:40 +0300
X-Google-Sender-Auth: 4DgnBQN3WAtJMv0MkHIqHt1UVJ4
Message-ID: <CAOJsxLGd_-ZSxpY2sL8XqyiYxpnmYDJJ+Hfx-zi1Ty=-1igcLA@mail.gmail.com>
Subject: Re: vmevent: question?
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On Mon, Apr 30, 2012 at 10:52 AM, Minchan Kim <minchan@kernel.org> wrote:
>> It makes the userspace side simpler for "lowmem notification" use
>> case. I'm open to changing the ABI if it doesn't make the userspace
>> side too complex.
>
> Yes. I understand your point but if we still consider all of values,
> we don't have any way to capture exact values except triggered event value.
> I mean there is no lock to keep consistency.
> If stale data is okay, no problem but IMHO, it could make user very confusing.
> So let's return value for first matched event if various event match.
> Of course, let's write down it in ABI.
> If there is other idea for reporting all of item with consistent, I'm okay.

What kind of consistency guarantees do you mean? The data sent to
userspace is always a snapshot of the state and therefore can be stale
by the time it reaches userspace.

If your code needs stricter consistency guarantees, you probably want
to do it in the kernel.

                                Pekka
