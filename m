Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2JPKOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:14:39 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:51118 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2JPKOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:14:38 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH v2] fat: editions to support fat_fallocate()
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
	<87lif958lb.fsf@devron.myhome.or.jp>
	<CAKYAXd9CQoYBHb0S4bpU0-6QMwMvfC7m=RhDCYPzKwXfvu7VKw@mail.gmail.com>
Date: Tue, 16 Oct 2012 19:14:33 +0900
In-Reply-To: <CAKYAXd9CQoYBHb0S4bpU0-6QMwMvfC7m=RhDCYPzKwXfvu7VKw@mail.gmail.com>
	(Namjae Jeon's message of "Tue, 16 Oct 2012 13:12:56 +0900")
Message-ID: <87txtu206u.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> What is real usage pattern of persistent across remounts on FAT?
> Yes,  like a TORRENT FILE -> it reserves space in advance
> even though the system can be rebooted/disk unmounted and remount
> but the space still remains there - as long as the torrent exists
> Or if Torrent case does not matches currently
> Then, Consider a case for a TV series to be recorded
> Since – we want all the parts to be recorded on the same file (i.e.,
> APPEND write) – and in such cases there are chances of TV shutdown,
> device unmount-mount again. So, we need to have the space to be remain
> available in such cases.

The expectation of fallocate() is just for space reservation? If it was
just for space reservation, I'm not sure, why TV applications can't
reserve in userland without any kernel help (I wonder who interrupts TV
application). I feel a bit, it may be more lightweight than fallocate(),
and more reliable than out of spec fallocate().

I'm still not sure why apps really want fallocate() on FAT.

>> If once device was unmounted, we can't know the state of FS anymore, there are
>> many implementations of FAT. And preallocation is not in the spec.
> I agree, As you said before, we can make fat fallocate feature as
> configurable – so this is entirely in the hands of USER.
>>
>> I worry to break something. And I guess the freeing preallocation on
>> last close may fix the issue for usage.
> Okay, we can avoid most of your concerns except suddenly unplugging usb device.
> But fallocate behavior will be different with other filesystem.
>
> How about to make fat fallocate with configuration to be used by users
> is having needs?

Hmm... I'm not still convinced to add makes really apps happy. Maybe,
I'm sill not understanding your usage. I think the out of spec feature
wouldn't be added if it was just a "better than nothing".

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
