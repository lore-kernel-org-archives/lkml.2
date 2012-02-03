Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab2BCQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:25:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49347 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab2BCQZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:25:25 -0500
Date: Fri, 3 Feb 2012 08:25:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
Message-ID: <20120203162519.GB805@google.com>
References: <1328267483-3225342-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328267483-3225342-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 02:11:23PM +0300, Andrew Vagin wrote:
> Zero is written at clear_tid_address, when the process exits.
> This functionality is used by pthread_join().
> 
> sys_set_tid_address() changes this address for current task.
> 
> Before this patch clear_tid_address could not be got from user space.
> I want to dump a full state of a task, so I need this address.
> Also I think it may be useful for debugging a multithreading program.
> 
> I am not sure that ptrace is suitable place. It may be added in prctl,
> but I think it's a bit useless and strange. I can't image a real
> situation (avoid checkpointing) when a thread will want to get own
> clear_tid_address from itself, this address is used by parent ussually.
> 
> Signed-off-by: Andrew Vagin <avagin@openvz.org>

Ummm... this really doesn't fit in ptrace.  Cyrill, why not put it
together with other params you're exporting?

Thanks.

-- 
tejun
