Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab0JJUSH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 16:18:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40189 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0JJUSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 16:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XXZMDfH4RtHlychLiiNHqDzxOTFfY4a+SHje1Oq7cONj6j37z8UFO4gaLqpr5Rl/FU
         Zuj40iIBksjmmNrC5Ngwg1wWKoc6lRC5GvjM217oA7Fpf7bNziA+C9HfHxjMWj51u6Ew
         sR/IDTiofSrqGhoJ38idHRqaVyzmrVDP2XeWQ=
MIME-Version: 1.0
In-Reply-To: <20101010144952.GF19804@ZenIV.linux.org.uk>
References: <20101007174948.GT19804@ZenIV.linux.org.uk>
	<AANLkTin4886D+-yo=zrf2Yj2R5NM9qdRkc3M9cG2rN_F@mail.gmail.com>
	<20101010144952.GF19804@ZenIV.linux.org.uk>
Date: Sun, 10 Oct 2010 22:18:03 +0200
X-Google-Sender-Auth: 9RH-YcBNJ1s949WIWeapC_MmEOI
Message-ID: <AANLkTinuA3AzMoJ82pvCuhmo59DZxL2F1j3xhXUkjj7z@mail.gmail.com>
Subject: Re: aranym bug, manifests as "ida_remove called for id=13" on recent kernels
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 16:49, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Oct 10, 2010 at 11:47:20AM +0200, Geert Uytterhoeven wrote:
>> > The cheapest way to reproduce is to boot with init=/bin/sh, then
>> > mount /proc and have stat("/proc/2/exe", &st) called; if stat()
>> > returns 0, we are fscked. ??The critical part is between return
>> > from proc_exe_link() (we'll leave it via if (!mm) return -ENOENT;)
>> > to return from __do_follow_link() -> do_follow_link() -> link_path_walk().
>>
>> I booted 2.6.36-rc7-atari-00360-g0dd2e6a (my current private test kernel) with
>> init=/bin/sh, mounted /proc, and tried
>>
>>     for i in $(seq 1000); do stat /proc/2/exe; done
>>
>> a few times, but I didn't see any ida_remove messages.
>> It cannot read the /proc/2/exe symlink, though.
>>
>> This is on aranym-0.9.9-1 from Ubuntu/amd64.
>
> stat -L /proc/2/exec, otherwise you'll hit lstat() instead of stat().
> And FWIW 0.9.10-1 squeeze/amd64 also triggers here...

Still, just "stat: cannot stat `proc/2/exe': No such file or directory" here...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
