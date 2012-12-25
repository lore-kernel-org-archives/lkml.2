Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2LYQIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 11:08:55 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:39342 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2LYQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 11:08:53 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com>
References: <20121116192606.11799.35711.stgit@localhost.localdomain>
 <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com>
 <20121121125310.00625f55@pyramind.ukuu.org.uk> <CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 25 Dec 2012 11:08:32 -0500
Message-ID: <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
To: Josh Boyer <jwboyer@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        florianSchandinat@gmx.de,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 10:20 AM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Wed, Nov 21, 2012 at 7:53 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> On Wed, 21 Nov 2012 07:45:45 -0500
>> Josh Boyer <jwboyer@gmail.com> wrote:
>>
>>> On Fri, Nov 16, 2012 at 2:27 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>> >
>>> > [The fb maintainer appears to be absent at the moment].
>>> >
>>> > This is needed to fix a pile of lockdep splats that now show up because console_lock()
>>> > is being properly audited. Hugh Dickins and Sasha Levin have tested it and both reports
>>> > all looks good. This is probably not the whole story - the entire fb layer has locking
>>> > confusion problems that were previously hidden but it seems to get the ones people hit
>>> > in testing. This hopefully explains a few of the weird fb hangs that have been floating
>>> > around forever.
>>> >
>>> > From: Alan Cox <alan@linux.intel.com>
>>> >
>>> > Adjust the console layer to allow a take over call where the caller already
>>> > holds the locks. Make the fb layer lock in order.
>>> >
>>> > This s partly a band aid, the fb layer is terminally confused about the
>>> > locking rules it uses for its notifiers it seems.
>>> >
>>> > Signed-off-by: Alan Cox <alan@linux.intel.com>
>>>
>>> Should this eventually get into the stable trees?
>>
>> Thats a question I'm not sure about at this point. I think the bug is
>> real but not caught by the lock checker in older trees but I've not
>> investigated.
>
> So... this patch seems to still be twisting in the wind.  It should
> probably be headed into 3.8 at this point, shouldn't it?

Indeed it should. I'm seeing the original warnings in 3.8-rc1 and have
to carry this patch to avoid them.


Thanks,
Sasha
