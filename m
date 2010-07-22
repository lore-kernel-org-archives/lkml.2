Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0GVTLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:11:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270Ab0GVTLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:11:00 -0400
MIME-Version: 1.0
In-Reply-To: <20100721195547.GA3448@amt.cnet>
References: <20100609183449.110905403@vyatta.com> <alpine.LFD.2.00.1006091144120.4506@i5.linux-foundation.org> 
	<20100609115403.75ebb6cb@nehalam> <alpine.LFD.2.00.1006091203190.4506@i5.linux-foundation.org> 
	<20100611103223.799d3ce0@nehalam> <20100721195547.GA3448@amt.cnet>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Jul 2010 12:09:44 -0700
Message-ID: <AANLkTinffggNzVWn0sZ78wF3nwbEehoEuiVdxUP8MoE4@mail.gmail.com>
Subject: Re: [RFC] floppy: use single threaded workqueue
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 12:55 PM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> Can confirm this fixes the following oops seen under KVM guests.
>
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000035

Hmm. That does make me want to merge it early, but at the same time I
suspect it has gotten almost no testing on real hardware. So despite
looking "obvious" and fixing one bug, I'm a bit nervous and I suspect
that the prudent thing to do is still to take it early in the 2.3.36
merge window, and just mark it for stable.

Is anybody a big floppy user (on _real_ hardware, preferably with more
than a couple machines) and could test it? I do feel kind of stupid
for not taking it, but I don't have the hardware or the interest in
really installing any in my current machines, and even if it looks
fine and fixes some issue, I just don't feel safe enough without some
more confirmation... As far as I know, the floppy oops thing has
_only_ been seen on KVM (likely due to timing that just doesn't happen
on real hardware), and while the KVM floppy emulation is probably
fairly good, it also clearly isn't equivalent to hardware.

                               Linus
