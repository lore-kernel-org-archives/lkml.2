Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab1JCPEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:04:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab1JCPEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:04:42 -0400
Date: Mon, 3 Oct 2011 11:03:46 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Morton <akpm00@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, hongjiu.lu@intel.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [RFC PATCH] binfmt_elf: Fix PIE execution with randomization
 disabled
Message-ID: <20111003150345.GP16720@zod.bos.redhat.com>
References: <20110929195359.GJ16720@zod.bos.redhat.com>
 <20110929141929.43df799d.akpm00@gmail.com>
 <alpine.LFD.2.02.1109291958210.9106@xanadu.home>
 <20110930021629.GL16720@zod.bos.redhat.com>
 <alpine.LNX.2.00.1110031651400.31654@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1110031651400.31654@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 04:53:34PM +0200, Jiri Kosina wrote:
> On Thu, 29 Sep 2011, Josh Boyer wrote:
> 
> > Perhaps another check here for randomize?  Something like:
> > 
> > #if defined(CONFIG_X86) || defined(CONFIG_ARM)
> > 		if (current->flags & PF_RANDOMIZE)
> > 			load_bias = 0;
> > 		else if (vaddr)
> > 			load_bias = 0;
> > 		else
> > 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE);
> > #else
> > 		load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> > #endif
> > 
> > If that's stupid, then feel free to tell me.  I won't pretend like I
> > understand what is going on here yet, but based on the explanation you
> > provided that might work.
> 
> I have just verified my hunch that the original patch from H.J. / Josh 
> breaks ASLR completely, so Andrew, please drop it for now.

Yes, please drop the original.

> I am now looking into how to fix things properly.
> 
> Josh, looking at what you are proposing -- do you see any reason to make 
> the behavior different in #else branch and in !(current->flags & 
> PF_RANDOMIZE) case?

I was mostly just trying to adapt H.J.'s patch to account for the
PF_RANDOMIZE case.  Looking at it a bit more, I'm not sure why they
would need to be different.  H.J., do you recall why you made that
change originally?

josh
