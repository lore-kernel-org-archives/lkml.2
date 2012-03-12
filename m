Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2CLK0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:26:08 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab2CLK0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:26:06 -0400
Message-ID: <4F5DCF39.8080308@nod.at>
Date: Mon, 12 Mar 2012 11:26:01 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        gregkh@linuxfoundation.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
References: <4F5BD51B.7030907@nod.at> <4F5BDB09.3020407@suse.cz> <4F5BE1E6.9000201@nod.at> <4F5C861F.2000507@nod.at>
In-Reply-To: <4F5C861F.2000507@nod.at>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.03.2012 12:01, Richard Weinberger wrote:
> Am 11.03.2012 00:21, schrieb Richard Weinberger:
>> Am 10.03.2012 23:51, schrieb Jiri Slaby:
>>> On 03/10/2012 11:26 PM, Richard Weinberger wrote:
>>>> Hi!
>>>
>>>> While moving UML's console driver to tty_port some strange things
>>>> happened. So, I have a few questions. :-)
>>>
>>>> The original driver did not implement tty_operations->hangup(). If
>>>> I implement it and call tty_port_hangup(), as Alan suggested, the
>>>> login fails on all TTYs except tty0. It fails because the opened
>>>> TTY returns EIO upon read()/write() after /bin/login called
>>>> vhangup().
>>>
>>>> The call chain is: vhangup() ->  tty_vhangup_self() ->  tty_vhangup()
>>>> ->  __tty_hangup()
>>>
>>>> Within __tty_hangup() something happens that I don't fully
>>>> understand:
>>>
>>>> if (cons_filp) { if (tty->ops->close) for (n = 0; n<  closecount;
>>>> n++) tty->ops->close(tty, cons_filp); } else if (tty->ops->hangup)
>>>> (tty->ops->hangup)(tty);
>>>
>>>> Login on tty0 works because cons_filp is not NULL and
>>>> tty->ops->close() is called. On the other hand login fails on every
>>>> other TTY because cons_filp remains NULL and the TTY hangs up.
>>>
>>>> Is there something missing in my hangup function?
>>>
>>>> If I omit tty_operations->hangup() and leave it, like the old
>>>> driver, NULL non-tty0 TTYs cannot be opened. (getty terminates
>>>> immediately because it cannot open any TTY.) open() retuns -EIO
>>>> because the TTY_CLOSING is set in tty->flags.
>>>
>>>> How can this be?
>>>
>>> Hmm, it looks like some process is sitting on a TTY which was hung.
>>> And the system offers this hung TTY to others on further opens. Could
>>> you check that there is no process with open TTY after the vhangup?
>>>
>>
>> "lsof | grep tty" does not show anything else than tty0. :-\
>>
>
> BTW: When I start the kernel with /bin/sh as init, opening and writing to any TTY works fine.
> It looks like Fedora 16's userspace does something that makes the TTYs unhappy.
>
> Thanks,
> //richard

Another question, what is the purpose of tty_port->console?
It seems to have no user.

Is tty_port really the right thing for a console driver like in the UML 
case?

Thanks,
//richard
