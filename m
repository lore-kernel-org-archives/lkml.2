Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab1JCVOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:14:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757577Ab1JCVO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:14:28 -0400
Date: Mon, 3 Oct 2011 23:14:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Lu, Hongjiu" <hongjiu.lu@intel.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Andrew Morton <akpm00@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: RE: [PATCH v2] binfmt_elf: Fix PIE execution with randomization
 disabled (was Re: [RFC PATCH] binfmt_elf: Fix PIE execution with randomization
 disabled)
In-Reply-To: <9DA5872FEF993D41B7173F58FCF6BE94E0906494@orsmsx504.amr.corp.intel.com>
Message-ID: <alpine.LNX.2.00.1110032312260.31654@pobox.suse.cz>
References: <20110929195359.GJ16720@zod.bos.redhat.com> <20110929141929.43df799d.akpm00@gmail.com> <alpine.LFD.2.02.1109291958210.9106@xanadu.home> <20110930021629.GL16720@zod.bos.redhat.com> <alpine.LNX.2.00.1110031651400.31654@pobox.suse.cz>
 <20111003150345.GP16720@zod.bos.redhat.com> <alpine.LNX.2.00.1110031709230.31654@pobox.suse.cz> <alpine.LFD.2.02.1110031150470.9106@xanadu.home> <9DA5872FEF993D41B7173F58FCF6BE94E0906494@orsmsx504.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Lu, Hongjiu wrote:

> Why not
> 
> #if defined(CONFIG_X86) || defined(CONFIG_ARM)
> #define CHECK_PF_RANDOMIZE 1
> #else
> #define CHECK_PF_RANDOMIZE 0
> #endif
> 			if (CHECK_PF_RANDOMIZE && (current->flags & PF_RANDOMIZE))
> 				load_bias = 0;
> 			else
> 				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);

If anything, that is not particularly good name for that macro (as we are 
checking current->flags for PF_RANDOMIZE at other places indepenedntly on 
this).

Personally, I find my original patch the most readable one, but I don't 
care much, it's really bike-shedding.

-- 
Jiri Kosina
SUSE Labs
