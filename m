Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab2GMP7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:59:21 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41153 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab2GMP7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:59:17 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwAXbrQRKg_cJT04H_XnoEPjJ0O711C5uA6fRY35DVhKQ@mail.gmail.com>
References: <4FFEBB39.8090308@redhat.com> <CA+55aFwAXbrQRKg_cJT04H_XnoEPjJ0O711C5uA6fRY35DVhKQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jul 2012 08:58:55 -0700
X-Google-Sender-Auth: 8dE6bz1TvpDTrL5OpchwDmBOquQ
Message-ID: <CA+55aFy=ogfJu3WuoCCDseysxOOn_UEAnv_7Ldsa45VV7fMVPg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fixes for 3.5-rc6
To: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 8:45 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Missing diffstat. Please please *please* always make sure you have
> diffstats, because I really want to know that what I'm pulling matches
> what you *think* that I'm pulling. And the diffstat isn't just for me
> - it hopefully really makes you look at the whole "this is what I'm
> asking Linus to pull" thing too.

Btw, I'm cc'ing the irq people here too, because since I went and
looked at the details of the low-level commits due to the lack of
diffstat verification, I noticed that your fix for the lack of
IRQF_ONESHOT thing was interestingly different from the other peoples
"just add IRQF_ONESHOT".

I didn't realize that IRQF_ONESHOT had the kind of extra overhead that
you'd have noticed. And I do think that your solution is a prime
example of why we should never *ever* do the "just assume the user
meant xyz" solutions in things like the irq layer. Because just
assuming IRQF_ONESHOT was clearly the suboptimal thing to do in this
case. So it just reinforces my point that we did the right thing by
just making it an error.

At the same time, I do wonder if maybe MSI + IRQF_ONESHOT couldn't be
improved. The fact that the KVM people think that the extra overhead
of IRQF_ONESHOT is a bad thing for MSI interrupts makes me wonder if
maybe this wouldn't be an area the irq layer couldn't be improved on.
Maybe the MSI+IRQF_ONESHOT case could be improved. Because MSI is kind
of fundamentally one-shot, since it's a message-based irq scheme.  So
maybe the extra overhead is unnecessary in general, not just in this
particular KVM case. Hmm?

Thomas, see the commentary of a76beb14123a ("KVM: Fix device
assignment threaded irq handler").

                  Linus
