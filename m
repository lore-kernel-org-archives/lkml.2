Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab2E3SMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:12:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172Ab2E3SL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:11:59 -0400
Date: Wed, 30 May 2012 20:10:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] uprobes: simplify the usage of uprobe->pending_list
Message-ID: <20120530181006.GA19471@redhat.com>
References: <20120530165757.GA8077@redhat.com> <20120530165846.GC8085@redhat.com> <20120530174858.GN15587@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530174858.GN15587@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-05-30 18:58:46]:
>
> > uprobe->pending_list is only used to create the temporary list,
> > it has no meaning after we drop uprobes_mmap_hash(inode).
> >
> > No need to initialize this node or remove it from tmp_list, and
> > we can use list_for_each_entry().
>
>
> I actually dont see the patch that removed the uprobe->pending_list.

I think you misread this cleanup. Or may be I misunderstood you...

The patch only removes the unnecessary INIT_LIST_HEAD/list_del and
changes the code to use list_for_each_entry (_safe is not needed).

list_add() doesn't need the initialized entry, and there is no need
to "cleanup" ->pending_list after list_for_each().

However. If you dislike this change, feel free to nack it.. Cleanups
are always subjective, I won't argue if you prefer the current code.

Oleg.

