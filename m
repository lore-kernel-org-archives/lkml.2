Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab1EXW4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:56:10 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:59905 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab1EXW4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:56:09 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
In-Reply-To: <20110524210233.GI27634@elte.hu>
References: <1306269105.21443.20.camel@dan> <20110524210233.GI27634@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 18:55:58 -0400
Message-ID: <1306277758.1921.0.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 23:02 +0200, Ingo Molnar wrote:
> * Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> 
> > This introduces CONFIG_RANDOMIZE_BASE, which randomizes the address at
> > which the kernel is decompressed at boot as a security feature that
> > deters exploit attempts relying on knowledge of the location of kernel
> > internals.  The default values of the kptr_restrict and dmesg_restrict
> > sysctls are set to (1) when this is enabled, since hiding kernel
> > pointers is necessary to preserve the secrecy of the randomized base
> > address.
> 
> That was quick! :-)
> 
> > This feature also uses a fixed mapping to move the IDT (if not already
> > done as a fix for the F00F bug), to avoid exposing the location of
> > kernel internals relative to the original IDT.  This has the additional
> > security benefit of marking the new virtual address of the IDT
> > read-only.
> 
> Btw., as i suggested before the IDT should be made percpu, that way we could 
> split out and evaluate the IDT change independently of any security 
> considerations, as a potential scalability improvement. Makes the decision 
> easier because right now moving the IDT to a 4K TLB increases the kernel's TLB 
> footprint a tiny bit.
> 

Alright, I'll start working on this.

> > Entropy is generated using the RDRAND instruction if it is supported. If not, 
> > then RDTSC is used, if supported. If neither RDRAND nor RDTSC are supported, 
> > then no randomness is introduced. Support for the CPUID instruction is 
> > required to check for the availability of these two instructions.
> 
> Btw., i'd suggest to fall back not to zero but to something system specific 
> like RAM size or a BIOS signature such as the contents of 0xf0000 or so. This, 
> while clearly not random, will at least *somewhat* randomize the kernel against 
> remote attackers who do not know the RAM size or the system type.
> 

Good idea, will do.

-Dan

