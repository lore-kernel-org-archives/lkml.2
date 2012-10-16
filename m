Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab2JPX2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 19:28:10 -0400
Received: from mail1.windriver.com ([147.11.146.13]:41147 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab2JPX2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 19:28:08 -0400
Date: Tue, 16 Oct 2012 19:27:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Javier Sanz <jsanza@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.1-rt2
Message-ID: <20121016232746.GA2155@windriver.com>
References: <alpine.LFD.2.02.1210162037380.2811@ionos>
 <CAP=VYLoHhtth2+BwQAsd7uyW8N+rJj6zznP9sNjczTj_0Uqk9w@mail.gmail.com>
 <CAOLSsAyV3XdJvNvFF_6d_oLnApyQVs4UoAJ0rPpABxkaGGxX1A@mail.gmail.com>
 <alpine.LFD.2.02.1210162311490.2811@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1210162311490.2811@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [ANNOUNCE] 3.6.1-rt2] On 16/10/2012 (Tue 23:12) Thomas Gleixner wrote:

> On Tue, 16 Oct 2012, Javier Sanz wrote:
> 
> > Hello,
> > 
> > Testing, and FYI
> > 
> > $uname -a
> > Linux darkstar 3.6.1-rt2 #1 SMP PREEMPT RT Tue Oct 16 22:47:06 CEST 2012
> > i686 i686 i386 GNU/Linux
> > 
> > >>shows all time  ...
> > 
> > [   30.543233] fuse init (API version 7.20)
> > [   33.262077] Crap, ksoftirqd/0 looping forever in softirq
> > [   33.344865] Crap, ksoftirqd/2 looping forever in softirq
> > [   33.401736] Crap, ksoftirqd/0 looping forever in softirq
> > [   33.409743] Crap, ksoftirqd/0 looping forever in softirq
> > [   33.421658] Crap, ksoftirqd/0 looping forever in softirq
> > [   33.428628] Crap, ksoftirqd/0 looping forever in softirq
> > [   33.496468] Crap, ksoftirqd/2 looping forever in softirq
> 
> Grrr. Forgot to remove that printk. Will do in the next spin.

The "Crap" printk removal and another missing subject fix can
be had below.  Oh, and I should mention that I confirmed that the rt2
does now boot without oopsing when CONFIG_CRYPTO_AES_586=y (yay!).

Paul.
--

The following changes since commit e57614eb59de9f729b35e1952c432bf5c861c11f:

  patches-3.6.1-rt2.tar.xz (2012-10-16 15:58:52 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/3.6-rt-patches.git v3.6.1-rt2-fixes

for you to fetch changes up to 884442f268d5250becc5ba22cf127fb55038387f:

  add subject line to power-use-generic-rwsem-on-rt.patch (2012-10-16 18:57:11 -0400)

----------------------------------------------------------------
Paul Gortmaker (2):
      softirq: delete the "Crap" printk triggered by excess RCU calls
      add subject line to power-use-generic-rwsem-on-rt.patch

 power-use-generic-rwsem-on-rt.patch | 1 +
 softirq-split-locks.patch           | 8 +-------
 2 files changed, 2 insertions(+), 7 deletions(-)
