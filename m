Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab2AMPj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:39:27 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:58512 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2AMPjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:39:25 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA7Yffs3-qdq6pSqDKLLngU7kBsdE92e31NnAM0=wrwp4w@mail.gmail.com>
References: <1326402935-31002-1-git-send-email-taysom@chromium.org>
	<CA+5PVA7Yffs3-qdq6pSqDKLLngU7kBsdE92e31NnAM0=wrwp4w@mail.gmail.com>
Date: Fri, 13 Jan 2012 07:39:25 -0800
Message-ID: <CAKwO_5EjZCOKLYu2eZz8guTSRJw6-A5SHp23dEhW3cSo6P3KLQ@mail.gmail.com>
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
From: Paul Taysom <taysom@google.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Paul Taysom <taysom@chromium.org>, Mandeep Baines <msb@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Greg KH <greg@kroah.com>,
        Jens Axboe <axboe@kernel.dk>, Theodore Tso <tytso@google.com>,
        Andrew Morton <akpm@google.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 9:42 PM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Thu, Jan 12, 2012 at 4:15 PM, Paul Taysom <taysom@chromium.org> wrote:
>> From: Paul Taysom <taysom@google.com>
>>
>> A USB stick with a ext file system on it, would occasionally crash
>> when the stick was pulled.
>>
>> The problem was a timer was being set on the Backing Device Interface,
>> bdi, after the USB device had been removed and the bdi had been
>> unregistered. The bdi would then be later reinitialized by zeroing
>> the timer without removing from the timer from the timer queue.
>> This would eventually result in a kernel crash (NULL ptr dereference).
>
> What backtrace did you see when it crashed?  There have been a number of
> reports where sd_revalidate_disk is at the top of the backtrace and this sounds
> like it might be related.
>
> josh

I had several different crash traces some can be seen in
http://crosbug.com/24165

The reason that there are different crash traces is that the code path
to crash would just be the victim of the memory corruption caused
earlier. However, most of them had to do with setting or clearing
timers. There are additional problems related to lost I/O requests
that I'm still looking at.
-Paul
