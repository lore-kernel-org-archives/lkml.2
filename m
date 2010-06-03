Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0FCWDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 18:03:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755452Ab0FCWDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 18:03:03 -0400
Date: Thu, 3 Jun 2010 14:58:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: floppy driver assumes INITIAL_JIFFIES == 0
In-Reply-To: <20100603144913.24828629@nehalam>
Message-ID: <alpine.LFD.2.00.1006031455280.8175@i5.linux-foundation.org>
References: <20100603101501.5e5d7148@nehalam> <alpine.LFD.2.00.1006031013060.8175@i5.linux-foundation.org> <20100603120313.10a73b20@nehalam> <alpine.LFD.2.00.1006031204470.8175@i5.linux-foundation.org> <alpine.LFD.2.00.1006031355140.8175@i5.linux-foundation.org>
 <20100603144913.24828629@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Stephen Hemminger wrote:
>
> It seems it isn't related to initial jiffies. 
> Initializing the values (though a good idea), doesn't solve the
> problem. Still failed.  So dazed and confused, went back and reran
> kernel with jiffies=0 showed same problem, just took multiple boots
> to reproduce.

Ahh, ok. That really ends up limiting us. At least having a "it's related 
to jiffy wraparound" was a big clue. 

> So still a race that shows up with KVM (fast floppy?) and manifests
> as floppy_ready or reset_interrupt OOPS.

Yes, it's quite possible that the Linux floppy driver is simply broken by 
any floppy device that basically responds immediately to a command with an 
interrupt. And considering how few people use floppies, I do expect that 
driver to get _worse_ rather than better in the future.

Don't get me wrong - I'm sure it could be fixed. I'm just not sure that 
anybody is going to spend the effort.

I'd love to be proven wrong. Anybody?

		Linus
