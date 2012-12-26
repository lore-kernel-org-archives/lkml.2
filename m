Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab2LZClS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 21:41:18 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:46519 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2LZClQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 21:41:16 -0500
MIME-Version: 1.0
In-Reply-To: <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com>
References: <20121116192606.11799.35711.stgit@localhost.localdomain>
	<CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com>
	<20121121125310.00625f55@pyramind.ukuu.org.uk>
	<CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com>
	<CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com>
Date: Wed, 26 Dec 2012 10:41:14 +0800
Message-ID: <CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Josh Boyer <jwboyer@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 12:08 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Tue, Dec 18, 2012 at 10:20 AM, Josh Boyer <jwboyer@gmail.com> wrote:
>> On Wed, Nov 21, 2012 at 7:53 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>> On Wed, 21 Nov 2012 07:45:45 -0500
>>> Josh Boyer <jwboyer@gmail.com> wrote:
>>>
>>>> On Fri, Nov 16, 2012 at 2:27 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>>> >
>>>> > [The fb maintainer appears to be absent at the moment].
>>>> >
>>>> > This is needed to fix a pile of lockdep splats that now show up because console_lock()
>>>> > is being properly audited. Hugh Dickins and Sasha Levin have tested it and both reports
>>>> > all looks good. This is probably not the whole story - the entire fb layer has locking
>>>> > confusion problems that were previously hidden but it seems to get the ones people hit
>>>> > in testing. This hopefully explains a few of the weird fb hangs that have been floating
>>>> > around forever.
>>>> >
>>>> > From: Alan Cox <alan@linux.intel.com>
>>>> >
>>>> > Adjust the console layer to allow a take over call where the caller already
>>>> > holds the locks. Make the fb layer lock in order.
>>>> >
>>>> > This s partly a band aid, the fb layer is terminally confused about the
>>>> > locking rules it uses for its notifiers it seems.
>>>> >
>>>> > Signed-off-by: Alan Cox <alan@linux.intel.com>
>>>>
>>>> Should this eventually get into the stable trees?
>>>
>>> Thats a question I'm not sure about at this point. I think the bug is
>>> real but not caught by the lock checker in older trees but I've not
>>> investigated.
>>
>> So... this patch seems to still be twisting in the wind.  It should
>> probably be headed into 3.8 at this point, shouldn't it?
>
> Indeed it should. I'm seeing the original warnings in 3.8-rc1 and have
> to carry this patch to avoid them.

This patch can fix the following warning we saw?
http://lkml.org/lkml/2012/12/22/53

I will give it a try.
