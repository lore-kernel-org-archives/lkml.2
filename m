Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab2GKIFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:05:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47123 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2GKIEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:04:53 -0400
Date: Wed, 11 Jul 2012 10:04:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT PULL] x86/mce fix (ready for 3.6 merge window)
Message-ID: <20120711080446.GA17713@gmail.com>
References: <4ffc6b7b63006ca92@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ffc6b7b63006ca92@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:
> 
>   Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-mce-ripvfix
> 
> for you to fetch changes up to b99c2fc9366d4e32b8d087cd28f6dbf5f7932dae:
> 
>   x86/mce: Need to let kill_proc() send signal to doomed process (2012-07-10 10:18:29 -0700)
> 
> ----------------------------------------------------------------
> Fix application level machine check recovery
> 
> ----------------------------------------------------------------
> Tony Luck (1):
>       x86/mce: Need to let kill_proc() send signal to doomed process
> 
>  arch/x86/kernel/cpu/mcheck/mce.c |  6 ++++--
>  include/linux/mm.h               |  1 +
>  mm/memory-failure.c              | 10 ++++++----
>  3 files changed, 11 insertions(+), 6 deletions(-)

A couple of commit log details:

 - If it's for v3.6 then the Cc: stable backport is not 
   justified. Either it's for tip:x86/urgent and then we'll 
   merge it straight away, or for tip:x86/mce for v3.6 and then 
   there's no Cc: stable tag.

 - This reference to a commit is a bit unusual:

In commit dad1743e5993f19b3d7e7bd0fb35dc45b5326626
x86/mce: Only restart instruction after machine check recovery if it is safe

   the canonical format is something like:

  In commit dad1743e5993f1 ("x86/mce: Only restart instruction 
  after machine check recovery if it is safe") ...

 - We tend to use such an ordering of tags:

  Signed-off-by: Tony Luck <tony.luck@intel.com>
  Acked-by: Borislav Petkov <borislav.petkov@amd.com>
  Cc: stable@kernel.org    # 3.4+

  I.e. Tested-by and Reported-by tags first (if any), then 
  author SOB, then SOB chain (if any), then Reviewed-by
  and Acked-by, then stable tags, then Cc:s.

  (I fix this up silently for email space patches, for Git pulls
   I cannot do that.)

 - The title is suboptimal:

  x86/mce: Need to let kill_proc() send signal to doomed process

   In titles we prefer proper sentences, starting with a verb, 
   so something like this would do:

  x86/mce: Allow kill_proc() to send signals to doomed process

   Or rather, use a good title that talks about what the change 
   is really about:

  x86/mce: Fix siginfo_t->si_addr value for non-recoverable memory faults

 - (Spelling nitpick: it's not "et. al." but "et al.".)

 - Style nit, this:

       if (mi->restartable == 0)

   is better written as:

       if (!mi->restartable)

   because mi->restartable's role here is not really an integer 
   value, but a boolean in essence.

 - The 'doit' flag was significantly misnamed when kill_procs() 
   was written and now it spreads further, it's a totally opaque 
   name that tells nothing about the role of the flag.

   How about 'force'?

Thanks,

	Ingo
