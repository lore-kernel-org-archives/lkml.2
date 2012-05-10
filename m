Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab2EJVPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:15:35 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51402 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab2EJVPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:15:34 -0400
MIME-Version: 1.0
In-Reply-To: <1336684277.29763.12.camel@joe2Laptop>
References: <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
 <20120509070710.GA29981@gmail.com> <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
 <1336611278.728.9.camel@mop> <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
 <1336667984.947.24.camel@mop> <CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
 <1336676986.947.47.camel@mop> <20120510201409.GA6467@thunk.org>
 <1336682226.29763.2.camel@joe2Laptop> <CAPXgP11T7vjBBFaE5jne0hntZ2J-MoVxwJ2C9TNsRzme9DmLuQ@mail.gmail.com>
 <1336682772.29763.6.camel@joe2Laptop> <CA+55aFwJgtVr9ZndEU-yhJW3wi-5Omga51pjun+J213awQwJZA@mail.gmail.com>
 <1336684277.29763.12.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 10 May 2012 23:15:13 +0200
Message-ID: <CAPXgP11QpgM9e741AEYAd13i2OW33=+fH1-riyvFHa9gptoaWg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:11 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2012-05-10 at 13:52 -0700, Linus Torvalds wrote:
>> On Thu, May 10, 2012 at 1:46 PM, Joe Perches <joe@perches.com> wrote:
>> >
>> > That's where I think you're still a bit
>> > uncertain how the _current_ printk system
>> > works.
>>
>> No, you are. Read my answer from two days ago in this thread.
>>
>> KERN_CONT is *not* the same as "". Not now, not ever. If you make it
>> the same, you're broken.
>>
>> The reason is simple: KERN_CONT "<3>" should print out the string
>> "<3>".
>
> I think it's a distinction without a difference for,
> as fas as I know, that's a case that doesn't exist
> in the current kernel.
>
> $ grep -rP --include=*.[ch] "\bpr_cont\s*\(\s*\"<" *
> $ grep -rP --include=*.[ch] "\bprintk\s*\(\s*KERN_CONT\s*\"<" *
> arch/x86/kernel/dumpstack_32.c:                         printk(KERN_CONT "<%02x> ", c);
> arch/x86/kernel/dumpstack_64.c:                         printk(KERN_CONT "<%02x> ", c);
> arch/powerpc/kernel/process.c:                          printk(KERN_CONT "<%08x> ", instr);
> drivers/media/video/tm6000/tm6000-core.c:                       printk(KERN_CONT "<<< ");
> drivers/media/video/cx231xx/cx231xx-core.c:                     printk(KERN_CONT "<<<");

It surely does, and we needed to add KERN_CONT in the past because
stuff got eaten by the prefix parser.
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=40c8cefaaf12734327db7199a56e60058d98e7b6
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=13f541c10b30fc6529200d7f9a0073217709622f

Kay
