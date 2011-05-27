Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab1E0QVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:21:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34972 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990Ab1E0QU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:20:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Date: Fri, 27 May 2011 18:21:33 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
References: <1306269105.21443.20.camel@dan> <4DDED4ED.7020806@zytor.com> <1306455963.1984.5.camel@dan>
In-Reply-To: <1306455963.1984.5.camel@dan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105271821.34325.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 27, 2011, Dan Rosenberg wrote:
> On Thu, 2011-05-26 at 15:32 -0700, H. Peter Anvin wrote:
> > On 05/26/2011 03:18 PM, Rafael J. Wysocki wrote:
> > > 
> > > Well, as far as I can tell, this feature is going to break hibernation on
> > > both x86_32 and x86_64 at the moment, unless you can guarantee that the
> > > randomized kernel location will be the same for both the boot and the target
> > > kernels.
> > > 
> > 
> > Obviously we can't and we don't.  I'm a bit surprised at that
> > constraint... how can that constraint not break things like kernels of
> > slightly different size?
> > 
> > 	-hpa
> 
> Am I understanding it correctly that hibernation is currently operating
> under a possibly false assumption?  If it's the case that hibernation
> should be saving the physical address at which the kernel was previously
> loaded and restoring it there regardless of randomization, it would
> certainly help me out if someone familiar with the code could take a
> stab at that.

It rather has to save the address where to jump into the image kernel from
the boot kernel, but ISTR that's not straightforward.  I thought about
implementing something like this some time ago, but finally I didn't have
the time to finish that work.

At the moment I'm preparing for a trip to Japan, so I'll be able to work on
this with you when I get back home (some time next weekend).  In the
meantime, please have a look at arch/x86/power/hibernate_64.c and
arch/x86/power/hibernate_asm_64.S.

Thanks,
Rafael
