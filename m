Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0GGSQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 14:16:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab0GGSQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 14:16:25 -0400
Date: Wed, 7 Jul 2010 15:15:11 -0300
From: Glauber Costa <glommer@redhat.com>
To: Peter Palfrader <peter@palfrader.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zachary Amsden <zamsden@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization
 point for pvclock
Message-ID: <20100707181511.GL2707@mothafucka.localdomain>
References: <20100701175144.GA2116@kroah.com>
 <20100701173218.125822294@clark.site>
 <20100707124731.GJ15122@anguilla.noreply.org>
 <20100707135140.GI2707@mothafucka.localdomain>
 <20100707143338.GK15122@anguilla.noreply.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707143338.GK15122@anguilla.noreply.org>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 04:33:39PM +0200, Peter Palfrader wrote:
> On Wed, 07 Jul 2010, Glauber Costa wrote:
> 
> > > 2.6.32.16 fails to boot on my KVM domains using qemu-kvm 0.11.1.
> > > 
> > > Bisecting between 2.6.32.14 which worked and .16 turned up this commit
> > > as the first culprit[0].
> > > 
> > > The host is still running 2.6.32.14 and has 8 cores on 2 CPUs.  The
> > > single-cpu KVM domain hangs just after printing 'Write protecting the
> > > kernel read-only data: 9492k'[1].   On a successful boot this line would
> > > usually be followed by 'INIT: version 2.86 booting'.
> > > 
> > > A 2.6.32.16 with this patch reverted boots fine.
> > > 
> > > If there's any info you need please just ask.
> 
> > if you boot with another clocksource, and then switch to kvmclock with the machine already
> > running, do you see anything strange or suspicious?
> 
> Booting with various clocksource=xxx kernel parameters does not change
> the behaviour at all, i.e. the boot still hangs.
wow, it is really weird then.

that patch shouldn't affect anything outside the pvclock realm.

