Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab0GHFbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 01:31:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab0GHFbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 01:31:21 -0400
Date: Thu, 8 Jul 2010 08:31:00 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Peter Palfrader <peter@palfrader.org>, Glauber Costa <glommer@redhat.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Zachary Amsden <zamsden@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization
 point for pvclock
Message-ID: <20100708053100.GJ4689@redhat.com>
References: <20100701175144.GA2116@kroah.com>
 <20100701173218.125822294@clark.site>
 <20100707124731.GJ15122@anguilla.noreply.org>
 <20100707135140.GI2707@mothafucka.localdomain>
 <20100707143338.GK15122@anguilla.noreply.org>
 <20100707151540.GH4689@redhat.com>
 <20100707200536.GL15122@anguilla.noreply.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707200536.GL15122@anguilla.noreply.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 10:05:36PM +0200, Peter Palfrader wrote:
> On Wed, 07 Jul 2010, Gleb Natapov wrote:
> 
> > On Wed, Jul 07, 2010 at 04:33:39PM +0200, Peter Palfrader wrote:
> > > On Wed, 07 Jul 2010, Glauber Costa wrote:
> > > 
> > > > > 2.6.32.16 fails to boot on my KVM domains using qemu-kvm 0.11.1.
> > > > > 
> > > > > Bisecting between 2.6.32.14 which worked and .16 turned up this commit
> > > > > as the first culprit[0].
> > > > > 
> > > > > The host is still running 2.6.32.14 and has 8 cores on 2 CPUs.  The
> > > > > single-cpu KVM domain hangs just after printing 'Write protecting the
> > > > > kernel read-only data: 9492k'[1].   On a successful boot this line would
> > > > > usually be followed by 'INIT: version 2.86 booting'.
> > > > > 
> > > > > A 2.6.32.16 with this patch reverted boots fine.
> > > > > 
> > > > > If there's any info you need please just ask.
> > > 
> > > > if you boot with another clocksource, and then switch to kvmclock with the machine already
> > > > running, do you see anything strange or suspicious?
> > > 
> > > Booting with various clocksource=xxx kernel parameters does not change
> > > the behaviour at all, i.e. the boot still hangs.
> > > 
> > And what if you provide -cpu qemu64,-kvmclock to qemu command line?
> 
> Adding that to the glob of options that already were there from libvirt
> didn't disable it, but using an LD_PRELOAD wrapper[1] to that purpose on
> the host when starting kvm did help.
> 
Strange. -kvmclock should have had the same effect. What qemu is it?
What is your command line?

> Now, with kvmclock no longer being available at all the system picks tsc
> and indeed boots 2.6.32.16 successfully.
> 
> - Peter
> 1. http://people.debian.org/~paravoid/kvm-noclock-3.tar.gz
> -- 
>                            |  .''`.  ** Debian GNU/Linux **
>       Peter Palfrader      | : :' :      The  universal
>  http://www.palfrader.org/ | `. `'      Operating System
>                            |   `-    http://www.debian.org/

--
			Gleb.
