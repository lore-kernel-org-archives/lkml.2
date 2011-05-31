Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab1EaT4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:56:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42743 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862Ab1EaT4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:56:09 -0400
Date: Tue, 31 May 2011 21:55:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, davej@redhat.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, eranian@google.com,
        penberg@kernel.org, davem@davemloft.net,
        Arjan van de Ven <arjan@infradead.org>, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>, pageexec@freemail.hu,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110531195551.GC26970@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <1306442367.2279.25.camel@dan>
 <20110531165252.GB8971@srcf.ucam.org>
 <4DE5360D.5070809@zytor.com>
 <20110531185122.GA11998@srcf.ucam.org>
 <1306868609.6317.25.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306868609.6317.25.camel@dan>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> Just for the record, I've put this patch on hold until there's some 
> more consensus about whether boot-time randomization of the 
> physical kernel address is the best approach. [...]

Well, if you use the suggestion i made: to skip the e820 map fiddling 
altogether and just allocate half a megabyte of 'hole' at the end of 
the kernel image - which would allow the kernel to be randomized 
freely upwards by 0-128 pages - then the 'dynamic' versus 'static' 
solution could be used at once!

The 'static' method would use the same hole, just at install time, 
while the 'dynamic' method would use it during bootup.

Also, if this method is used then most of the controversy about the 
dynamic approach goes away (which was the memory maps interpretation 
fragility).

Your last patch would need only minor modifications to get the hole 
added: you'd need to add the tail-hole in the linker map:

   arch/x86/kernel/vmlinux.lds.S

So ... could you *please* not shelf this idea just because people 
used lkml for what it was invented: argued with each other rather 
forcefully? :-)

Thanks,

	Ingo
