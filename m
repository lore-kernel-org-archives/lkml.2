Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab2KTVuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:50:00 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53196 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2KTVt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:49:59 -0500
MIME-Version: 1.0
In-Reply-To: <20121120211312.57f1b63d@pyramind.ukuu.org.uk>
References: <20121120204238.GA19554@www.outflux.net>
	<20121120211312.57f1b63d@pyramind.ukuu.org.uk>
Date: Tue, 20 Nov 2012 13:49:58 -0800
X-Google-Sender-Auth: g6tbdS32FtZfyHse3AfmSSKFEbY
Message-ID: <CAGXu5jJv58UGwsWM=+ZSnaNpymh6Sm6xSjc0JuT+QoZ9U2++rw@mail.gmail.com>
Subject: Re: [PATCH v2] devtmpfs: mount with noexec and nosuid
From: Kees Cook <keescook@chromium.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ellyjones@chromium.org, Kay Sievers <kay@vrfy.org>,
        Roland Eggner <edvx1@systemanalysen.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 1:13 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 20 Nov 2012 12:42:38 -0800
> Kees Cook <keescook@chromium.org> wrote:
>
>> Since devtmpfs is writable, make the default noexec,nosuid as well. This
>> protects from the case of a privileged process having an arbitrary file
>> write flaw and an argumentless arbitrary execution (i.e. it would lack
>> the ability to run "mount -o remount,exec,suid /dev").
>
> Ok this looks crap on two levels.
>
> 1. Why not just have your userspace mount -o remount the file system this
> way already in early boot. (and if you trojanned boot that early then any
> supposed security gain is already lost)

That's certainly possible, but I am hoping to avoid adding any extra
boot time. The kernel is responsible for this mount, so its flags
should be configurable, resulting in no time penalty anywhere.

> 2. If you want to do this right then you need to work out what you are
> trying to prevent. Your devtmpfs can force file permissions on the
> underlying device nodes by having its own operation handling for chmod.
>
> At that point you can force permissions on anything that you want to
> avoid floating around that filesystem with other rights, while not
> touching it on device or directory nodes where the meaning is different.
>
> In its current form however it appears to be a kernel implementation of
> "mount is too hard".

This change also stops mmap() with PROT_EXEC which a chmod handler
wouldn't be able to do. The noexec and nosuid mount options were
designed for this sort of thing, so I think that's where it should be
handled.

-Kees

-- 
Kees Cook
Chrome OS Security
