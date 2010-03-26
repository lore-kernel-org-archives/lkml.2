Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0CZSQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 14:16:44 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57756 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab0CZSQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 14:16:42 -0400
Date: Fri, 26 Mar 2010 12:16:41 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] X86: Optimise fls(), ffs() and fls64()
Message-ID: <20100326181641.GP3875@parisc-linux.org>
References: <alpine.LFD.2.00.1003261005490.3721@i5.linux-foundation.org> <20100326144241.8583.95617.stgit@warthog.procyon.org.uk> <28287.1269625325@redhat.com> <alpine.LFD.2.00.1003261042580.3721@i5.linux-foundation.org> <20100326175827.GD20055@linux-mips.org> <alpine.LFD.2.00.1003261100440.3721@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003261100440.3721@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 11:03:09AM -0700, Linus Torvalds wrote:
> On Fri, 26 Mar 2010, Ralf Baechle wrote:
> > 
> > My trusty old 486 book [1] in the remarks about the BSF instruction:
> > 
> > "The documentation on the 80386 and 80486 states that op1 is undefined if
> > op2 is 0.  In reality the 80386 will leave the value in op1 unchanged.
> > The first versions of the 80486 will change op1 to an undefined value.
> > Later version again will leave it unchanged."
> > 
> > [1] Die Intel Familie in German language, by Robert Hummel, 1992
> 
> Ok, that explains my memory of us having tried this, at least.
> 
> But I do wonder if any of the people working for Intel could ask the CPU 
> architects whether we could depend on the "don't write" for 64-bit mode. 
> If AMD already documents the don't-touch semantics, and if Intel were to 
> be ok with documenting it for their 64-bit capable CPU's, we wouldn't then 
> need to rely on undefined behavior.

I'll drop one of them a note.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
