Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab1F2L7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:59:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51284 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab1F2L72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:59:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [RFC 7/8] drivers: introduce rpmsg, a remote-processor messaging bus
Date: Wed, 29 Jun 2011 13:59:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "davinci-linux-open-source" 
	<davinci-linux-open-source@linux.davincidsp.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com> <20110628164453.aa85c85c.rdunlap@xenotime.net> <BANLkTinDX9ETcqZ=hvSGaao2s=ZcM-JsAg@mail.gmail.com>
In-Reply-To: <BANLkTinDX9ETcqZ=hvSGaao2s=ZcM-JsAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291359.14026.arnd@arndb.de>
X-Provags-ID: V02:K0:/WQXA6mwzCbXWM5J8VixLLfuPt5unHF2T/jIrSwx8iM
 mZu+GHD56kZcrETcV7zXz56N106v4foISee/mXZXWepnwJCiyc
 JhfV/ggWM1idvWDJaF0DEeZ4Z7U9AniaEj9eePmXxvQdb6Ox/w
 6wBvtRWBm+rA2KltLxAH7kUyn65LutHD5qUnhIPuedaj7suCel
 VbcdpFV6crmPPjJogAYEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 June 2011, Ohad Ben-Cohen wrote:
> On Wed, Jun 29, 2011 at 2:44 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> >> +hardware accelerators, and therefore are often used to offload cpu-intensive
> >
> > prefer:                                                           CPU-
> > throughout.
> 
> Isn't that changing the meaning a bit ? Let's stick with the original
> version, I think it's more clear.

I think you misunderstood Randy, he meant you should do 's/cpu/CPU/' globally,
which does not change the meaning.

> >> +system's physical memory and/or other sensitive hardware resources (e.g. on
> >> +OMAP4, remote cores (/hardware accelerators) may have direct access to the
> >> +physical memory, gpio banks, dma controllers, i2c bus, gptimers, mailbox
> >> +devices, hwspinlocks, etc..). Moreover, those remote processors might be
> >> +running RTOS where every task can access the entire memory/devices exposed
> >> +to the processor. To minimize the risks of rogue (/buggy) userland code
> >
> > What is with the leading / here and above (/hardware) and below?
> 
> / here means "or". You can read the sentence twice, either without the
> (/ ..) options or with them, and then you get two (different)
> examples.
> 
> Any idea how to make it more readable ? I prefer not to drop the
> second example, as it's adding information.

The easiest way would be to replace it with 'or', as in

... remote cores (or hardware accelerators) may have ...

I would also suggest you drop the parentheses, especially in the first
case where you have two levels of them:

system's physical memory and/or other sensitive hardware resources, e.g. on
OMAP4, remote cores and hardware accelerators may have direct access to the
specific hardware blocks such as physical memory, gpio banks or dma
controllers.
Moreover, those remote processors might be...

> >> +if RPMSG
> >> +
> >> +# OK, it's a little counter-intuitive to do this, but it puts it neatly under
> >> +# the rpmsg menu (and it's the approach preferred by the virtio folks).
> >> +
> >> +source "drivers/virtio/Kconfig"
> >
> > It seems odd to have that Kconfig file sourced in multiple places.
> > Are the kconfig tools happy with that?
> 
> They are, probably because these places are mutually exclusive today:
> 
> $ git grep "drivers/virtio/Kconfig"
> arch/ia64/kvm/Kconfig:source drivers/virtio/Kconfig
> arch/mips/Kconfig:source drivers/virtio/Kconfig
> arch/powerpc/kvm/Kconfig:source drivers/virtio/Kconfig
> arch/s390/kvm/Kconfig:source drivers/virtio/Kconfig
> arch/sh/Kconfig:source drivers/virtio/Kconfig
> arch/tile/kvm/Kconfig:source drivers/virtio/Kconfig
> arch/x86/kvm/Kconfig:source drivers/virtio/Kconfig
> 
> Now that we start using virtio for inter-processor communications,
> too, we might soon bump into a situation where virtio will be sourced
> twice.
> 
> Probably the solution is to move 'source "drivers/virtio/Kconfig"'
> into drivers/Kconfig, and remove all other instances.

I think changing that would be good. However, you need to at least
restructure the contents, or they will show up in the main driver menu.

	Arnd
