Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab1E0QKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:10:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34945 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab1E0QKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:10:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Date: Fri, 27 May 2011 18:11:19 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
References: <1306269105.21443.20.camel@dan> <20110527024556.GA22396@redhat.com> <20110527094047.GJ21386@elte.hu>
In-Reply-To: <20110527094047.GJ21386@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105271811.19977.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 27, 2011, Ingo Molnar wrote:
> 
> * Dave Jones <davej@redhat.com> wrote:
> 
> > On Thu, May 26, 2011 at 03:32:13PM -0700, H. Peter Anvin wrote:
> >  > On 05/26/2011 03:18 PM, Rafael J. Wysocki wrote:
> >  > > 
> >  > > Well, as far as I can tell, this feature is going to break hibernation on
> >  > > both x86_32 and x86_64 at the moment, unless you can guarantee that the
> >  > > randomized kernel location will be the same for both the boot and the target
> >  > > kernels.
> >  > > 
> >  > 
> >  > Obviously we can't and we don't.  I'm a bit surprised at that
> >  > constraint... how can that constraint not break things like kernels of
> >  > slightly different size?
> > 
> > In Fedora at least, we make sure the kernel you thaw from is the 
> > same one you booted by diddling with grub to force the right kernel 
> > to be booted.
> 
> Btw., the hibernation code should save a signature and make sure that 
> the two kernels match! It's really broken if the code allows blind 
> thawing ...

It uses signatures, but on x86_64 you actually can use a different kernel
for loading the image, with some limitations.

I'd like to add a mechanism for passing the jump address into the hibernated
kernel in the kernel image, but that part is still missing.

Thanks,
Rafael
