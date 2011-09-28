Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab1I1Prh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:47:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37177 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab1I1Prg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:47:36 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MUbiQW3E8GeSbzkikMqvV1VKAnF2Ro-P2BWwih=s6vABA@mail.gmail.com>
References: <CA+55aFwdm3n+xehYc1cronkcwLE79ZYtr96LiVWD2WjKkaZ5DA@mail.gmail.com>
 <CACqU3MXzUbQS9fy0Etgt2GcgwRoXfihhmw-aWjrCFbzvmDM7yg@mail.gmail.com>
 <CA+55aFwKyd5fuyxu2tGDbQ8gKiEj=z7uYdBRg9O46WN0sTeNTQ@mail.gmail.com>
 <CACqU3MU8jkysNxFasdfy9ksqSo2ojiZ5LUwfcfX13MMRgVx2Xw@mail.gmail.com>
 <CACqU3MWyCknNH3xmVmbJJu+w9ugNc3e4K3e3_6cY1RAy4ynJCQ@mail.gmail.com>
 <CA+55aFxp8bNhLs+v69gp7XxBGq6wkmLkZKjB2_09H3qsZC_pzw@mail.gmail.com> <CACqU3MUbiQW3E8GeSbzkikMqvV1VKAnF2Ro-P2BWwih=s6vABA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Sep 2011 08:47:15 -0700
X-Google-Sender-Auth: T8ydZfbRl-AI4UjzWMZSuJ3UYlc
Message-ID: <CA+55aFwf3iOwyDDxjKbJ0fs=fy+-8mkoFHdgsEq32nAkerXS4g@mail.gmail.com>
Subject: Re: Linux 3.1-rc7
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 10:34 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>
> <off-topic>
> Speaking of corruption, I'm encountering another set on an external
> hard-drive, connected through USB.

I don't think it's unrelated or off-topic.

>     The same corruption pop up (at least in those text file): a
> sequence of 4 bytes is replaced by 0x000000E0 at offset 0x1E4 of the
> start of the file for some of them, 0x3E4 for two other (same
> corruption though). Locating the corruption will be more tricky in
> binary files.

So it's possible that it's some rogue kernel pointer. We've certainly
had those before. Constants offsets like that happen with some
structure allocation that just happens to be say 1kB in size, and the
rogue kernel pointer assigns at a fixed offset to something that has
already been free'd.

You might want to try to compile the kernel with SLUB_DEBUG_ON set,
and possibly also DEBUG_PAGEALLOC.

HOWEVER. It's quite possible that it's hardware too.

> I may not trust the drive, but the fact that only known offset are
> corrupted (in text files), the exact same way, sounds too much of a
> coincidence. Anyway, I started a long SMART self test to see if it
> catches anything, as there was no DMA transfer error[0].

It *could* be the disk, but it's much more likely to be something like
memory or a bad cable. Which wouldn't show up with SMART, since that
just tests internal disk issues.

Do you get some occasional random SIGSEGV's too?

                        Linus
