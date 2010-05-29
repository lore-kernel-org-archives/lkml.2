Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0E2RT3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 13:19:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54630 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab0E2RT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 13:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jHxw1bpzRSim+/AnBrV8BgtjEfPbRzD3BD4tjTJzezuU8AnhoaWu55A3SHDh8dM522
         66bE+NEczMA7a/Qky+6DqjESbZYSVLdadM8v48yenvZpH8leAGODG/kflBwxeFQvZeGW
         LR6/n1q4TNvphms3E6gOn5t86EILBRe1ldJdg=
MIME-Version: 1.0
In-Reply-To: <20100529111951.GB31550@merkur.ravnborg.org>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
	<20100527154916.GA5585@infradead.org>
	<20100527184653.GA11830@merkur.ravnborg.org>
	<AANLkTikkZGdf8-WnHQu4dY6WiXH7d0Raak0j-82hrvAA@mail.gmail.com>
	<20100529111951.GB31550@merkur.ravnborg.org>
Date: Sat, 29 May 2010 22:49:25 +0530
Message-ID: <AANLkTiku0kPykE30DIQvOD9gauEGZbyeDWXGkLb53sgJ@mail.gmail.com>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam and Américo,

On Sat, May 29, 2010 at 4:49 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Fri, May 28, 2010 at 03:37:00AM +0530, Jaswinder Singh Rajput wrote:
>> Hello Sam,
>>
>> On Fri, May 28, 2010 at 12:16 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> > On Thu, May 27, 2010 at 11:49:16AM -0400, Christoph Hellwig wrote:
>> >> On Thu, May 27, 2010 at 05:37:36AM +0530, Jaswinder Singh Rajput wrote:
>> >> > Hello,
>> >> >
>> >> > I am trying to build 32 bit kernel image on 64-bit machine but after
>> >> > 'make menuconfig' it automatically switches 32-bit to 64-bit.
>> >> >
>> >> > Is this a BUG or did intentionally.
>> >>
>> >> I think it's intentional, but I'm really annoyed by this behaviour.
>> >
>> > The request when we did the merge of 32 and 64 bit was that we
>> > should continue to build 64bit kernels on 64 bit machines.
>> > And likewise for 32bit.
>> > Because this was what the users where used to.
>> >
>> > We could simplify metters by defining new rules.
>> > As you suggest that uname on an intel box always resulted in ARCH=x86.
>> > But then people would complain why a 32 bit kernel is default when
>> > the box is 64 bit.
>> >
>> > Something like this:
>> > [The escape chars align nicely in the patched Makefile]
>> >
>> >        Sam
>> >
>> > diff --git a/Makefile b/Makefile
>> > index ebc8225..e7f97a5 100644
>> > --- a/Makefile
>> > +++ b/Makefile
>> > @@ -161,10 +161,11 @@ export srctree objtree VPATH
>> >  # then ARCH is assigned, getting whatever value it gets normally, and
>> >  # SUBARCH is subsequently ignored.
>> >
>> > -SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>> > -                                 -e s/arm.*/arm/ -e s/sa110/arm/ \
>> > +SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/        \
>> > +                                 -e s/sun4u/sparc64/                    \
>> > +                                 -e s/arm.*/arm/ -e s/sa110/arm/        \
>> >                                  -e s/s390x/s390/ -e s/parisc64/parisc/ \
>> > -                                 -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
>> > +                                 -e s/ppc.*/powerpc/ -e s/mips.*/mips/  \
>> >                                  -e s/sh[234].*/sh/ )
>> >
>> >  # Cross compiling and selecting different set of gcc/bin-utils
>> >
>> >
>>
>> Thanks, this patch fixes the issue. Now 'make menuconfig' is following .config.
>
> If you think this is the right way to do things you can take it up
> with the x86 maintainers.
>
> Although the patch touches only a generic file this is x86 specific.
>

Américo Wang, Do you mind handle this kconfig patch.

Thanks,
--
Jaswinder Singh.
