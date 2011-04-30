Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab1D3QuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 12:50:25 -0400
Received: from 1wt.eu ([62.212.114.60]:35898 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab1D3QuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 12:50:24 -0400
Date: Sat, 30 Apr 2011 18:49:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg KH <greg@kroah.com>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20110430164958.GE10529@1wt.eu>
References: <20110428082625.GA23293@pcnci.linuxbox.cz> <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz> <20110430093605.GA10529@1wt.eu> <20110430120205.GA2459@nik-comp.lan> <20110430155707.GA22021@kroah.com> <20110430090805.354484ad.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430090805.354484ad.rdunlap@xenotime.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 09:08:05AM -0700, Randy Dunlap wrote:
> On Sat, 30 Apr 2011 08:57:07 -0700 Greg KH wrote:
> 
> > On Sat, Apr 30, 2011 at 02:02:05PM +0200, Nikola Ciprich wrote:
> > > > There was a kernel parameter in the past that was used to make jiffies wrap
> > > > a few minutes after boot, maybe we should revive it to try to reproduce
> > > > without waiting 7 new months :-/
> > > hmm, I've googled this up, and it seems to have been 2.5.x patch, so it will
> > > certainly need some porting..
> > > I'll try to have a look on it tonight and report...
> > 
> > I don't think any patch is needed, I thought we did that by default now,
> > but I can't seem to find the code where it happens...
> > 
> > odd.
> 
> linux/jiffies.h:
> 
> /*
>  * Have the 32 bit jiffies value wrap 5 minutes after boot
>  * so jiffies wrap bugs show up earlier.
>  */
> #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> 
> 
> and kernel/timer.c:
> 
> u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;

Thanks Randy.

So that would mean that wrapping jiffies should be unrelated to the
reported panics. Let's wait for Hidetoshi-san's analysis then.

Regards,
Willy

