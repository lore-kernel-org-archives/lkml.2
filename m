Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0CZSIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 14:08:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056Ab0CZSIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 14:08:32 -0400
Date: Fri, 26 Mar 2010 11:03:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
cc: David Howells <dhowells@redhat.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] X86: Optimise fls(), ffs() and fls64()
In-Reply-To: <20100326175827.GD20055@linux-mips.org>
Message-ID: <alpine.LFD.2.00.1003261100440.3721@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003261005490.3721@i5.linux-foundation.org> <20100326144241.8583.95617.stgit@warthog.procyon.org.uk> <28287.1269625325@redhat.com> <alpine.LFD.2.00.1003261042580.3721@i5.linux-foundation.org>
 <20100326175827.GD20055@linux-mips.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Mar 2010, Ralf Baechle wrote:
> 
> My trusty old 486 book [1] in the remarks about the BSF instruction:
> 
> "The documentation on the 80386 and 80486 states that op1 is undefined if
> op2 is 0.  In reality the 80386 will leave the value in op1 unchanged.
> The first versions of the 80486 will change op1 to an undefined value.
> Later version again will leave it unchanged."
> 
> [1] Die Intel Familie in German language, by Robert Hummel, 1992

Ok, that explains my memory of us having tried this, at least.

But I do wonder if any of the people working for Intel could ask the CPU 
architects whether we could depend on the "don't write" for 64-bit mode. 
If AMD already documents the don't-touch semantics, and if Intel were to 
be ok with documenting it for their 64-bit capable CPU's, we wouldn't then 
need to rely on undefined behavior.

		Linus
