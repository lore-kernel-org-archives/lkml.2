Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab1JCOxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:53:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260Ab1JCOxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:53:39 -0400
Date: Mon, 3 Oct 2011 16:53:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Morton <akpm00@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, hongjiu.lu@intel.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [RFC PATCH] binfmt_elf: Fix PIE execution with randomization
 disabled
In-Reply-To: <20110930021629.GL16720@zod.bos.redhat.com>
Message-ID: <alpine.LNX.2.00.1110031651400.31654@pobox.suse.cz>
References: <20110929195359.GJ16720@zod.bos.redhat.com> <20110929141929.43df799d.akpm00@gmail.com> <alpine.LFD.2.02.1109291958210.9106@xanadu.home> <20110930021629.GL16720@zod.bos.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011, Josh Boyer wrote:

> Perhaps another check here for randomize?  Something like:
> 
> #if defined(CONFIG_X86) || defined(CONFIG_ARM)
> 		if (current->flags & PF_RANDOMIZE)
> 			load_bias = 0;
> 		else if (vaddr)
> 			load_bias = 0;
> 		else
> 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE);
> #else
> 		load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> #endif
> 
> If that's stupid, then feel free to tell me.  I won't pretend like I
> understand what is going on here yet, but based on the explanation you
> provided that might work.

I have just verified my hunch that the original patch from H.J. / Josh 
breaks ASLR completely, so Andrew, please drop it for now.

I am now looking into how to fix things properly.

Josh, looking at what you are proposing -- do you see any reason to make 
the behavior different in #else branch and in !(current->flags & 
PF_RANDOMIZE) case?

-- 
Jiri Kosina
SUSE Labs
