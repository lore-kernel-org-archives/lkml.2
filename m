Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0DMAob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 20:44:31 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:45033 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab0DMAoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 20:44:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=P1+w0haZbiGzKK7Y/9b19/i19zXdpJTWN4EpimErN0+YejADDWj2iVKXAy1gTjIClT
         Tdl6IW3pB660jlqvmcn8QGr+MJXbjmr3zrzXgMPjJ9bwTWjx1mRqNSdqXcj3hLrmt+gh
         3s+TIhqoHx91BkT6IAh/1drk2cdX2snU7GBZE=
MIME-Version: 1.0
In-Reply-To: <20100411171856.GA24163@elf.ucw.cz>
References: <20100411072625.GA9926@elf.ucw.cz>
	 <n2g480988181004110742w2ce92bfdr4f0f01216f879fe8@mail.gmail.com>
	 <20100411170117.GA22007@elf.ucw.cz>
	 <p2s480988181004111005kdeb479ddzd3719799f140f4a9@mail.gmail.com>
	 <20100411171856.GA24163@elf.ucw.cz>
Date: Mon, 12 Apr 2010 17:44:29 -0700
X-Google-Sender-Auth: 8a4f443c59d10baf
Message-ID: <g2z480988181004121744r66174301s3254c2df43509e2@mail.gmail.com>
Subject: Re: staging: udlfb -- staging version does not work, external does
From: Bernie Thompson <bernie@plugable.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: roberto@unbit.it, gregkh@suse.de, Cyril Hrubis <metan@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Thanks again for reporting this.

Because neither X nor fbcon uses the char read/write path, this broke
a while ago and it didn't get noticed.  I even highlighted this case
when trying to enumerate the different fbdev access models
(http://plugable.com/2010/01/30/linux-kernel-framebuffer-rendering-apis/
), yet still botched it.

But this is definitely something that should work, as it's a nice way
to drop a test image to hardware when perf doesn't matter.

A patch which restores the functionality is here:
http://git.plugable.com/gitphp/index.php?p=udlfb&a=commitdiff&h=cd5e3761bb6b0132ba72d45b26ff55d22c9d727b

Will get it cleaned up and moving downstream.  Any feedback is welcome.

On fbcon -- sorry its con2fbmap, not fbset, to look for how to assign
a console to a framebuffer. fbcon uses blit and copy operations, so it
doesn't hit the paths you're seeing problems on.

On defio -- it would be great to get experienced help with the
problems we've been having there.  Defio is essential for standard
mmap clients (xf86-video-fbdev, kdrive, or fbi, etc.) when we have a
system memory framebuffer like this -- timer-based updates aren't
practical, as there's just too much data involved here, so the system
load is unacceptable if we're entirely ignorant of what pixels are
changing.  Defio's page-fault-based dirty detection is a nice
compromise.

Testing defio to recreate the problems is easy, just use any of the
standard fbdev clients mentioned above.  Defio is enabled by default
in 2.6.34 as it stands.  Defio can also be enabled/disabled with a
switch in the code.
http://git.plugable.com/gitphp/index.php?p=udlfb&a=commitdiff&h=38e6da578178f439e6613d27fa946c0107394420
to see example of switching it.

We don't have enough eyes on these problems, because most people are
using udlfb with the custom X server written to it, which doesn't hit
any of these issues.

Again, any feedback, suggestions, or udlfb patches (direct to the
staging tree or here) are very welcome.

Thanks,
Bernie
http://plugable.com/
