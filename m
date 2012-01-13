Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab2AML3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 06:29:30 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65428 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab2AML3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 06:29:24 -0500
Message-ID: <4F10154F.7000605@mvista.com>
Date: Fri, 13 Jan 2012 15:28:15 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Paul Taysom <taysom@chromium.org>
CC: unlisted-recipients:"; Paul Taysom" <taysom@google.com>,
        Mandeep Baines <msb@chromium.org>, Greg KH <greg@kroah.com>,
        Jens Axboe <axboe@kernel.dk>, Theodore Tso <tytso@google.com>,
        Andrew Morton <akpm@google.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	unlisted-recipients:;Paul Taysom <taysom@google.com>
					     ^-missing end of address
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
References: <1326398262-26660-1-git-send-email-taysom@chromium.org>
In-Reply-To: <1326398262-26660-1-git-send-email-taysom@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12-01-2012 23:57, Paul Taysom wrote:

> From: Paul Taysom<taysom@google.com>

> A USB stick with a ext file system on it, would occasionally crash
> when the stick was pulled.

> The problem was a timer was being set on the Backing Device Interface,
> bdi, after the USB device had been removed and the bdi had been
> unregistered. The bdi would then be later reinitialized by zeroing
> the timer without removing from the timer from the timer queue.
> This would eventually result in a kernel crash (NULL ptr dereference).

> When the bdi is unregistered, the dev field is set to NULL. This
> indication is used by bdi_unregister to only unregister the device
> once.

> Fix: When the backing device is invalidated, the mapping backing_dev_info
> should be redirected to the default_backing_dev_info.

> Created 3 USB sticks with ext2, ext4 and one with both apple and DOS
> file systems on it. Inserted and removed USB sticks many times in random
> order. With out the bug fix, the kernel would soon crash. With the fix,
> it did not. Ran on both stumpy and amd64-generic.

> Signed-off-by: Paul Taysom <taysom@chromium.org>
> Downstream-bug-report: http://crosbug.com/24165
> Cc: Mandeep Baines <msb@chromium.org>
> Cc: Greg KH <greg@kroah.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Theodore Tso <tytso@google.com>
> Cc: Andrew Morton <akpm@google.com>
> Cc: <linux-usb@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: <linux-fsdevel@vger.kernel.org>
> ---
>   fs/block_dev.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)

> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index afe74dd..9f9b617 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1,4 +1,4 @@
> -/*
> +nvalid/*

    Huh?

>    *  linux/fs/block_dev.c
>    *
>    *  Copyright (C) 1991, 1992  Linus Torvalds

WBR, Sergei
