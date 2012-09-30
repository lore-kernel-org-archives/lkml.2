Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab2I3S7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 14:59:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50572 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2I3S7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 14:59:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120930144930.GA27329@kroah.com>
References: <1348950199-30460-1-git-send-email-geert@linux-m68k.org>
	<20120930144930.GA27329@kroah.com>
Date: Sun, 30 Sep 2012 20:59:05 +0200
X-Google-Sender-Auth: Xj9S5MjD0TeAPMLo95n37IGYbZ0
Message-ID: <CAMuHMdW19BQti_EWdgynWwOZCuhTQO-tJbN9Q8gBnUcA=auEKg@mail.gmail.com>
Subject: Re: [PATCH] sysfs: sysfs_pathname/sysfs_add_one: Use strlcat()
 instead of strcat()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alex Williamson <alex.williamson@hp.com>, Alex Chiang <achiang@hp.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sun, Sep 30, 2012 at 4:49 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sat, Sep 29, 2012 at 10:23:19PM +0200, Geert Uytterhoeven wrote:
>> The warning check for duplicate sysfs entries can cause a buffer overflow
>> when printing the warning, as strcat() doesn't check buffer sizes.
>> Use strlcat() instead.
>
> As the comment said, we knew about this, but I have never seen it, do
> you know of a way to trigger it?

I expected there would be a check somewhere else in the code, so we can
never overflow here. But I did manage to overflow the buffer by having a real
long name (4060 characters) in a conflicting mfd_cell.
There may be other ways.

I don't know how likely it is to trigger in a real world scenario. Is
there a limit
on the depth of sysfs? Or can it go unbounded, e.g. by cascading USB hubs?

>> Cc: stable@vger.kernel.org
>
> Given that I don't know of any way to actually hit this problem, is it
> really needed for older kernel releases?

That's up to you to decide...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
