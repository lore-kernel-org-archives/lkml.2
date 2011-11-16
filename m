Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1KPHCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:02:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab1KPHCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:02:44 -0500
Date: Wed, 16 Nov 2011 09:03:07 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com, penberg@kernel.org
Subject: Re: [PATCHv2 RFC] virtio-spec: flexible configuration layout
Message-ID: <20111116070306.GB5433@redhat.com>
References: <8739e7uy87.fsf@rustcorp.com.au>
 <20111102233110.GA20289@redhat.com>
 <20111108214021.GA4538@redhat.com>
 <20111109195901.GA28155@redhat.com>
 <1320870287.3730.6.camel@lappy>
 <20111109205208.GA28599@redhat.com>
 <1320872248.3730.11.camel@lappy>
 <87aa83qoao.fsf@rustcorp.com.au>
 <20111113151427.GA16749@redhat.com>
 <87bosdos4y.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bosdos4y.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 10:28:05AM +1030, Rusty Russell wrote:
> On Sun, 13 Nov 2011 17:14:27 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Fri, Nov 11, 2011 at 02:54:31PM +1030, Rusty Russell wrote:
> > > Indeed, I'd like to see two changes to your proposal:
> > > 
> > > (1) It should be all or nothing.  If a driver can find the virtio header
> > >     capability, it should only use the capabilties.  Otherwise, it
> > >     should fall back to legacy.
> > 
> > Okay, but going forward, if we add more capabilities, we probably won't
> > want to require them and fail to load if not there.  That's really why I
> > wanted to make the failover ignore any capability separately - to make
> > this future proof.  I'm not terribly fixated on this, it just seemed a
> > bit more symmetrical to treat all capabilities in the same way. Hmm?
> 
> Sure, a future capbility may not exist.  But once a driver finds that
> virtio header structure in the capability, it should *never* fall back
> to the legacy area.  ie. it can expect that Queue Notify, ISR Status and
> Device Header all exist.
> 
> ie. either use legacy mode, or use capabilities.  Never both.
> 
> > 
> > >     Your draft suggests a mix is possible;
> > >     I prefer a clean failure (ie. one day don't present a BAR 0 *at
> > >     all*, so ancient drivers just fail to load.).
> > 
> > Just to clarify, as written in draft this is possible with the current
> > spec proposal.  So I'm guessing there's some other motivation that you
> > had in mind?
> 
> At the moment you give a hybrid model where both are used.  In five
> years' time, that's going to be particularly ugly.
> > 
> > > (2) There's no huge win in keeping the same layout.  Let's make some
> > >     cleanups.
> > 
> > About this last point - what cleanups do you have in mind?  Just move
> > some registers around?  I guess we could put feature bits near each
> > other, and move device status towards the end to avoid wasting 3
> > bytes.
> 
> > The win seems minimal, but the change does make legacy hypervisor
> > support in guests more cumbersome, as we need to spread coditional code
> > around instead of localizing it in the initialization path.
> 
> But the separation between "legacy" and "modern" will be sharper, making
> it easier to excise the legacy portion later.
> 
> And in five years' time, people implementing virtio will really thank us
> that they can completely ignore the legacy header.

OK, I get it I think.

> > >    There are more users ahead of us then behind us (I
> > >     hope!).
> > 
> > In that case isn't it safe to assume we'll find some uses
> > for the reserved registers?
> 
> How would we tell?  If we use a new capability struct for it, it's
> obvious.  Otherwise, you're going to need to steal more feature bits.

Yes, exactly, if as you suggest, we disable legacy header
when there is a capability - we can use reserved registers
for other stuff.

> Cheers,
> Rusty.
> PS.  Sorry, was off sick for a few days.
