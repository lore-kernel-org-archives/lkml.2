Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab2B0RMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:12:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61552 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab2B0RMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:12:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.14.136.209 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F4BB983.8020608@suse.cz>
Date: Mon, 27 Feb 2012 18:12:35 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>,
        gigaset307x-common@lists.sourceforge.net
Subject: Re: "whitespace coding style cleanup" broke coding style
References: <4F4B45F6.4090706@suse.cz> <1330361549.9942.7.camel@joe2Laptop>
In-Reply-To: <1330361549.9942.7.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 05:52 PM, Joe Perches wrote:
> On Mon, 2012-02-27 at 09:59 +0100, Jiri Slaby wrote:
>> commit 475be4d85a274d0961593db41cf85689db1d583c
>> Author: Joe Perches<joe@perches.com>
>> Date:   Sun Feb 19 19:52:38 2012 -0800
>>
>>       isdn: whitespace coding style cleanup
>>
>>       isdn source code uses a not-current coding style.
>> ...
>>       Done with emacs and some scripts and some typing.
>> ...
>> --- a/drivers/isdn/gigaset/interface.c
>> +++ b/drivers/isdn/gigaset/interface.c
>> ...
>> @@ -680,9 +680,9 @@ void gigaset_if_initdriver(struct gigaset_driver
>> *drv, const
>>    char *procname,
>>                   goto enomem;
>>
>>           tty->magic =            TTY_DRIVER_MAGIC,
>> -       tty->type =             TTY_DRIVER_TYPE_SERIAL,
>> -       tty->subtype =          SERIAL_TYPE_NORMAL,
>> -       tty->flags =            TTY_DRIVER_REAL_RAW |
>> TTY_DRIVER_DYNAMIC_DEV;
>> +               tty->type =             TTY_DRIVER_TYPE_SERIAL,
>> +               tty->subtype =          SERIAL_TYPE_NORMAL,
>> +               tty->flags =            TTY_DRIVER_REAL_RAW |
>> TTY_DRIVER_DYNAMIC_DEV;
>>
>> Hmm, please, fix your scripts or emacs!
>
> Hi Jiri.
>
> I'm not fixing emacs.
>
> Notice that the code improperly uses commas and
> not semicolons for line terminations like the
> lines immediately above and below it.

Oh, and you see that you made it actually _worse_? The patch should not 
touch the code at all. It is obviously totally broken. In a separate 
patch you might do s@,@;@ instead.

> btw:  Your copy/paste lost the tab indents.

Yes, but as I did not expect anybody to apply it, I see no problem in that.

> The emacs pass was not perfect, nor was it
> intended to be perfect.  There are _way_
> too many coding style defects in isdn for
> that.

Hmm, but did not we conclude some time ago that we will not touch code 
just to perform a whitespace cleanup?

> It was a first pass and an overall improvement.

I hope no other passes are going to happen there or anywhere in TTY 
drivers. I really do not want to solve zillion collisions in my ~100 
local patches due to whitespace changes, sorry.

That was exactly the reason why not to cleanup the files just to be 
checkpatch-proof.

> "It's quite a bit more like what passes
> for the current kernel coding style though."

Yes, but it does not pass our brain, does it? One should throw 
"checkpatch --file" or alike away, finally.

thanks,
-- 
js
suse labs
