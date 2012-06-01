Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965682Ab2FASkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:40:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932799Ab2FASka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:40:30 -0400
Date: Fri, 1 Jun 2012 20:38:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] uprobes: install_breakpoint() should fail if
	is_swbp_insn() == T
Message-ID: <20120601183844.GB31771@redhat.com>
References: <20120530165757.GA8077@redhat.com> <20120530165816.GA8085@redhat.com> <1338398931.28384.7.camel@twins> <20120530173717.GM15587@linux.vnet.ibm.com> <1338400142.28384.12.camel@twins> <1338400450.28384.16.camel@twins> <20120531185339.GA28057@redhat.com> <20120601164725.GK24279@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601164725.GK24279@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-05-31 20:53:39]:
>
> > __find_next_vma_info() checks tmpvi->mm == vma->vm_mm to detect the
> > already visited mm/vma. However, afaics this can be false positive?
> >
> > The caller, register_for_each_vma(), does mmput() and after that
> > this memory can be freed and re-used as another mm_struct.
> >
>
> Before we do a mmput(), we take the mmap_sem for that mm. So this mm
> cannot be freed until we complete insertion/removal.  If the mm gets
> reused after the insertion/removal, and maps the inode,

Yes, see the previous email from me, we can rely on uprobe_mmap().

> Or are you hinting at some other problem?

Perhaps this deserves a comment. I mean, to explain that yes,
tmpvi->mm == vma->vm_mm can be wrong but this is fine.

However, I hope we simply can kill this code. See build_map_info()
I sent.

Oleg.

