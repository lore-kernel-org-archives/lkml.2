Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab0LAVaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 16:30:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55687 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab0LAVai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 16:30:38 -0500
Date: Wed, 1 Dec 2010 22:30:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] x86, NMI: Remove DIE_NMI_IPI and add priorties to
 handlers
Message-ID: <20101201213034.GD7218@basil.fritz.box>
References: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
 <1291156050-4482-5-git-send-email-dzickus@redhat.com>
 <20101201184128.GB6478@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201184128.GB6478@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 09:41:28PM +0300, Cyrill Gorcunov wrote:
> On Tue, Nov 30, 2010 at 05:27:25PM -0500, Don Zickus wrote:
> > When re-ordering how the NMI handles its callbacks, a conversation started
> > asking what DIE_NMI_IPI meant.  No one could answer it.
> 
> It should have came from commit
> 
>  | commit c4b2bffee2a4115fed2825530f2b906ee2f17bd7
>  | Author: Andi Kleen <ak@suse.de>
>  | Date:   Fri Jan 23 18:46:40 2004 -0800
>  |
>  |   [PATCH] x86-64 merge
>  |   
>  |   Mainly lots of bug fixes and a few minor features. One change is that
>  |   it uses drivers/Kconfig now like i386. This requires a few minor changes in
>  |   outside Kconfig files which I am sending separately.
>  ...
> 
> Andi do you remember what the initial idea was? Didn't find any user of it
> even in this old commit. Just curious.

The original die names were pretty much a 1:1 conversion of the hooks
used by both the external KDB and KGDB patchkits floating around
at that time.

IIRC DIE_NMI_IPI was the one that was early in the NMI handler
and DIE_NMI late when everything else failed.

So you could use NMI_IPI when you just wanted to stop
all CPUs with a broadcast NMI and can check that reliable
through some memory location, and NMI when you wanted
to drop into the debugger as a last resort.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
