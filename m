Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab1JGEKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 00:10:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33952 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1JGEKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 00:10:20 -0400
Date: Thu, 6 Oct 2011 21:10:16 -0700
From: Cyclonus J <cyclonusj@gmail.com>
To: david@lang.hm
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: intercommunications between Linux kernel modules
Message-ID: <20111007041016.GA18814@gmail.com>
References: <CAOzbF4dvtM5WJ9-LkP4tFROA_gnT-gh-+-3qJLSqtUKOp0SvMg@mail.gmail.com>
 <m28vox36cm.fsf@firstfloor.org>
 <CAOzbF4d+4cZNu_jTPuWcxves2QvidczcfzMzspMKYkGHi-mFxA@mail.gmail.com>
 <alpine.DEB.2.02.1110062056490.5597@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1110062056490.5597@asgard.lang.hm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 09:00:13PM -0700, david@lang.hm wrote:
> On Thu, 6 Oct 2011, Cyclonus J wrote:
> 
> >On Thu, Oct 6, 2011 at 7:04 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >>Cyclonus J <cyclonusj@gmail.com> writes:
> >>
> >>>I am looking for a way to do an IPC-like communications between two
> >>>linux kernel modules, such as mqueue or shared memory. After searching
> >>>for a while, I can't find such information available inside existing
> >>>linux kernel or online.
> >>>
> >>>So, my question is if this is something discussed before here and gets
> >>>rejected or still might be accepted in the mainstream kernel tree?
> >>
> >>All kernel memory is shared in Linux, so the concept doesn't make sense.
> >>
> >>If you want to send messages or communicate inside the kernel there are
> >>lots of different facilities available.
> >
> >Andi,
> >
> >That would be great! Could you point me to some facilities that can do
> >this message passing between kernels?
> 
> what you are missing is that there aren't two different kernels.
> it's one big process. think multi-threaded programming instead of
> inter-process communication. You don't even have well defined
> threads to work with so you can't say "I'm in thread 1 and need to
> communicate with thread 2", you need to think "I'm in this routine
> and I need to set a message in a way that another routine will read
> it", this can be as simple as just setting a variable (although you
> do need to make it the equivalent of 'thread safe' through
> appropriate locking or lock-free protection)

David,

Yes, it is multi-threaded. I have two kernel modules and each of them will
create its own kernel thread just for communication purpose (message passing).

Do you know if there is any message primitves I can use to achieve this inside
kernel?

Thanks,
CJ

> 
> David Lang
