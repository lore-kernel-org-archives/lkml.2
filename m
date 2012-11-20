Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2KTXxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:53:32 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64815 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2KTXxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:53:31 -0500
MIME-Version: 1.0
In-Reply-To: <20121120235353.3092c8d2@pyramind.ukuu.org.uk>
References: <20121120204238.GA19554@www.outflux.net>
	<20121120211312.57f1b63d@pyramind.ukuu.org.uk>
	<CAGXu5jJv58UGwsWM=+ZSnaNpymh6Sm6xSjc0JuT+QoZ9U2++rw@mail.gmail.com>
	<20121120235353.3092c8d2@pyramind.ukuu.org.uk>
Date: Tue, 20 Nov 2012 15:53:30 -0800
X-Google-Sender-Auth: txt2x8lv9j-G5miWhKhMVm65noY
Message-ID: <CAGXu5jKS1OQPxiBPewtfOTJqntOMFnw4n08-zP7=87nD+z6eSg@mail.gmail.com>
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

On Tue, Nov 20, 2012 at 3:53 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > 1. Why not just have your userspace mount -o remount the file system this
>> > way already in early boot. (and if you trojanned boot that early then any
>> > supposed security gain is already lost)
>>
>> That's certainly possible, but I am hoping to avoid adding any extra
>> boot time. The kernel is responsible for this mount, so its flags
>> should be configurable, resulting in no time penalty anywhere.
>
> You just broke my bullshitometer
>
> It's a single syscall from your init binary, its microseconds.

Whatever, I still see it as a needless inefficiency.

>> > 2. If you want to do this right then you need to work out what you are
>> > trying to prevent. Your devtmpfs can force file permissions on the
>> > underlying device nodes by having its own operation handling for chmod.
>> >
>> > At that point you can force permissions on anything that you want to
>> > avoid floating around that filesystem with other rights, while not
>> > touching it on device or directory nodes where the meaning is different.
>> >
>> > In its current form however it appears to be a kernel implementation of
>> > "mount is too hard".
>>
>> This change also stops mmap() with PROT_EXEC which a chmod handler
>> wouldn't be able to do.
>
> You don't want to stop mmap with PROT_EXEC on /dev/mem as that breaks a
> load of stuff, you want to stop people adding stuff to that file system
> and executing it.

Well, initially the latter, yes. But as it turns out, setting noexec
also stops PROT_EXEC on /dev/mem. Since the systems I'm building for
all use KMS, there's no need to execute regions of /dev/mem (e.g. VESA
BIOS init, etc).

-Kees

-- 
Kees Cook
Chrome OS Security
