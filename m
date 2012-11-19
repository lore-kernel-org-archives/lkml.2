Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab2KSLCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:02:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:34323 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab2KSLCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:02:36 -0500
X-IronPort-AV: E=Sophos;i="4.83,279,1352044800"; 
   d="scan'208";a="6231151"
Message-ID: <50AA11BF.1090201@cn.fujitsu.com>
Date: Mon, 19 Nov 2012 19:02:23 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05/11] pidns: Make the pidns proc mount/umount logic obvious.
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-5-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1353083750-3621-5-git-send-email-ebiederm@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/19 19:02:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/19 19:02:22
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月17日 00:35, Eric W. Biederman 写道:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Track the number of pids in the proc hash table.  When the number of
> pids goes to 0 schedule work to unmount the kernel mount of proc.
> 
> Move the mount of proc into alloc_pid when we allocate the pid for
> init.
> 
> Remove the surprising calls of pid_ns_release proc in fork and
> proc_flush_task.  Those code paths really shouldn't know about proc
> namespace implementation details and people have demonstrated several
> times that finding and understanding those code paths is difficult and
> non-obvious.
> 
> Because of the call path detach pid is alwasy called with the
> rtnl_lock held free_pid is not allowed to sleep, so the work to
> unmounting proc is moved to a work queue.  This has the side benefit
> of not blocking the entire world waiting for the unnecessary
> rcu_barrier in deactivate_locked_super.
> 
> In the process of making the code clear and obvious this fixes a bug
> reported by Gao feng <gaofeng@cn.fujitsu.com> where we would leak a
> mount of proc during clone(CLONE_NEWPID|CLONE_NEWNET) if copy_pid_ns
> succeeded and copy_net_ns failed.
> 
> Acked-by: "Serge E. Hallyn" <serge@hallyn.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>
