Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1GYKac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:30:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37590 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab1GYKa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:30:26 -0400
Date: Mon, 25 Jul 2011 12:29:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Alexander Graf <agraf@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725102935.GK28787@elte.hu>
References: <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <20110725085426.GA28787@elte.hu>
 <C80CB058-38B3-4EA4-996F-4585F521415C@suse.de>
 <20110725094136.GE28787@elte.hu>
 <4E2D3BF1.7070406@redhat.com>
 <20110725100311.GH28787@elte.hu>
 <4E2D42D6.3010909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2D42D6.3010909@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 07/25/2011 01:03 PM, Ingo Molnar wrote:
> >>  >  Then look at the actual drivers and interfaces within tools/kvm/.
> >>  >  It's using the same symbols and conventions for 'guest' and
> >>  >  'host' side.
> >>  >
> >>  >  Check out tools/kvm/hw/i8042.c and match it up with
> >>  >  include/linux/serio.h and drivers/input/serio/i8042.c - you can
> >>  >  literally walk from one side to the other and understand how
> >>  >  guest and host are tightly related not just functionality but
> >>  >  also implementation wise.
> >>  >
> >>  >  This is how Qemu should be doing it as well btw., to ease the
> >>  >  debugging of host/guest interaction bugs and to ease development.
> >>
> >>  No. That ties the guest and host interfaces together. [...]
> >
> > Why would it tie the interfaces together? For a guest and host 
> > driver to be written in the same familiar conventions is useful 
> > for debugging and development easier but does not prevent both of 
> > those pieces to implement a precise interface. (Especially since 
> > in the i8042 case the host driver is used with real hardware as 
> > well.)
> 
> The driver is under no requirement to use all of the functionality 
> of the device.  On the other hand, the device emulation has to be 
> complete, or it risks not working with some past or future version 
> of the driver, or with another OS (if you support that).

Sure, and nothing in tools/kvm/hw/i8042.c contradicts that and my 
points still remain.

You can have clean, harmonic code *and* have it work to spec, agreed?

Thanks,

	Ingo
