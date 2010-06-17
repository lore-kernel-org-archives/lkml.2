Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785Ab0FQVXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 17:23:14 -0400
Received: from lirone.symas.net ([64.71.152.235]:56145 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757638Ab0FQVXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 17:23:13 -0400
Message-ID: <4C1A923B.4070701@symas.com>
Date: Thu, 17 Jun 2010 14:23:07 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] tty: Add EXTPROC support for LINEMODE
References: <E1OObIu-0004K2-3K@lirone.symas.net> <20100615202924.24446d28@lxorguk.ukuu.org.uk> <4C17DA85.40803@symas.com> <4C1A7F72.6020907@symas.com> <20100617214915.3478e501@lxorguk.ukuu.org.uk>
In-Reply-To: <20100617214915.3478e501@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>>> For Alpha this value should match OSF if possible.
>>
>> OSF didn't define this flag, nor did it assign that particular bit to any
>> purpose. Is that good enough?
>
> Fine
>
>>> Are you suggesting that this is completely unfixable/unworkable? Would it be
>>> sufficient to use kernel_termios_to_user_termios() ?
>
> I don't see a way to fix it sanely
>
>>>
>> Actually using kernel_termios_to_user_termios_1(). In all supported
>> architectures this structure is basically aligned with but smaller than the
>> userland struct termios.
>
> The relationship isn't quite so simple and it may change in the future,
> so this seems to be a very bad idea. Besides which syscalls are *cheap*
> so simply notifying someone to reread the terminal data they care about
> should be fine. In that sense it seems SVR4 got it right.

OK. I'm fine with only setting a bit in the packet header, and letting the 
application do an ioctl/tcgetattr to discover the actual state. Next question 
is, should this bit still be called TIOCPKT_IOCTL (which BSD uses) or should 
it be called something else, since the behavior is not the same as BSD?

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
