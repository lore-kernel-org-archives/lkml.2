Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab0GILDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 07:03:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:49196 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab0GILDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 07:03:05 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dynamic Debug broken on 2.6.35-rc3?
Date: Fri, 9 Jul 2010 13:03:08 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Jason Baron <jbaron@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>
References: <201007011744.19564.trenn@suse.de> <20100708213927.GB2934@redhat.com> <20100708145300.d36cf006.akpm@linux-foundation.org>
In-Reply-To: <20100708145300.d36cf006.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007091303.08693.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I can confirm that this patch fixes the issue for me.

On Thursday 08 July 2010 23:53:00 Andrew Morton wrote:
> On Thu, 8 Jul 2010 17:39:28 -0400
> Jason Baron <jbaron@redhat.com> wrote:
> 
> > Make sure we properly call ddebug_remove_module() when a module fails to
> > load. In addition, pass the pointer to the "debug table", to both
> > ddebug_add_module(), and ddebug_remove_module() so that we can uniquely
> > identify each set of debug statements. In this way even modules with the
> > same name can be properly identified and removed.
> > 
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> It'd be nice to track the Reported-by:s.  And the Tested-by:s if/when
> they arrive.  SighIllDoIt.
> 
> The patch (almost) applies to 2.6.34.  So are we missing a Cc:stable tag
> as well?
I'll resubmit with some more meta info and will include stable@kernel.org.

Could it be that this isn't a regression, but a bug that was always present,
but only gets exposed if you add modules with a specific implementation,
e.g. specific declarations of functions missing, etc.?

I tried to patch this into a 2.6.32.X kernel. While some hunks did not
succeed, it looks like an adjusted patch should get submitted for older
stable kernels as well?:

/dev/shm/linux-2.6.32> patch --dry-run -p1 -i ../linux-2.6.35-rc3/dynamic_debug_broken.patch 
patching file include/linux/dynamic_debug.h
Hunk #2 succeeded at 76 with fuzz 2 (offset 3 lines).
patching file include/linux/module.h
Hunk #1 succeeded at 376 (offset -11 lines).
patching file kernel/module.c
Hunk #1 FAILED at 787.
Hunk #2 succeeded at 1596 with fuzz 2 (offset 47 lines).
Hunk #3 succeeded at 2098 (offset 44 lines).
Hunk #4 succeeded at 2548 (offset 62 lines).
Hunk #5 succeeded at 2638 with fuzz 2 (offset 73 lines).
1 out of 5 hunks FAILED -- saving rejects to file kernel/module.c.rej
patching file lib/dynamic_debug.c
Hunk #1 succeeded at 691 (offset -1 lines).
Hunk #2 succeeded at 702 (offset -1 lines).

Thanks Jason for this quick fix!

    Thomas
