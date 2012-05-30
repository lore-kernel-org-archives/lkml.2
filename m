Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab2E3RwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:52:25 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41067 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255Ab2E3RwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:52:24 -0400
Date: Wed, 30 May 2012 23:18:58 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] uprobes: simplify the usage of uprobe->pending_list
Message-ID: <20120530174858.GN15587@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120530165757.GA8077@redhat.com>
 <20120530165846.GC8085@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120530165846.GC8085@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053017-8974-0000-0000-00000997F6B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-05-30 18:58:46]:

> uprobe->pending_list is only used to create the temporary list,
> it has no meaning after we drop uprobes_mmap_hash(inode).
> 
> No need to initialize this node or remove it from tmp_list, and
> we can use list_for_each_entry().


I actually dont see the patch that removed the uprobe->pending_list.
I dont see it as part of the 7 that you sent yesterday. Nor does is it
part of the series that you sent today.

the uprobe_mmap_hash was required because we can do only one insert or
remove operation at a time. 

How are we going to synchronize uprobe_mmap() for two different vmas
that belong two different mms but map the same inode?

May be I am missing a patch somewhere.

-- 
thanks and regards
Srikar

