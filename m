Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab2BCQac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:30:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62014 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab2BCQab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:30:31 -0500
Date: Fri, 3 Feb 2012 20:30:25 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
Message-ID: <20120203163025.GI11834@moon>
References: <1328267483-3225342-1-git-send-email-avagin@openvz.org>
 <20120203162519.GB805@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203162519.GB805@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 08:25:19AM -0800, Tejun Heo wrote:
> On Fri, Feb 03, 2012 at 02:11:23PM +0300, Andrew Vagin wrote:
> > Zero is written at clear_tid_address, when the process exits.
> > This functionality is used by pthread_join().
> > 
> > sys_set_tid_address() changes this address for current task.
> > 
> > Before this patch clear_tid_address could not be got from user space.
> > I want to dump a full state of a task, so I need this address.
> > Also I think it may be useful for debugging a multithreading program.
> > 
> > I am not sure that ptrace is suitable place. It may be added in prctl,
> > but I think it's a bit useless and strange. I can't image a real
> > situation (avoid checkpointing) when a thread will want to get own
> > clear_tid_address from itself, this address is used by parent ussually.
> > 
> > Signed-off-by: Andrew Vagin <avagin@openvz.org>
> 
> Ummm... this really doesn't fit in ptrace.  Cyrill, why not put it
> together with other params you're exporting?
> 

We could add it to /proc/pid/stat (but I fear Andrew Morton shoot me then ;)

	Cyrill
