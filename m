Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab1HFSNO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 14:13:14 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:60119 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756519Ab1HFSNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 14:13:14 -0400
Date: Sat, 6 Aug 2011 11:13:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: 3.0.0-git21 -- CC fs/binfmt_misc.o .../asm/uaccess_32.h:211:26:
 error: call to =?UTF-8?B?4oCYY29weV9mcm9tX3VzZXJfb3ZlcmZsb3figJk=?=
 declared with attribute error: copy_from_user() buffer size is not provably
 correct
Message-Id: <20110806111311.663ce667.rdunlap@xenotime.net>
In-Reply-To: <CAKWSe6Az_tFvG+S31pKW4ciEh_Nax5WVS490B1UHyiZ1maSh1w@mail.gmail.com>
References: <CAHFgRy_5FPJn0a9Z6uNdCLUBd5SPac9F_Fhymdc66yeso9=Scw@mail.gmail.com>
	<CAKWSe6Az_tFvG+S31pKW4ciEh_Nax5WVS490B1UHyiZ1maSh1w@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Aug 2011 19:56:00 +0200 Alessandro Suardi wrote:

> On Sat, Aug 6, 2011 at 7:49 PM, Miles Lane <miles.lane@gmail.com> wrote:
> > I am not finding any kernel configuration that enables me to avoid
> > this compile error.  Anyone know what I can do to successfully build
> > this kernel?
> >
> > On Fri, Aug 5, 2011 at 1:15 PM, Miles Lane <miles.lane@gmail.com> wrote:
> >> CC      fs/binfmt_misc.o
> >> In file included from /usr/src/linux-3.0/arch/x86/include/asm/uaccess.h:573:0,
> >>                 from include/linux/uaccess.h:5,
> >>                 from include/linux/highmem.h:7,
> >>                 from include/linux/pagemap.h:10,
> >>                 from fs/binfmt_misc.c:26:
> >> /usr/src/linux-3.0/arch/x86/include/asm/uaccess_32.h: In function
> >> ‘parse_command.part.1’:
> >> /usr/src/linux-3.0/arch/x86/include/asm/uaccess_32.h:211:26: error:
> >> call to ‘copy_from_user_overflow’ declared with attribute error:
> >> copy_from_user() buffer size is not provably correct
> 
> Well, uaccess_32.h has this:
> 
> extern void copy_from_user_overflow(void)
> #ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
>     __compiletime_error("copy_from_user() buffer size is not provably correct")
> #else
>     __compiletime_warning("copy_from_user() buffer size is not provably correct"
> )
> #endif
> 
>  and you have CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y.

Even after you disable this kconfig option, you probably also still
need this patch (unless it's already applied):
http://marc.info/?l=linux-kernel&m=131196593501269&w=2

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
