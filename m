Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab2LLAle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:41:34 -0500
Received: from smtprelay.restena.lu ([158.64.1.62]:38145 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2LLAld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:41:33 -0500
Date: Wed, 12 Dec 2012 01:41:09 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jacek Poplawski <jacekpoplawski@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "attempt to access beyond end of device" on DVD
Message-ID: <20121212014109.38e18eeb@neptune.home>
In-Reply-To: <CAGDELX7f-Ee-V_M8kbDONRFCTBbZM2H_Q17Bk_12r4xw85Wq4Q@mail.gmail.com>
References: <CAGDELX7f-Ee-V_M8kbDONRFCTBbZM2H_Q17Bk_12r4xw85Wq4Q@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, 10 December 2012 Jacek Poplawski <jacekpoplawski@gmail.com> wrote:
> few years ago I noticed annoying bug on Linux, when I was copying
> photos from old DVDs I realized that not all files were copied
> correctly, there were errors on last files on DVD, you could say "well
> that happens, DVD are faulty", but that's not the real issue
> 
> when the problem appears it happens on each DVD I am trying to copy,
> last files on each disk have errors....
> 
> ...until I reboot Linux, then there are no errors at all and full DVD
> is copied correctly.
> 
> Now I needed some files from DVDs and I realized the problem still
> exists. After at least three years. I verified that reboot helps and I
> also noticed the problem doesn't exist on Windows 7.
> 
> And looks like I wasn't only one who found this:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/404472
> 
> Problem was reported in 2009 on 2.6.28 and closed in 2012. But I
> noticed it in last days.
> 
> my system is:
> 
> Linux version 3.6.8-1-ARCH (tobias@T-POWA-LX) (gcc version 4.7.2 (GCC)
> ) #1 SMP PREEMPT Mon Nov 26 22:10:40 CET 2012
> 
> dmesg:
> 
> [ 4017.384169] attempt to access beyond end of device
> [ 4017.384171] sr0: rw=0, want=8511124, limit=8433216
> [ 4017.384174] attempt to access beyond end of device
> [ 4017.384175] sr0: rw=0, want=8510876, limit=8433216
> 
> I suspect that people just stopped using CDs and DVDs and that's why
> nobody was looking on this problem, or maybe the first though was
> always "that DVD is broken, trash it".
> 
> Is there more information I could give you about this issue? Or could
> you point me to any ways I could debug it? It's fully reproducible on
> my system.

Hm, could it be related to some kind of read-ahead? I vaguely remember
seeing mails about read-ahead and/or end-of-device. Could this be somehow
related?

See:
- https://lkml.org/lkml/2012/12/3/497
- https://lkml.org/lkml/2012/12/3/510

This applies to 3.7-rc but according to the thread it might still
have some interesting things that could be related to what you are seeing.

When it happens, does ejecting and re-inserting the CDs/DVDs also fix the
problem or is a full reboot mandatory?

Bruno
