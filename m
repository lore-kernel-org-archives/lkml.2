Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab1BXTcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:32:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50927 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262Ab1BXTcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:32:23 -0500
Date: Thu, 24 Feb 2011 20:32:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [GIT PULL tip:x86/mm]
Message-ID: <20110224193211.GC15498@elte.hu>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D66B176.9030300@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On 02/24/2011 11:23 AM, Ingo Molnar wrote:
> > 
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> On 02/24/2011 06:51 AM, Tejun Heo wrote:
> >>> Ingo, please pull from the following git branch to receive four
> >>> commits from Yinghai.  HEAD is d1b19426b0 (x86: Rename e820_table_* to
> >>> pgt_buf_*).
> >>>
> >>> The first three separate nobootmem code into mm/nobootmem.c and the
> >>> last one renames e820_table_* variables to pgt_buf_*.  All four
> >>> patches are cleanups and shouldn't cause any behavior difference.
> >>>
> >>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
> >>>
> >>> As usual, if HEAD doesn't appear, please pull from master.
> >>>
> >>>   ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
> >>>
> >>> Thanks.
> >>>
> >>> Yinghai Lu (4):
> >>>       bootmem: Separate out CONFIG_NO_BOOTMEM code into nobootmem.c
> >>>       bootmem: Move contig_page_data definition to bootmem.c/nobootmem.c
> >>>       bootmem: Move __alloc_memory_core_early() to nobootmem.c
> >>>       x86: Rename e820_table_* to pgt_buf_*
> >>>
> >>>  arch/x86/include/asm/init.h |    6 +-
> >>>  arch/x86/mm/init.c          |   20 +-
> >>>  arch/x86/mm/init_32.c       |    8 +-
> >>>  arch/x86/mm/init_64.c       |    4 +-
> >>>  arch/x86/xen/mmu.c          |    2 +-
> >>>  include/linux/mm.h          |    2 -
> >>>  mm/Makefile                 |    8 +-
> >>>  mm/bootmem.c                |  180 +-----------------
> >>>  mm/nobootmem.c              |  435 +++++++++++++++++++++++++++++++++++++++++++
> >>>  mm/page_alloc.c             |   37 ----
> >>>  10 files changed, 472 insertions(+), 230 deletions(-)
> >>>  create mode 100644 mm/nobootmem.c
> >>>
> >>
> >> better to put first three into seperate branch. and it is with core code.
> >> something like tip/mm
> >>
> >> So will not pollute tip/x86/mm. and they can be pushed separately.
> > 
> > Well, realistically they will be tested together and will go to Linus under the 
> > x86/mm label anyway, so there's little reason to keep them separate at this point.
> > 
> > So i've pulled them. Thanks guys!
> 
> DavidR reported that x86/mm broke his numa emulation with 128M etc.

That regression needs to be fixed. Tejun, do you know about that bug?

Thanks,

	Ingo
