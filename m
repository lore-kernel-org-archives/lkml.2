Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2BTX41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 18:56:27 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:62800 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab2BTX40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 18:56:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of fweisbec@gmail.com designates 10.229.137.18 as permitted sender) smtp.mail=fweisbec@gmail.com; dkim=pass header.i=fweisbec@gmail.com
Date: Tue, 21 Feb 2012 00:56:22 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org
Subject: Re: NoHZ and CPU isolation patches
Message-ID: <20120220235619.GH5752@somewhere.redhat.com>
References: <4F39DB3D.10805@qualcomm.com>
 <CAOtvUMdta6RNvaHNRDbsUTA5tTEK01bwW_wpZkZOeNNL+podTA@mail.gmail.com>
 <4F3AA481.6040707@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3AA481.6040707@qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 10:14:25AM -0800, Max Krasnyansky wrote:
> On 02/14/2012 01:44 AM, Gilad Ben-Yossef wrote:
> >Hi Max,
> >
> >Any specific reason not to CC the LKML list? I know it is sometime
> >noisy and I understand
> >you are not subscribed, but it is the Right Thing (tm) to do...
> 
> No reason really. I was just going to keep it short and basically just ask
> for CCs on future discussions :).
> Looks like this might turn into a useful discussion. Added to the CC.
> 
> >On Tue, Feb 14, 2012 at 5:55 AM, Max Krasnyansky<maxk@qualcomm.com>  wrote:
> >>Gilad, Frederic,
> >>
> >>At the time a lot of people
> >>were totally opposed to that
> >>from the recent threads it looks like things have changed quite a bit.
> >
> >I think people like the idea of CPU isolation, there is just the
> >question of what CPU
> >isolation means :-)
> >
> >At least my personal approach is that if a task is running on an
> >isolated CPU has caused
> >the kernel to need to do work on that CPU, that is fair game.
> Yep. My definition is the same. ie If a task wants to avoid interference from the
> kernel it better not use any syscalls() or at least not the syscalls that trigger
> IO, mem allocations, etc.

Right but we want a solution that works for everyone: those who need to issue syscalls
from time to time (IO or whatever), those who don't issue syscalls at all, etc...

So unplugging the CPU might work for pure isolation (no syscalls, no irq, no exception)
but there may be lighter kind of isolation, with rare syscalls, exceptions or irqs, etc...

If the task is disturbed for useless work, then lets fix that. This may be useful for
isolation and even much more globally.

Note that unplugging the CPU also prevents the task from any return to the kernel. This
include the do_exit() path. And I believe we don't want to deal with a CPU that is
not in the online mask when we enter such a complicated path.
