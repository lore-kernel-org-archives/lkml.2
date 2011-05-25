Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab1EYOD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:03:57 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:55748 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab1EYOD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:03:56 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
In-Reply-To: <4DDC39F1.2060903@zytor.com>
References: <1306269105.21443.20.camel@dan> <20110524211644.GJ27634@elte.hu>
	 <4DDC39F1.2060903@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 10:03:45 -0400
Message-ID: <1306332225.2211.9.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 16:06 -0700, H. Peter Anvin wrote:
> On 05/24/2011 02:16 PM, Ingo Molnar wrote:
> > 
> > On some systems holes can be pretty low as well - you'd have to research e820 
> > maps submitted to lkml to see how common this is - but it's not terribly 
> > common.
> > 
> > Some really old systems might have a hole between 15MB-16MB - but that's not an 
> > issue if we load at 16 MB or higher.
> > 
> 
> It definitely happens, and not just at 15-16 MiB either.
> 
> Doing this without actually consulting the memory map is dangerous as
> hell; plus you have to verify that you're not clobbering anything else,
> like the command line, initramfs or the linked list of data.
> 

My current idea is to use int 0x15, eax = 0xe801 (which seems to be
nearly universally supported) and use bx/dx to determine the amount of
contiguous, usable memory above 16 MB, which seems to be exactly what we
want to know.  If the BIOS does not support this function I'll be sure
to catch that and skip the randomization.  Likewise, if the amount of
returned memory seems insufficient or otherwise confusing, I'll skip the
randomization.

Given this information, do you have a conservative guess for how close
to the top of available memory we can put the kernel?  As in, let's say
we have an XYZ MB chunk of contiguous, free memory, how should I
calculate the highest, safe place to put the kernel in that region?

I'm going to continue to enforce the requirement that 16 MB is the
lowest address we can safely load the kernel, and I'd still appreciate
any information on why 2/4 MB default alignment might cause problems.

Thanks,
Dan

> 	-hpa


