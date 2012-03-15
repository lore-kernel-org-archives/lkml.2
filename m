Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab2COKjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:39:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab2COKjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:39:33 -0400
Date: Thu, 15 Mar 2012 12:39:23 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Eric Northup <digitaleric@google.com>
Cc: Avi Kivity <avi@redhat.com>, Wen Congyang <wency@cn.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120315103923.GL2304@redhat.com>
References: <4F60726E.3090807@cn.fujitsu.com>
 <4F607325.6050607@redhat.com>
 <20120314104608.GU2304@redhat.com>
 <4F607789.4010109@redhat.com>
 <4F607CE4.2060809@cn.fujitsu.com>
 <4F609822.7050502@redhat.com>
 <20120314131415.GB2304@redhat.com>
 <4F609A15.5020902@redhat.com>
 <20120314132552.GC2304@redhat.com>
 <CAG7+5M0gEpoJ_jnC8_4Ae-xe2rr7+CJLZh3JjAhh=p=-2bEAcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG7+5M0gEpoJ_jnC8_4Ae-xe2rr7+CJLZh3JjAhh=p=-2bEAcA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:46:08AM -0700, Eric Northup wrote:
> On Wed, Mar 14, 2012 at 6:25 AM, Gleb Natapov <gleb@redhat.com> wrote:
> 
> > On Wed, Mar 14, 2012 at 03:16:05PM +0200, Avi Kivity wrote:
> > > On 03/14/2012 03:14 PM, Gleb Natapov wrote:
> > > > On Wed, Mar 14, 2012 at 03:07:46PM +0200, Avi Kivity wrote:
> > > > > On 03/14/2012 01:11 PM, Wen Congyang wrote:
> > > > > > >
> > > > > > > I don't think we want to use the driver.  Instead, have a small
> > piece of
> > > > > > > code that resets the device and pushes out a string (the panic
> > message?)
> > > > > > > without any interrupts etc.
> > > > > > >
> > > > > > > It's still going to be less reliable than a hypercall, I agree.
> > > > > >
> > > > > > Do you still want to use complicated and less reliable way?
> > > > >
> > > > > Are you willing to try it out and see how complicated it really is?
> > > > >
> > > > > While it's more complicated, it's also more flexible.  You can
> > > > > communicate the panic message, whether the guest is attempting a
> > kdump
> > > > > and its own recovery or whether it wants the host to do it, etc., you
> > > > > can communicate less severe failures like oopses.
> > > > >
> > > > hypercall can take arguments to achieve the same.
> > >
> > > It has to be designed in advance; and every time we notice something's
> > > missing we have to update the host kernel.
> > >
> >
> > We and in the designed stage now. Not to late to design something flexible
> > :) Panic hypercall can take GPA of a buffer where host puts panic info
> > as a parameter.  This buffer can be read by QEMU and passed to management.
> >
> 
> If a host kernel change is in the works, I think it might be cleanest to
> have the host kernel export a new kind of VCPU exit for unhandled-by-KVM
> hypercalls.  Then usermode can respond to the hypercall as appropriate.
>  This would permit adding or changing future hypercalls without host kernel
> changes.
> 
There was such vm exit (KVM_EXIT_HYPERCALL), but it was deemed to be a
bad idea.

> "Guest panic" is almost the definition of not-a-fast-path, and so what's
> the reason to handle it in the host kernel.
The only "handling" that kernel does is maps hypercall to panic exit.

> 
> Punting to user-space wouldn't be a magic bullet for getting good
> interfaces designed, but in my opinion it is a better place to be doing
> them.

--
			Gleb.
