Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2GKIbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:31:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37601 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab2GKIbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:31:07 -0400
Date: Wed, 11 Jul 2012 10:31:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT PULL] x86/mce fix (ready for 3.6 merge window)
Message-ID: <20120711083101.GA23206@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
	linux-kernel@vger.kernel.org,
	the arch/x86 maintainers <x86@kernel.org>
References: <4ffc6b7b63006ca92@agluck-desktop.sc.intel.com>
 <20120711080446.GA17713@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120711080446.GA17713@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 10:04:46AM +0200, Ingo Molnar wrote:
> A couple of commit log details:
> 
>  - If it's for v3.6 then the Cc: stable backport is not 
>    justified. Either it's for tip:x86/urgent and then we'll 
>    merge it straight away, or for tip:x86/mce for v3.6 and then 
>    there's no Cc: stable tag.

This could be part of checkpatch - whenever a stable tag is added to a
patch commit msg, it should at least warn the patch author to check with
<Documentation/stable_kernel_rules.txt> first.

>  - This reference to a commit is a bit unusual:
> 
> In commit dad1743e5993f19b3d7e7bd0fb35dc45b5326626
> x86/mce: Only restart instruction after machine check recovery if it is safe
> 
>    the canonical format is something like:
> 
>   In commit dad1743e5993f1 ("x86/mce: Only restart instruction 
>   after machine check recovery if it is safe") ...

Commit referencing in commit messages doesn't come up for the first time
so can we get this as a rule into checkpatch so that we can have unified
commit reference format?

The regex would be probably hairy and generate a couple of false
positives but sure it will help in a lot of other situations.

Also, how many chars of the commit id we keep? The first 12, 14, 15? I'm
thinking of commit id uniqueness sometime far in the future.

>  - We tend to use such an ordering of tags:
> 
>   Signed-off-by: Tony Luck <tony.luck@intel.com>
>   Acked-by: Borislav Petkov <borislav.petkov@amd.com>
>   Cc: stable@kernel.org    # 3.4+
> 
>   I.e. Tested-by and Reported-by tags first (if any), then 
>   author SOB, then SOB chain (if any), then Reviewed-by
>   and Acked-by, then stable tags, then Cc:s.

patch tags order could be checked for in checkpatch too?

[ … ]

>  - Style nit, this:
> 
>        if (mi->restartable == 0)
> 
>    is better written as:
> 
>        if (!mi->restartable)
> 
>    because mi->restartable's role here is not really an integer 
>    value, but a boolean in essence.

Yes, we talked about this but having a bool as a u8 there would add
padding to the struct so it's the same thing, space-wise. It could be
converted to a bitfield if more flags are added/needed.

>  - The 'doit' flag was significantly misnamed when kill_procs() 
>    was written and now it spreads further, it's a totally opaque 
>    name that tells nothing about the role of the flag.
> 
>    How about 'force'?

Even better, make it even more descriptive: 'force_kill' or 'do_kill' or
'really_kill' - this way one knows exactly what one is looking at.

Thanks.

-- 
Regards/Gruss,
    Boris.
