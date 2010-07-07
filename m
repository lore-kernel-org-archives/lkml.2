Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0GGOdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 10:33:42 -0400
Received: from anguilla.debian.or.at ([86.59.21.37]:32799 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab0GGOdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 10:33:40 -0400
Date: Wed, 7 Jul 2010 16:33:39 +0200
From: Peter Palfrader <peter@palfrader.org>
To: Glauber Costa <glommer@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zachary Amsden <zamsden@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization
	point for pvclock
Message-ID: <20100707143338.GK15122@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	Glauber Costa <glommer@redhat.com>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Zachary Amsden <zamsden@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
References: <20100701175144.GA2116@kroah.com> <20100701173218.125822294@clark.site> <20100707124731.GJ15122@anguilla.noreply.org> <20100707135140.GI2707@mothafucka.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100707135140.GI2707@mothafucka.localdomain>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Jul 2010, Glauber Costa wrote:

> > 2.6.32.16 fails to boot on my KVM domains using qemu-kvm 0.11.1.
> > 
> > Bisecting between 2.6.32.14 which worked and .16 turned up this commit
> > as the first culprit[0].
> > 
> > The host is still running 2.6.32.14 and has 8 cores on 2 CPUs.  The
> > single-cpu KVM domain hangs just after printing 'Write protecting the
> > kernel read-only data: 9492k'[1].   On a successful boot this line would
> > usually be followed by 'INIT: version 2.86 booting'.
> > 
> > A 2.6.32.16 with this patch reverted boots fine.
> > 
> > If there's any info you need please just ask.

> if you boot with another clocksource, and then switch to kvmclock with the machine already
> running, do you see anything strange or suspicious?

Booting with various clocksource=xxx kernel parameters does not change
the behaviour at all, i.e. the boot still hangs.

Cheers,
Peter
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
