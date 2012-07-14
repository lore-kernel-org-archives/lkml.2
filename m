Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab2GNCZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 22:25:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:47201 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab2GNCZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 22:25:52 -0400
Date: Sat, 14 Jul 2012 04:25:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Avi Kivity <avi@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fixes for 3.5-rc6
In-Reply-To: <alpine.LFD.2.02.1207131928000.32033@ionos>
Message-ID: <alpine.LFD.2.02.1207140208270.32033@ionos>
References: <4FFEBB39.8090308@redhat.com> <CA+55aFwAXbrQRKg_cJT04H_XnoEPjJ0O711C5uA6fRY35DVhKQ@mail.gmail.com> <CA+55aFy=ogfJu3WuoCCDseysxOOn_UEAnv_7Ldsa45VV7fMVPg@mail.gmail.com> <alpine.LFD.2.02.1207131928000.32033@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Thomas Gleixner wrote:
> On Fri, 13 Jul 2012, Linus Torvalds wrote:
> > On Fri, Jul 13, 2012 at 8:45 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > At the same time, I do wonder if maybe MSI + IRQF_ONESHOT couldn't be
> > improved. The fact that the KVM people think that the extra overhead
> > of IRQF_ONESHOT is a bad thing for MSI interrupts makes me wonder if
> > maybe this wouldn't be an area the irq layer couldn't be improved on.
> > Maybe the MSI+IRQF_ONESHOT case could be improved. Because MSI is kind
> > of fundamentally one-shot, since it's a message-based irq scheme.  So
> > maybe the extra overhead is unnecessary in general, not just in this
> > particular KVM case. Hmm?
> > 
> > Thomas, see the commentary of a76beb14123a ("KVM: Fix device
> > assignment threaded irq handler").
> 
> Groan.
> 
> We already discussed to let the irq chip (in this case MSI) tell the
> core that it does not need the extra oneshot handling. That way the
> code which requests an threaded irq with the NULL primary handler
> works on both MSI and normal interrupts.

That's the kind of stuff which makes me go berserk, and just for the
record: the most complaints I get for going berserk are coming from
the virt folks.

I really can't understand why the virt folks think they are
special and do not have to talk to core maintainers.

Back then when I was doing the big irq cleanup, virt crap stood out by
far with the most idiotic^Wcreative "workarounds". Of course nobody
complained about me being moronic enough to come up with generic
solutions for their problems.

Though especially that commit including its changelog proves once
again the ignorance and desinterest of the virt crowd in solving
problems which are not only relevant to themself.

I whish you'd just refused to pull that nonsense and instead made them
talk to those folks who had a proper solution in mind already.

In fact we could have solved that proper weeks ago, if only people
would have raised the issue.

I'm tired of that kind of crap, really.

    Thomas
