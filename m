Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1APV5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 16:57:18 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42188 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab1APV5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 16:57:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Ui8mhK9wXzBVsc3Iof0qWyhxCgqAVc7p8QJ6AgiFvRwLAycOevWF2D8/IJ9xvuDtAs
         B7NiPNAD1nSM4LIs57NUY1Xipx5hhCkeRl9MUnlZCL6UWhBPgCHk085KqifkDDqpUgDR
         tjZTJfH+DMxhTrhIxeEB94DC2SHpXdXC9Vk3Q=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110116214426.GD22723@ZenIV.linux.org.uk>
References: <20110116185745.GB22723@ZenIV.linux.org.uk>
	<AANLkTim1SS2Y1EL9iB2jDSUbqofoaWXig-xHa12Ogm95@mail.gmail.com>
	<AANLkTinZ5ng+hbOHz7DKy82HPqFwYhQvmmbM+ioSWp9x@mail.gmail.com>
	<20110116214426.GD22723@ZenIV.linux.org.uk>
Date: Sun, 16 Jan 2011 22:57:14 +0100
Message-ID: <AANLkTin2XrGGeoN-25_CeAvEbAduifeFFkxVKcYoXcKm@mail.gmail.com>
Subject: Re: [git pull] vfs pile 2 (automount work)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Joachim Eastwood <manabian@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 10:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Jan 16, 2011 at 01:37:54PM -0800, Linus Torvalds wrote:
>> On Sun, Jan 16, 2011 at 1:15 PM, Joachim  Eastwood <manabian@gmail.com> wrote:
>> >
>> > f03c65993b98eeb909a4012ce7833c5857d74755 - sanitize vfsmount refcounting changes
>> >
>> > Breaks my ARM !CONFIG_SMP compile
>>
>> In fact, any non-SMP compile, it's not ARM-specific.
>>
>> The simple fix for the build breakage should be to just move the
>> mnt_longterm thing out of the #ifdef CONFIG_SMP in
>> include/linux/mount.h. But I do worry that it would cause some count
>> imbalance, because there are some accesses that are still inside that
>> CONFIG_SMP case in mntput_no_expire().
>>
>> Al, please take a look,
>
> Already fixed.  Actually, taking it out of ifdef would work (the only
> place that actually cares about the value of that sucker is SMP side
> of mntput()), but we are obviously better off just not touching it on
> UP at all - why do pointless work and waste space?
>
> See the patch upthread.  ->mnt_longterm is SMP-only optimization of
> mntput(); it's there only to free the common case of mntput() from
> cacheline bouncing and on UP it's needed at all.
>

You push "mnt_longterm is there only on SMP" patch also for "for-next"
GIT branch?

- Sedat -
