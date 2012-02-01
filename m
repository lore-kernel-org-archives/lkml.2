Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2BAHsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:48:51 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56524 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab2BAHsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:48:50 -0500
Date: Wed, 01 Feb 2012 02:48:43 -0500 (EST)
Message-Id: <20120201.024843.318636456202840126.davem@davemloft.net>
To: geunsik.lim@gmail.com
Cc: isdn@linux-pingi.de, lucas.demarchi@profusion.mobi, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Keep kernel coding style rule of hfs-s+/sp source
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGFP0LKU0uDPQzhCy8qmThXQ9f9ofSnQrbr2dO83i+usc85_FQ@mail.gmail.com>
References: <1328079593-19197-1-git-send-email-geunsik.lim@gmail.com>
	<20120201.020602.131240058939599710.davem@davemloft.net>
	<CAGFP0LKU0uDPQzhCy8qmThXQ9f9ofSnQrbr2dO83i+usc85_FQ@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 Jan 2012 23:48:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@gmail.com>
Date: Wed, 1 Feb 2012 16:45:09 +0900

> On Wed, Feb 1, 2012 at 4:06 PM, David Miller <davem@davemloft.net> wrote:
> 
>> From: Geunsik Lim <geunsik.lim@gmail.com>
>> Date: Wed,  1 Feb 2012 15:59:53 +0900
>>
>> > Modified for kernel coding style rule of hfs-s+/sp device driver .
>> > . reference: ./Documentation/CodingStyle
>> >
>> > ex)
>> > 60 Don't put multiple statements on a single line unless you have
>> > 61 something to hide:
>> > 62
>> > 63         if (condition) do_this;
>> > 64           do_something_everytime;
>> >
>> > Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
>>
>> This was probably there to eliminate compiler warnings or avoid the
>>
> Thank you for your opinion.
> It's strange. I did not meet compiler warnings you replied.
> What is the version of GCC that You tried to compile Linux kernel source
> in your experience?

I'm saying the code was likely written this way "because" of that
reason, I didn't say I saw such a warning.  Where did I say I saw
the warning in question?

I stated a very likely reason why the original code was written the
way that it was.

>> code being eliminated completely, because the result of the register
>> read is unused.
>>
> Are you mean that the result of the register read is used if we append
> "if statement" of c language?

I was saying that without some kind of use of the interface's return
value, without some other control such as a volatile asm statement or
a reference to a volatile memory location, the compiler might legally
be able to remove the I/O register read completely.

You need to make sure that the assembler code does not change due to
your changes, and in particular these I/O register read calls do not
get eliminated.
